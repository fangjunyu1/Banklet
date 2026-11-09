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
    // 数据版本
    // 数据版本 1:显示 initialAmount 和 targetAmount
    // 数据版本 2:显示 optionalTargetAmount 和 optionalInitialAmount
    var dataVersion: Int = 1
    
    var isPrimary: Bool = false // 旧字段：暂时保留，后续不再用于列表管理
    var isPinned: Bool = false  // 新字段：是否置顶
    var name: String = "" // 存钱罐名称
    var icon: String = "piggybank"   // 图标名称
    var amount: Double = 0   // 存钱罐金额
    
    // 旧字段，仅数据版本 1 使用
    var initialAmount: Double = 0 // 初始化金额，仅首次标记，用于后续展示
    var targetAmount: Double = 1  // 目标金额
    
    // 新字段，数据版本 2 使用
    var optionalTargetAmount: Double? = nil
    var optionalInitialAmount: Double? = nil
    
    var creationDate: Date = Date()    // 创建日期
    var expirationDate: Date = Date()     // 截止日期
    var isExpirationDateEnabled: Bool = false   // 是否设置截止日期,true为设置了截止日期
    var isFixedDeposit: Bool = false  // 定期存款
    var fixedDepositType: String = FixedDepositEnum.Daily.rawValue   //  定期存款类型
    var fixedDepositAmount: Double = 0.0    // 定期存款金额
    var nextDepositDate: Date = Date()  // 最近一次定期存款日期
    var fixedDepositWeekday: Int = 1    // 定期存款-周几（1表示日，1表示一，范围1-7）
    var fixedDepositDay: Int = 1     // 定期存款-每月（1-31）
    var fixedDepositTime: Date = Date() // 定期存款-每天时分、每年月日
    var completionDate: Date = Date()    // 完成日期，当存起罐满的时候，更新完成时间
    var sortOrder: Int = 0
    // 自定义愿望图片的文件名
    var customImageFilename: String? = nil
    
    /// 与存钱记录的关系
    @Relationship(deleteRule: .cascade,inverse: \SavingsRecord.piggyBank)
    var records: [SavingsRecord]?
    
    
    init(
        isPrimary: Bool = false,
        isPinned: Bool = false,
        name: String,
        icon: String,
        amount: Double,
        initialAmount: Double,
        targetAmount: Double,
        creationDate: Date,
        expirationDate: Date,
        isExpirationDateEnabled: Bool,
        isFixedDeposit:Bool,
        fixedDepositType:String = FixedDepositEnum.Daily.rawValue,
        fixedDepositAmount: Double = 0.0,
        nextDepositDate: Date = Date(),
        fixedDepositWeekday: Int = 1,
        fixedDepositDay: Int = 1,
        fixedDepositTime: Date = Date(),
        completionDate: Date = Date(),
        sortOrder:Int = 0,
        customImageFilename: String? = nil
    ) {
        self.isPrimary = isPrimary  // 标记主要存钱罐
        self.isPinned = isPinned    // 置顶存钱罐
        self.name = name    // 存钱罐名称
        self.icon = icon    // 存钱罐图标
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
        self.customImageFilename = customImageFilename
    }
}

// MARK: PiggyBank 计算属性
extension PiggyBank {
    // 完成进度
    var progress: Double {
        guard amount > 0, targetAmount > 0 else { return 0 }
        return min(max(amount / targetAmount, 0), 1)
    }
    
    // 计算初始金额
    var effectiveInitialAmount: Double? {
        if dataVersion >= 2 {
            return optionalInitialAmount
        }

        return initialAmount
    }
    
    // 计算目标金额
    var effectiveTargetAmount: Double? {
        if dataVersion >= 2 {
            return optionalTargetAmount
        }

        return targetAmount > 1 ? targetAmount : nil
    }
    
    // 距离目标还差
    var difference: Double {
        let differenceNum = targetAmount - amount
        return max(targetAmount - amount, 0)
    }
    
    // 当前金额 $10.0
    var amountText: String {    // 当前金额的String文本
        Currency.currencySymbol + " " + amount.formattedWithTwoDecimalPlaces()
    }
    // 目标金额 $100.0
    var targetAmountText: String {  // 目标金额的String文本
        Currency.currencySymbol + " " + targetAmount.formattedWithTwoDecimalPlaces()
    }
    // 当前进度 10%
    var progressText: String {  // 当前进度的String文本
        let truncated = floor(progress * 1000) / 1000
        return truncated.formatted(.percent.precision(.fractionLength(0...1)))
    }
    
    // 获取贴纸图片
    var getImg: String {
        IconList.getTextureName(name: icon)
    }
    
    // 当前完成进度
    var progressStatus: ProgressStatusTab {
        amount >= targetAmount && targetAmount > 0 ? .done : .active
    }
    
    // 排序用的置顶权重，置顶为 1，未置顶为 0
    var pinnedSortOrder: Int {
        isPinned ? 1 : 0
    }
    
}

// MARK: PiggyBank 静态预览数据
extension PiggyBank {
    
    @MainActor
    static var preview: ModelContainer {
        do {
            let container = try ModelContainer(
                for: PiggyBank.self, SavingsRecord.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
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
        let piggyBank1 = PiggyBank(isPrimary: true,name: "奔驰车", icon: "car", amount: 20000000, initialAmount: 300000, targetAmount: 40000000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        let piggyBank2 = PiggyBank(isPrimary: false, name: "iPhone 15 pro Max", icon: "iphone.gen2", amount: 5555, initialAmount: 5555, targetAmount: 8999, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        let piggyBank3 = PiggyBank(isPrimary: false, name: "新房子", icon: "building.2", amount: 0, initialAmount: 200000, targetAmount: 800000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        let piggyBank4 = PiggyBank(isPrimary: false, name: "大疆", icon: "drones", amount: 0, initialAmount: 200000, targetAmount: 800000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        let piggyBank5 = PiggyBank(isPrimary: false, name: "Action4", icon: "actioncamera", amount: 0, initialAmount: 200000, targetAmount: 800000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        let piggyBank6 = PiggyBank(isPrimary: false, name: "未来初音", icon: "animefigurines", amount: 0, initialAmount: 200000, targetAmount: 800000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        let piggyBank7 = PiggyBank(isPrimary: false, name: "游艇", icon: "boat", amount: 0, initialAmount: 200000, targetAmount: 800000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        let piggyBank8 = PiggyBank(isPrimary: false, name: "天鹅洗衣机", icon: "washingmachine", amount: 0, initialAmount: 200000, targetAmount: 800000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        let piggyBank9 = PiggyBank(isPrimary: false, name: "奔驰房车", icon: "rv", amount: 0, initialAmount: 200000, targetAmount: 800000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        let piggyBank10 = PiggyBank(isPrimary: false, name: "捷安特", icon: "bicycle", amount: 0, initialAmount: 200000, targetAmount: 800000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        let piggyBank11 = PiggyBank(isPrimary: false, name: "新房", icon: "apartment", amount: 0, initialAmount: 200000, targetAmount: 800000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        let piggyBank12 = PiggyBank(isPrimary: false, name: "爬山", icon: "mountain", amount: 0, initialAmount: 200000, targetAmount: 800000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        let piggyBank13 = PiggyBank(isPrimary: false, name: "边牧", icon: "dog", amount: 0, initialAmount: 200000, targetAmount: 800000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false)
        return [piggyBank1, piggyBank2, piggyBank3, piggyBank4, piggyBank5, piggyBank6, piggyBank7, piggyBank8, piggyBank9, piggyBank10, piggyBank11, piggyBank12, piggyBank13]
    }
}

enum FixedDepositEnum: String, CaseIterable, Identifiable {
    var id: String {
        self.rawValue
    }
    case Daily
    case Weekly
    case Monthly
    case Yearly
}
