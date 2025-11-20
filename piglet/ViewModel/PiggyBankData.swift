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
    var name: String = ""  // 存钱罐名称
    var icon:String = "apple.logo"   // 图标名称
    var initialAmount: Double = 0.0 // 初始化金额，仅首次标记，用于后续展示
    var targetAmount: Double = 0.0  // 目标金额
    var amount: Double = 0.0   // 存钱罐金额
    var creationDate: Date = Date()    // 创建日期
    var expirationDate: Date = Date()     // 截止日期
    var isExpirationDateEnabled: Bool = false   // 是否设置截止日期
    var isPrimary: Bool = true // 标记主要存钱罐
}
