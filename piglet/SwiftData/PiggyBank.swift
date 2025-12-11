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
    var isPrimary: Bool = false// 标记主要存钱罐
    var name: String = "" // 存钱罐名称
    var icon: String = "apple.logo"   // 图标名称
    var amount: Double = 0   // 存钱罐金额
    var initialAmount: Double = 0 // 初始化金额，仅首次标记，用于后续展示
    var targetAmount: Double = 1  // 目标金额
    var creationDate: Date = Date()    // 创建日期
    var expirationDate: Date = Date()     // 截止日期
    var isExpirationDateEnabled: Bool = false   // 是否设置截止日期,true为设置了截止日期
    var isFixedDeposit: Bool = false  // 定期存款
    var fixedDepositType: String = FixedDepositEnum.day.rawValue   //  定期存款类型
    var fixedDepositAmount: Double = 0.0    // 定期存款金额
    var nextDepositDate: Date = Date()  // 最近一次定期存款日期
    var fixedDepositWeekday: Int = 1    // 定期存款-周几（1表示日，1表示一，范围1-7）
    var fixedDepositDay: Int = 1     // 定期存款-每月（1-31）
    var fixedDepositTime: Date = Date() // 定期存款-每天时分、每年月日
    var completionDate: Date = Date()    // 完成日期
    var sortOrder: Int = 0
    @Transient
    var progress: Double {  // 完成进度
        guard amount > 0, targetAmount > 0 else { return 0 }
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
    @Transient
    var progressText: String {  // 当前进度的String文本
        let truncated = floor(progress * 1000) / 1000
        return truncated.formatted(.percent.precision(.fractionLength(0...1)))
    }
    /// 与存钱记录的关系
    @Relationship(deleteRule: .cascade,inverse: \SavingsRecord.piggyBank)
    var records: [SavingsRecord]?
    
    init(isPrimary: Bool, name: String, icon: String, amount: Double, initialAmount: Double, targetAmount: Double, creationDate: Date, expirationDate: Date, isExpirationDateEnabled: Bool, isFixedDeposit:Bool, fixedDepositType:String = FixedDepositEnum.day.rawValue,fixedDepositAmount: Double = 0.0,nextDepositDate: Date = Date(), fixedDepositWeekday: Int = 1, fixedDepositDay: Int = 1, fixedDepositTime: Date = Date(), completionDate: Date = Date(), sortOrder:Int = 0) {
        self.isPrimary = isPrimary  // 标记主要存钱罐
        self.name = name    // 存钱罐名称
        self.icon = icon    // 存钱罐徒步
        self.amount = amount    // 存钱罐金额
        self.initialAmount = initialAmount  // 初始化金额
        self.targetAmount = targetAmount    // 目标金额
        self.creationDate = creationDate    // 创建日期
        self.expirationDate = expirationDate    // 截止日期
        self.isExpirationDateEnabled = isExpirationDateEnabled  // 是否设置截止日期
        self.isFixedDeposit = isFixedDeposit    // 定期存款
        self.fixedDepositType = fixedDepositType    // 定期存款类型
        self.fixedDepositAmount = fixedDepositAmount    // 定期存款金额
        self.nextDepositDate = nextDepositDate    // 定期存款日期
        self.fixedDepositWeekday = fixedDepositWeekday     // 定期存款-周（1-7）
        self.fixedDepositDay = fixedDepositDay     // 定期存款-日（1-31）
        self.fixedDepositTime = fixedDepositTime   // 定期存款-时分
        self.completionDate = completionDate
        self.sortOrder = sortOrder
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
        let carPiggyBank = PiggyBank(isPrimary: true,name: "奔驰车", icon: "car", amount: 40000, initialAmount: 40000, targetAmount: 380000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        let iPhonePiggyBank = PiggyBank(isPrimary: false, name: "iPhone 15 pro Max", icon: "iphone.gen2", amount: 5555, initialAmount: 5555, targetAmount: 8999, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        let housePiggyBank = PiggyBank(isPrimary: false, name: "新房子", icon: "building.2", amount: 0, initialAmount: 200000, targetAmount: 800000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        return [carPiggyBank, iPhonePiggyBank, housePiggyBank]
    }
}

enum FixedDepositEnum: String, CaseIterable, Identifiable {
    var id: String {
        self.rawValue
    }
    case day
    case week
    case month
    case year
}
