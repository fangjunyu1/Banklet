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
    // 数据版本 1：使用 amount、initialAmount、targetAmount
    // 数据版本 2：使用 SavingsRecord 计算余额，使用 optionalTargetAmount
    var dataVersion: Int = 1
    
    var isPrimary: Bool = false // 旧字段：暂时保留，后续不再用于列表管理
    var isPinned: Bool = false  // 新字段：是否置顶
    var name: String = "PiggyBank" // 存钱罐名称
    var icon: String = "piggybank"   // 图标名称
    
    // 新字段，数据版本 2
    var optionalTargetAmount: Double? = nil // 目标金额
    
    var creationDate: Date = Date()    // 创建日期
    
    // 新字段，数据版本 2
    var optionalExpirationDate: Date? = nil // 使用截止日期
    var isFixedDeposit: Bool = false  // 定期存款
    var fixedDepositType: String = FixedDepositEnum.Daily.rawValue   //  定期存款类型
    var fixedDepositAmount: Double = 0.0    // 定期存款金额
    var nextDepositDate: Date = Date()  // 最近一次定期存款日期
    var fixedDepositWeekday: Int = 1    // 定期存款-周几（1表示日，1表示一，范围1-7）
    var fixedDepositDay: Int = 1     // 定期存款-每月（1-31）
    var fixedDepositTime: Date = Date() // 定期存款-每天时分、每年月日
    
    // 新字段，数据版本 2
    var optionalCompletionDate: Date? = nil   // 完成日期
    var sortOrder: Int = 0  // 排序字段
    var customImageFilename: String? = nil  // 自定义愿望图片的文件名
    var bankType: String = PiggyBankType.normal.rawValue    // 存钱罐类型
    
    // MARK: 旧字段（废弃），仅数据版本 1 使用
    var amount: Double = 0   // 存钱罐金额
    var initialAmount: Double = 0 // 初始化金额，仅首次标记，用于后续展示
    var targetAmount: Double = 1  // 目标金额
    var expirationDate: Date = Date()     // 截止日期
    var isExpirationDateEnabled: Bool = false   // 是否设置截止日期,true为设置了截止日期
    var completionDate: Date = Date()    // 完成日期，当存起罐满的时候，更新完成时间
    
    /// 与存钱记录的关系
    @Relationship(deleteRule: .cascade,inverse: \SavingsRecord.piggyBank)
    var records: [SavingsRecord]?
    
    init(
        dataVersion: Int = 2,   // 数据版本
        name: String = "PiggyBank", // 存钱罐名称
        icon: String = "piggybank", // 图标名称
        optionalTargetAmount: Double? = nil,    // 目标金额
        creationDate: Date = Date(),    // 创建日期
        optionalExpirationDate: Date? = nil,    // 截止日期
        isFixedDeposit:Bool = false,    // 启用定期存款
        fixedDepositType:String = FixedDepositEnum.Daily.rawValue,  // 定期存款类型
        fixedDepositAmount: Double = 0.0,   // 定期存款金额
        fixedDepositWeekday: Int = 1,   // 定期存款-周（1-7）
        fixedDepositDay: Int = 1,   // 定期存款-日（1-31）
        fixedDepositTime: Date = Date(),    // 定期存款-每天/每年
        optionalCompletionDate: Date? = nil,  // 完成日期
        bankType: PiggyBankType = PiggyBankType.normal   // 存钱罐类型
    ) {
        self.dataVersion = dataVersion  // 数据版本
        self.name = name    // 存钱罐名称
        self.icon = icon    // 存钱罐图标
        self.optionalTargetAmount = optionalTargetAmount    // 新字段，可选目标金额
        self.creationDate = creationDate    // 创建时间
        self.optionalExpirationDate = optionalExpirationDate    // 新字段，可选截止日期
        self.isFixedDeposit = isFixedDeposit    // 定期存款
        self.fixedDepositType = fixedDepositType    // 定期存款类型
        self.fixedDepositAmount = fixedDepositAmount    // 定期存款金额
        self.fixedDepositWeekday = fixedDepositWeekday     // 定期存款-周（1-7）
        self.fixedDepositDay = fixedDepositDay     // 定期存款-日（1-31）
        self.fixedDepositTime = fixedDepositTime   // 定期存款-每天/每年
        self.optionalCompletionDate = optionalCompletionDate    // 新字段，可选完成日期
        self.bankType = bankType.rawValue    // 存钱罐类型
    }
}

// MARK: PiggyBank 计算属性
extension PiggyBank {
    
    // MARK: 当前余额
    var currentBalance: Double {
        records?.reduce(0.0) {
            $0 + ($1.saveMoney ? $1.amount : -$1.amount)
        } ?? 0
    }
    
    // MARK: 完成进度
    var progress: Double? {
        guard let targetAmount = effectiveTargetAmount,
              targetAmount > 0  else {
            return nil
        }
        
        return min(max(currentBalance / targetAmount, 0), 1)
    }
    
    // 完成进度（状态）
    var progressStatus: ProgressStatusTab {
        progress == 1 ? .done : .active
    }
    
    // 完成进度（字符串），示例： 10%
    var progressText: String {  // 当前进度的String文本
        progress?.formatted(.percent.precision(.fractionLength(0...1))) ?? ""
    }
    
    // 计算初始金额
    var effectiveInitialAmount: Double? {
        if dataVersion >= 2 {
            return nil
        }

        return initialAmount
    }
    
    // MARK: 目标金额(兼容版本 1)
    var effectiveTargetAmount: Double? {
        if dataVersion >= 2 {
            return optionalTargetAmount
        }

        return targetAmount
    }
    
    // 目标金额（字符串），示例： $100.0
    var targetAmountText: String? {  // 目标金额的String文本
        guard let effectiveTargetAmount = effectiveTargetAmount else {
            return nil
        }
        
        return Currency.currencySymbol
                + " "
                + effectiveTargetAmount.formattedWithTwoDecimalPlaces()
    }
    
    // 距离目标还差
//    var difference: Double {
//        let differenceNum = targetAmount - amount
//        return max(targetAmount - amount, 0)
//    }
    
    
    // 获取贴纸图片
    var getImg: String {
        IconList.getTextureName(name: icon)
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

        let now = Date()

        // 1. 奔驰车
        let piggyBank1 = PiggyBank(
            name: "奔驰车",
            icon: "car",
            optionalTargetAmount: 400_000,
            creationDate: now.addingTimeInterval(-86400 * 180),
            optionalExpirationDate: now.addingTimeInterval(86400 * 365),
            isFixedDeposit: false
        )

        // 2. iPhone 15 Pro Max
        let piggyBank2 = PiggyBank(
            name: "iPhone 15 Pro Max",
            icon: "iphone.gen2",
            optionalTargetAmount: 8_999,
            creationDate: now.addingTimeInterval(-86400 * 120),
            optionalExpirationDate: now.addingTimeInterval(86400 * 60)
        )

        // 3. 新房子
        let piggyBank3 = PiggyBank(
            name: "新房子",
            icon: "building.2",
            optionalTargetAmount: 800_000,
            creationDate: now.addingTimeInterval(-86400 * 300),
            optionalExpirationDate: now.addingTimeInterval(86400 * 730)
        )

        // 4. 大疆无人机
        let piggyBank4 = PiggyBank(
            name: "大疆",
            icon: "drones",
            optionalTargetAmount: 6_000,
            creationDate: now.addingTimeInterval(-86400 * 90)
        )

        // 5. Action 4
        let piggyBank5 = PiggyBank(
            name: "Action 4",
            icon: "actioncamera",
            optionalTargetAmount: 2_500,
            creationDate: now.addingTimeInterval(-86400 * 60)
        )

        // 6. 未来初音
        let piggyBank6 = PiggyBank(
            name: "未来初音",
            icon: "animefigurines",
            optionalTargetAmount: 3_000,
            creationDate: now.addingTimeInterval(-86400 * 45)
        )

        // 7. 游艇
        let piggyBank7 = PiggyBank(
            name: "游艇",
            icon: "boat",
            optionalTargetAmount: 1_000_000,
            creationDate: now.addingTimeInterval(-86400 * 200)
        )

        // 8. 天鹅洗衣机
        let piggyBank8 = PiggyBank(
            name: "天鹅洗衣机",
            icon: "washingmachine",
            optionalTargetAmount: 3_500,
            creationDate: now.addingTimeInterval(-86400 * 30)
        )

        // 9. 奔驰房车
        let piggyBank9 = PiggyBank(
            name: "奔驰房车",
            icon: "rv",
            optionalTargetAmount: 300_000,
            creationDate: now.addingTimeInterval(-86400 * 150)
        )

        // 10. 捷安特
        let piggyBank10 = PiggyBank(
            name: "捷安特",
            icon: "bicycle",
            optionalTargetAmount: 8_000,
            creationDate: now.addingTimeInterval(-86400 * 80)
        )

        // 11. 新房
        let piggyBank11 = PiggyBank(
            name: "新房",
            icon: "apartment",
            optionalTargetAmount: 1_500_000,
            creationDate: now.addingTimeInterval(-86400 * 250)
        )

        // 12. 爬山
        let piggyBank12 = PiggyBank(
            name: "爬山",
            icon: "mountain",
            optionalTargetAmount: 5_000,
            creationDate: now.addingTimeInterval(-86400 * 20)
        )

        // 13. 边牧
        let piggyBank13 = PiggyBank(
            name: "边牧",
            icon: "dog",
            optionalTargetAmount: 8_000,
            creationDate: now.addingTimeInterval(-86400 * 100)
        )

        return [
            piggyBank1,
            piggyBank2,
            piggyBank3,
            piggyBank4,
            piggyBank5,
            piggyBank6,
            piggyBank7,
            piggyBank8,
            piggyBank9,
            piggyBank10,
            piggyBank11,
            piggyBank12,
            piggyBank13
        ]
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

enum PiggyBankType: String, CaseIterable, Identifiable {
    var id: String {
        self.rawValue
    }
    case normal = "normal"          // 普通存钱罐
    case lifeSaving = "lifeSaving"  // 人生存钱罐
    case lifeFund = "lifeFund"      // 生活保障金
}
