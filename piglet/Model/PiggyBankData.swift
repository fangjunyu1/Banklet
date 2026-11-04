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

//struct PiggyBankData {
//    var isPrimary: Bool = false // 旧字段：暂时保留，后续不再用于列表管理
//    var isPinned: Bool = false  // 新字段：是否置顶
//    var name: String = ""  // 存钱罐名称
//    var icon:String = "piggybank"   // 图标名称
//    var amount: Double? = 0   // 存钱罐金额
//    var initialAmount: Double? = 0 // 初始化金额，仅首次标记，用于后续展示
//    var targetAmount: Double? = 1  // 目标金额
//    var creationDate: Date = Date()    // 创建日期
//    var expirationDate: Date = Date()     // 截止日期
//    var isExpirationDateEnabled: Bool = false   // 是否设置截止日期
//    var isFixedDeposit:Bool = false   // 是否设置定额存款
//    var fixedDepositType: String = FixedDepositEnum.Daily.rawValue
//    var fixedDepositAmount: Double = 0.0   // 定期金额
//    var nextDepositDate: Date = Date()  // 下一次存取时间
//    var fixedDepositWeekday: Int = 1    // 每周存取
//    var fixedDepositDay: Int = 1    // 每月存取
//    var fixedDepositTime: Date = Date() // 每天、每年存取
//    var completionDate: Date = Date()   // 完成日期
//    var sortOrder: Int = 0
//}
