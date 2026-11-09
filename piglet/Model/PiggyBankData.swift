//
//  PiggyBankData.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/2.
//
//  临时的PiggyBank变量

import SwiftUI

struct PiggyBankData {
    var isPrimary: Bool = false // 旧字段：暂时保留，后续不再用于列表管理
    var isPinned: Bool = false  // 新字段：是否置顶
    var name: String = ""  // 存钱罐名称
    var icon:String = "piggybank"   // 图标名称
    var amount: Double?   // 存钱罐金额
    var initialAmount: Double? // 初始化金额，仅首次标记，用于后续展示
    var targetAmount: Double?  // 目标金额
    var creationDate: Date = Date()    // 创建日期
    var expirationDate: Date = Date()     // 截止日期
    var isExpirationDateEnabled: Bool = false   // 是否设置截止日期
    var isFixedDeposit:Bool = false   // 是否设置定额存款
    var fixedDepositType: String = FixedDepositEnum.Daily.rawValue
    var fixedDepositAmount: Double?   // 定期金额
    var nextDepositDate: Date = Date()  // 下一次存取时间
    var fixedDepositWeekday: Int = 1    // 每周存取
    var fixedDepositDay: Int = 1    // 每月存取
    var fixedDepositTime: Date = Date() // 每天、每年存取
    var completionDate: Date = Date()   // 完成日期
    var sortOrder: Int = 0
}

extension PiggyBankData {

    // MARK: 返回对应数据类型
    // 完成进度
    var progress: Double {
        guard let amount = amount,
              let targetAmount = targetAmount,
              amount > 0,
              targetAmount > 0
        else {
            return 0
        }
        return min(max(amount / targetAmount, 0), 1)
    }
    
    // 距离目标还差
    var difference: Double {
        guard let targetAmount = targetAmount, let amount = amount else {
            return 0
        }
        
        return max(targetAmount - amount, 0)
    }
    
    // MARK: 返回对应字符串类型
    // 当前金额 $10.0
    var amountText: String {    // 当前金额的String文本
        let value = amount ?? 0
        return Currency.currencySymbol
                + " "
                + value.formattedWithTwoDecimalPlaces()
    }
    
    // 目标金额 $100.0
    var targetAmountText: String {  // 目标金额的String文本
        let value = targetAmount ?? 0
        return Currency.currencySymbol
                + " "
                + value.formattedWithTwoDecimalPlaces()
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
    
    /// 排序用的置顶权重，置顶为 1，未置顶为 0
    var pinnedSortOrder: Int {
        isPinned ? 1 : 0
    }
}
