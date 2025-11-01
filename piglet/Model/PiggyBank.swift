//
//  PiggyBank.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/2.
//

import SwiftData
import SwiftUI

@Model
class PiggyBank {
    var name: String = ""  // 存钱罐名称
    var icon:String = ""   // 图标名称
    var initialAmount: Double = 0.0 // 初始化金额，仅首次标记，用于后续展示
    var targetAmount: Double = 0.0  // 目标金额
    var amount: Double = 0.0   // 存钱罐金额
    var creationDate: Date = Date()    // 创建日期
    var expirationDate: Date = Date()     // 截止日期
    var isExpirationDateEnabled: Bool = false   // 是否设置截止日期,true为设置了截止日期
    var isPrimary: Bool = false // 标记主要存钱罐
    var completionDate: Date = Date()    // 完成日期
    @Transient
    var progress: Double {  // 完成进度
        guard targetAmount > 0 else { return 0 }
        return amount / targetAmount
    }
    @Transient
    var difference: Double {    // 差额
        let differenceNum = targetAmount - amount
        return differenceNum > 0 ? differenceNum : 0.0
    }
    @Transient
    var amountText: String {    // 当前金额的String文本
        currencySymbol + " " + amount.formattedWithTwoDecimalPlaces()
    }
    @Transient
    var targetAmountText: String {  // 目标金额的String文本
        currencySymbol + " " + targetAmount.formattedWithTwoDecimalPlaces()
    }
    /// 与存钱记录的关系
    @Relationship(deleteRule: .cascade)
    var records: [SavingsRecord]?
    
    init(name: String, icon: String, initialAmount: Double, targetAmount: Double, amount: Double, creationDate: Date, expirationDate: Date, isExpirationDateEnabled: Bool,isPrimary: Bool) {
        self.name = name
        self.icon = icon
        self.initialAmount = initialAmount
        self.targetAmount = targetAmount
        self.amount = amount
        self.creationDate = creationDate
        self.expirationDate = expirationDate
        self.isExpirationDateEnabled = isExpirationDateEnabled
        self.isPrimary = isPrimary
    }
    
    @MainActor
    static var preview: ModelContainer {
        do {
            let container = try ModelContainer(
                for: PiggyBank.self, SavingsRecord.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true,cloudKitDatabase: .none)
            )
            let context = container.mainContext
            for piggyBank in PiggyBanks {
                context.insert(piggyBank)
                // 如果需要，手动插入 SavingsRecord
                let records = [
                    SavingsRecord(amount: 18,saveMoney: true,piggyBank:piggyBank),
                    SavingsRecord(amount: 20,saveMoney: false,piggyBank:piggyBank),
                    SavingsRecord(amount: 36,saveMoney: false,note: "fangjunyu.com",piggyBank:piggyBank)
                ]
                for record in records {
                    piggyBank.records?.append(record) // 通过关系自动管理
                }
            }
            try context.save()
            return container
        } catch {
            fatalError("Failed to create preview ModelContainer: \(error)")
        }
    }
    
    static var PiggyBanks: [PiggyBank] {
        let carPiggyBank = PiggyBank(name: "奔驰车", icon: "car", initialAmount: 40000, targetAmount: 380000, amount: 40000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isPrimary: true)
        let iPhonePiggyBank = PiggyBank(name: "iPhone 15 pro Max", icon: "iphone.gen2", initialAmount: 5555, targetAmount: 8999, amount: 5555, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isPrimary: false)
        let housePiggyBank = PiggyBank(name: "新房子", icon: "building.2", initialAmount: 200000, targetAmount: 800000, amount: 0, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isPrimary: false)
        
        return [carPiggyBank, iPhonePiggyBank, housePiggyBank]
    }
}
