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
    func purchaseProduct(_ product: Product) async {
        // 在这里输出要购买的商品id
        print("Purchasing product: \(product.id)")
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):    // 购买成功的情况，返回verification包含交易的验证信息
                let transaction = try checkVerified(verification)    // 验证交易
                
                print("产品购买成功！商品 ID: \(product.id)，商品名称: \(product.displayName)，商品描述: \(product.description)，价格: \(product.price)，本地化价格: \(product.displayPrice)，商品类型: \(product.type),订阅商品信息：\(product.subscription),\(product.type)")
                
                savePurchasedState(for: product.id)    // 更新UserDefaults中的购买状态
                await transaction.finish()    // 告诉系统交易完成
                print("交易成功：\(result)")
            case .userCancelled:    // 用户取消交易
                print("用户取消交易：\(result)")
            case .pending:    // 购买交易被挂起
                print("购买交易被挂起：\(result)")
            default:    // 其他情况
                throw StoreError.failedVerification    // 购买失败
            }
        } catch {
            print("购买失败：\(error)")
            await resetProduct()    // 购买失败后重置 product 以便允许再次尝试购买
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
    
    // handleTransactions处理所有的交易情况
    func handleTransactions() async {
        print("进入handleTransactions方法")
        for await result in Transaction.updates {
            // 遍历当前所有已完成的交易
            do {
                let transaction = try checkVerified(result) // 验证交易
                print("当前已完成的交易:\(transaction)")
                
                if !AppStorageManager.shared.isValidMember {
                    print("当前不是内购状态，但是内购已完成")
                    // 处理交易，例如解锁内容
                    savePurchasedState(for: transaction.productID)
                } else {
                    print("当前时内购状态，不需要重复设置")
                }
                await transaction.finish()
            } catch {
                print("交易处理失败：\(error)")
            }
        }
    }
    
    // 检查所有交易，如果用户退款，则取消内购标识。
    func checkAllTransactions() async {
        print("开始检查所有交易记录...")
        let allTransactions = Transaction.all
        var latestTransactions: [String: Transaction] = [:]
        
        for await transaction in allTransactions {
            do {
                let verifiedTransaction = try checkVerified(transaction)
                print("verifiedTransaction:\(verifiedTransaction)")
                // 只保留最新的交易
                if let existingTransaction = latestTransactions[verifiedTransaction.productID] {
                    if verifiedTransaction.purchaseDate > existingTransaction.purchaseDate {
                        latestTransactions[verifiedTransaction.productID] = verifiedTransaction
                    }
                } else {
                    latestTransactions[verifiedTransaction.productID] = verifiedTransaction
                }
            } catch {
                print("交易验证失败：\(error)")
            }
        }
        
        var validPurchasedProducts: Set<String> = []
        
        // 处理最新的交易
        for (productID, transaction) in latestTransactions {
            if let revocationDate = transaction.revocationDate {
                print("交易 \(productID) 已退款，撤销日期: \(revocationDate)")
                removePurchasedState(for: productID)
            } else {
                validPurchasedProducts.insert(productID)
                savePurchasedState(for: productID)
            }
        }
        
        // **移除所有未在最新交易中的商品**
        let allPossibleProductIDs: Set<String> = Set(IAPProductList.map { $0.id }) // 所有可能的商品 ID
        let productsToRemove = allPossibleProductIDs.subtracting(validPurchasedProducts)
        
        for id in productsToRemove {
            removePurchasedState(for: id)
        }
    }
    
    // 重新加载产品信息。
    func resetProduct() async {
        self.products = []
        await loadProduct()    // 调取loadProduct方法获取产品信息
    }
    
    // 保存商品状态
    func savePurchasedState(for productID: String) {
//        AppStorageManager.shared.isInAppPurchase = true
        print("保存购买状态: \(productID)")
    }
    
    // 恢复内购状态
    func restoredPurchasesStatus() {
        print("点击了恢复内购按钮")
    }
    
    // 移除内购状态
    func removePurchasedState(for productID: String) {
        UserDefaults.standard.removeObject(forKey: productID)
        print("已移除购买状态: \(productID)")
    }
    
    // 通过productID检查是否已完成购买
    func loadPurchasedState(for productID: String) -> Bool{
        let isPurchased = UserDefaults.standard.bool(forKey: productID)    // UserDefaults读取购买状态
        print("Purchased state loaded for product: \(productID) - \(isPurchased)")
        return isPurchased    // 返回购买状态
    }
}
// 定义 throws 报错
enum StoreError: Error {
    case IAPInformationIsEmpty
    case failedVerification
    case invalidURL
    case serverVerificationFailed
}
