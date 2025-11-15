//
//  IAPManager.swift
//  piglet
//
//  Created by 方君宇 on 2024/5/29.
//

import StoreKit

// 内购商品结构
struct IAPProduct {
    var name: String    // 本地展示名，如 “按月”
    var id: String  // App Store 产品 ID
    var priceSuffix: String?    // 价格后缀，如 “/月” 或 “/年”
}

@available(iOS 15.0, *)
@MainActor
@Observable
class IAPManager:ObservableObject {
    static let shared = IAPManager()
    
    private init() {}
    
    // 商品信息-价格映射表
    let IAPProductList: [IAPProduct] = [    //  需要内购的产品ID数组
        IAPProduct(name: "Monthly", id: "com.fangjunyu.Banklet.monthly", priceSuffix: "Month"),
        IAPProduct(name: "Yearly", id: "com.fangjunyu.Banklet.yearly", priceSuffix: "Year"),
        IAPProduct(name: "Lifetime", id: "20240523")
    ]
    
    var products: [Product] = []    // 存储从 App Store 获取的内购商品信息
    
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
            products = fetchedProducts  // 将获取的内购商品保存到products变量
            print("成功加载产品: \(products)")    // 输出内购商品数组信息
        } catch {
            print("加载产品失败：\(error)")    // 输出报错
        }
    }
    
    // purchaseProduct：购买商品的方法，返回购买结果
    func purchaseProduct(_ product: Product,completion:(Bool) -> Void) async {
        // 在这里输出要购买的商品id
        print("Purchasing product: \(product.id)")
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):    // 购买成功的情况，返回verification包含交易的验证信息
                let transaction = try checkVerified(verification)    // 验证交易
                updatePurchasedState(from: transaction)    // 更新内购商品的购买状态
                await transaction.finish()    // 告诉系统交易完成
                completion(true)
                print("交易成功：\(result)")
            case .userCancelled:    // 用户取消交易
                print("用户取消交易：\(result)")
                completion(false)
            case .pending:    // 购买交易被挂起
                print("购买交易被挂起：\(result)")
                completion(false)
            default:    // 其他情况
                completion(false)
                throw StoreError.failedVerification    // 购买失败
            }
        } catch {
            print("购买失败：\(error)")
            completion(false)
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
    func checkAllTransactions() async {
        print("进入 checkAllTransactions 方法，检查所有交易")
        for await result in Transaction.all {
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
    
    // 更新内购商品状态
    func updatePurchasedState(from transaction: Transaction) {
        let productID = transaction.productID
        print("进入内购商品状态，产品ID：\(productID)")
        
        // ========== 永久会员逻辑 =========
        if productID == "20240523" {
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
            AppStorageManager.shared.expirationDate = expiration.timeIntervalSince1970
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
        self.products = []
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
