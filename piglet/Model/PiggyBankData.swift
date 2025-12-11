//
//  PiggyBankData.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/2.
//
//  临时的PiggyBank变量

import SwiftUI

@Observable
class PiggyBankData: ObservableObject {
    var isPrimary: Bool = true // 标记主要存钱罐
    var name: String = ""  // 存钱罐名称
    var icon:String = "apple.logo"   // 图标名称
    var amount: Double? = nil   // 存钱罐金额
    var initialAmount: Double? = nil // 初始化金额，仅首次标记，用于后续展示
    var targetAmount: Double? = nil  // 目标金额
    var creationDate: Date = Date()    // 创建日期
    var expirationDate: Date = Date()     // 截止日期
    var isExpirationDateEnabled: Bool = false   // 是否设置截止日期
    var isFixedDeposit:Bool = false   // 是否设置定额存款
    var fixedDepositType: String = FixedDepositEnum.day.rawValue
    var fixedDepositAmount: Double? = nil   // 定期金额
    var nextDepositDate: Date = Date()  // 下一次存取时间
    var fixedDepositWeekday: Int = 1    // 每周存取
    var fixedDepositDay: Int = 1    // 每月存取
    var fixedDepositTime: Date = Date() // 每天、每年存取
}
