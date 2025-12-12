//
//  PiggyBankDraft.swift
//  piglet
//
//  Created by 方君宇 on 2025/12/4.
//

import SwiftUI
import SwiftData

struct PiggyBankDraft {
    var isPrimary: Bool // 标记主要存钱罐
    var name: String
    var icon: String
    var amount: Double
    var initialAmount: Double
    var targetAmount: Double
    var creationDate: Date  // 创建日期
    var expirationDate: Date    // 截止日期
    var isExpirationDateEnabled: Bool   // 是否设置截止日期,true为设置了截止日期
    var isFixedDeposit: Bool  // 定期存款
    var fixedDepositType: String   //  定期存款类型
    var fixedDepositAmount: Double   // 每次存款金额
    var nextDepositDate: Date   // 定期存款日期
    var fixedDepositWeekday: Int    // 定期存款-每周
    var fixedDepositDay: Int    // 定期存款-每月
    var fixedDepositTime: Date    // 定期存款-每天时分、每年月日
    var completionDate: Date    // 完成日期
    var sortOrder:Int   // 排序字段
    // 只读字段 
    var progress: Double    // 进度
    var difference: Double
    var amountText: String
    var targetAmountText: String
    var progressText: String
    
    
    init(from model: PiggyBank) {
        self.isPrimary = model.isPrimary
        self.name = model.name
        self.icon = model.icon
        self.amount = model.amount
        self.initialAmount = model.initialAmount
        self.targetAmount = model.targetAmount
        self.creationDate = model.creationDate
        self.expirationDate = model.expirationDate
        self.isExpirationDateEnabled = model.isExpirationDateEnabled
        self.isFixedDeposit = model.isFixedDeposit
        self.fixedDepositType = model.fixedDepositType
        self.fixedDepositAmount = model.fixedDepositAmount
        self.nextDepositDate = model.nextDepositDate
        self.fixedDepositWeekday = model.fixedDepositWeekday
        self.fixedDepositDay = model.fixedDepositDay
        self.fixedDepositTime = model.fixedDepositTime
        self.completionDate = model.completionDate
        self.sortOrder = model.sortOrder
        // 只读字段
        self.progress = model.progress
        self.difference = model.difference
        self.amountText = model.amountText
        self.targetAmountText = model.targetAmountText
        self.progressText = model.progressText
    }
    
    func apply(to model: PiggyBank,context:ModelContext) {
        model.isPrimary = isPrimary
        model.name = name
        model.icon = icon
        model.amount = amount
        model.initialAmount = initialAmount
        model.targetAmount = targetAmount
        model.creationDate = creationDate
        model.expirationDate = expirationDate
        model.isExpirationDateEnabled = isExpirationDateEnabled
        model.isFixedDeposit = isFixedDeposit
        model.fixedDepositType = fixedDepositType
        model.fixedDepositAmount = fixedDepositAmount
        model.nextDepositDate = nextDepositDate
        model.fixedDepositWeekday = fixedDepositWeekday
        model.fixedDepositDay = fixedDepositDay
        model.fixedDepositTime = fixedDepositTime
        model.completionDate = completionDate
        model.sortOrder = sortOrder
        do {
            try context.save()
        } catch {
            print("保存失败")
        }
    }
}
