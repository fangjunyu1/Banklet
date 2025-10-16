//
//  SavingsRecord.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/11.
//

import SwiftUI
import SwiftData

@Model
class SavingsRecord {
    var amount: Double = 0.0     // 存取金额
    var date: Date = Date()  // 存钱的日期
    var saveMoney: Bool = false // 存取为 true，取钱为 false
    var note: String? = nil  // 可选的备注信息
    
    // 反向关系：与 PiggyBank 关联
    @Relationship(inverse: \PiggyBank.records)
    var piggyBank: PiggyBank? 
    
    init(amount: Double, date: Date = Date(), saveMoney:Bool, note: String? = nil, piggyBank: PiggyBank? = nil) {
        self.amount = amount
        self.date = date
        self.saveMoney = saveMoney
        self.note = note
        self.piggyBank = piggyBank
    }
}
