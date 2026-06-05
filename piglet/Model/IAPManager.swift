//
//  IAPManager.swift
//  piglet
//
//  Created by 方君宇 on 2024/5/29.
//

import StoreKit
import SwiftUI

// 内购商品结构
struct IAPProduct {
    var name: String    // 本地展示名，如 “按月”
    var id: String  // App Store 产品 ID
    var priceSuffix: LocalizedStringKey    // 价格后缀，如 “/月” 或 “/年”
    var tag: LocalizedStringKey?    // 标签，早鸟价，买断制
    var tagColor: Color?    // 标签颜色
    var isRecommend: Bool   // 是否推荐
}

struct IAPDisplayProduct: Identifiable {
    let product: Product        // StoreKit 返回的真实商品
    let info: IAPProduct        // 你自己配置的展示信息
    
    var id: String {
        product.id
    }
    
    var displayName: String {
        product.displayName
    }
    
    var displayPrice: String {
        product.displayPrice
    }
}

@available(iOS 15.0, *)
@MainActor
@Observable
class IAPManager:ObservableObject {
    static let shared = IAPManager()
    
    private init() {}
    
    private let oneTimeID = "20240523"
    
    // 商品信息-价格映射表
    let IAPProductList: [IAPProduct] = [    //  需要内购的产品ID数组
        IAPProduct(name: "By Month", id: "com.fangjunyu.Banklet.monthly", priceSuffix: "Month", isRecommend: false),
        IAPProduct(name: "By Year", id: "com.fangjunyu.Banklet.yearly", priceSuffix: "Year", tag: "Early Bird", tagColor: Color(hex: "3477F5"), isRecommend: false),
        IAPProduct(name: "Lifetime", id: "20240523", priceSuffix: "Lifetime",  tag: "One-Time", tagColor: Color(hex: "FF8140"), isRecommend: true)
    ]
    
    // 产品信息
    private(set) var displayProducts: [IAPDisplayProduct] = []    // 存储从 App Store 获取的内购商品信息
    
    // 获取产品信息的方法
    func loadProduct() async {
        do {
            // 传入 productID 产品ID数组，调取Product.products接口从App Store返回产品信息
            // App Store会返回对应的产品信息，如果数组中个别产品ID有误，只会返回正确的产品ID的产品信息
            let fetchedProducts = try await Product.products(for: IAPProductList.map { $0.id} )
            if fetchedProducts.isEmpty {    // 判断返回的是否是否为空
                // 抛出内购信息为空的错误,可能是所有的产品ID都不存在，中断执行，不会return返回products产品信息
                throw StoreError.IAPInformationIsEmpty
            }
            displayProducts = IAPProductList.compactMap { iapProduct in  // 将获取的内购商品保存到 products 变量
                guard let storeProduct = fetchedProducts.first(where: { $0.id == iapProduct.id }) else {
                    return nil
                }
                return IAPDisplayProduct(
                    product: storeProduct,
                    info: iapProduct
                )
            }
            print("成功加载产品: \(displayProducts)")    // 输出内购商品数组信息
        } catch {
            print("加载产品失败：\(error)")    // 输出报错
        }
    }
    
    // purchaseProduct：购买商品的方法，返回购买结果
    func purchaseProduct(_ product: Product,completion:(ProductResultEnum) -> Void) async {
        // 在这里输出要购买的商品id
        print("Purchasing product: \(product.id)")
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):    // 购买成功的情况，返回verification包含交易的验证信息
                let transaction = try checkVerified(verification)    // 验证交易
                updatePurchasedState(from: transaction)    // 更新内购商品的购买状态
                await transaction.finish()    // 告诉系统交易完成
                completion(.purchaseSuccess)
                print("交易成功：\(result)")
            case .userCancelled:    // 用户取消交易
                print("用户取消交易：\(result)")
                completion(.stateless)
            case .pending:    // 购买交易被挂起
                print("购买交易被挂起：\(result)")
                completion(.purchaseFailed)
            default:    // 其他情况
                completion(.purchaseFailed)
                throw StoreError.failedVerification    // 购买失败
            }
        } catch {
            print("购买失败：\(error)")
            completion(.purchaseFailed)
            await resetProduct()    // 购买失败后重置 product 以便允许再次尝试购买
        }
    }
    
    // handleTransactions处理所有的交易情况
    func handleTransactions() async {
        print("交易发生变动，进入 handleTransactions 方法")
        for await result in Transaction.updates {
            // 遍历当前所有已完成的交易
            do {
                let transaction = try checkVerified(result) // 验证交易
                updatePurchasedState(from: transaction)
                await transaction.finish()
            } catch {
                print("交易处理失败：\(error)")
            }
        }
    }
    
    // 检查所有交易，如果用户退款，则取消内购标识。
    func checkAllTransactions(state:(ProductResultEnum) -> Void) async {
        print("进入 checkAllTransactions 方法，检查所有交易")
        
        var latestExpiration: Date?
        var lifetimePurchased = false
        
        for await result in Transaction.all {
            // 遍历当前所有已完成的交易
            do {
                let transaction = try checkVerified(result) // 验证交易
                // --- 1. 永久会员逻辑 -----
                if transaction.productID == oneTimeID {
                    print("进入永久会员逻辑")
                    if transaction.revocationDate == nil {
                        print("永久会员没有退款，新增永久会员标识")
                        lifetimePurchased = true
                    }
                    print("永久会员退款，下一个")
                    continue   // 不 return，只是跳过本次循环
                }
                
                // --- 2. 订阅逻辑 -------
                if let revoke = transaction.revocationDate {
                    print("订阅商品有退款，订阅时间为nil")
                    // 有退款就清空
                    latestExpiration = nil
                    continue
                }
                
                // --- 3. 订阅时间逻辑 -------
                if let expiration = transaction.expirationDate {
                    // 多订阅，取最新过期时间（有效期最长的）
                    latestExpiration = max(latestExpiration ?? expiration, expiration)
                    print("最新的订阅时间:\(latestExpiration?.formatted() ?? "Nil")")
                }
                
                // --- 4. 完成订阅 -------
                await transaction.finish()
            } catch {
                print("交易处理失败：\(error)")
                state(ProductResultEnum.restoreFailed)
                return
            }
        }
        
        // ---- 扫描完成后统一更新状态 ----
        AppStorageManager.shared.isLifetime = lifetimePurchased
        
        print("全部扫描完成，更新状态，永久会员标识:\(lifetimePurchased),最近的订阅时间:\(latestExpiration?.formatted() ?? "Nil")")
        
        if let exp = latestExpiration {
            AppStorageManager.shared.expirationDate = exp.timeIntervalSince1970
        } else {
            AppStorageManager.shared.expirationDate = 0
        }
        
        // 如果会员有效时间大于当前时间，或者有永久会员，返回成功
        // 否则，返回失败
        
        let hasValidSubscription = latestExpiration.map { $0 > Date() } ?? false
        print("是否有会员？:\(hasValidSubscription)")
        
        if lifetimePurchased || hasValidSubscription {
            print("当前是会员，返回 .restoreSuccess")
            state(ProductResultEnum.restoreSuccess)
        } else {
            print("不是任何会员，返回 .restoreFailed ")
            state(ProductResultEnum.restoreFailed)
        }
    }
    
    // 更新内购商品状态
    func updatePurchasedState(from transaction: StoreKit.Transaction) {
        let productID = transaction.productID
        print("进入内购商品状态，产品ID：\(productID)")
        
        // ========== 永久会员逻辑 =========
        if productID == oneTimeID {
            if transaction.revocationDate != nil {
                // 清理永久会员标识
                print("永久会员退款，清空标识")
                print("订阅商品信息:\(transaction)")
                AppStorageManager.shared.isLifetime = false
            } else {
                print("购买永久会员，新增标识")
                print("商品订购日期:\(transaction.purchaseDate)")
                print("订阅商品信息:\(transaction)")
                AppStorageManager.shared.isLifetime = true
            }
            return
        }
        
        // ============ 订阅商品逻辑 ===========
        // 订阅退款
        if transaction.revocationDate != nil {
            print("订阅商品退款，清空高级会员有效期")
            print("订阅商品信息:\(transaction)")
            AppStorageManager.shared.expirationDate = 0
            return
        }
        
        if let expiration = transaction.expirationDate {
            print("当前时间:\(Date())")
            print("商品订购日期:\(transaction.purchaseDate)")
            print("订阅商品有效期为:\(expiration)，同步高级会员有效期")
            print("订阅商品信息:\(transaction)")
            let newValue = expiration.timeIntervalSince1970
            let currentValue = AppStorageManager.shared.expirationDate
            AppStorageManager.shared.expirationDate = max(newValue, currentValue)
            return
        }
    }
    
    // 验证购买结果
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:    // unverified校验失败，StoreKit不能确定交易有效
            print("校验购买结果失败")
            throw StoreError.failedVerification
        case .verified(let signedType):    // verfied校验成功
            print("校验购买结果成功")
            return signedType    // StoreKit确认本笔交易信息由苹果服务器合法签署
        }
    }
    
    // 重新加载产品信息。
    func resetProduct() async {
        displayProducts = []
        await loadProduct()    // 调取loadProduct方法获取产品信息
    }
}
// 定义 throws 报错
enum StoreError: Error {
    case IAPInformationIsEmpty
    case failedVerification
    case invalidURL
    case serverVerificationFailed
}
