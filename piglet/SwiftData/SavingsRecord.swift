//
//  SavingsRecord.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/11.
//

import SwiftUI
import SwiftData

enum SavingsRecordType: String,Identifiable {
    var id: String {
        self.rawValue
    }
    
    case manual     // 用户手动存/取
    case automatic  // 系统按频率自动执行的定期存款
}

@Model
class SavingsRecord {
    var amount: Double = 0.0     // 存取金额
    var date: Date = Date()  // 存钱的日期
    var saveMoney: Bool = false // 存取为 true，取钱为 false
    var note: String? = nil  // 可选的备注信息
    var type: String = SavingsRecordType.manual.rawValue
    @Transient
    var amountText: String {    // 当前金额的String文本
        currencySymbol + " " + amount.formattedWithTwoDecimalPlaces()
    }
    var piggyBank: PiggyBank? 
    
    init(amount: Double, date: Date = Date(), saveMoney:Bool, note: String? = nil, piggyBank: PiggyBank? = nil, type: String? = nil) {
        self.amount = amount
        self.date = date
        self.saveMoney = saveMoney
        self.note = note
        self.piggyBank = piggyBank
        self.type = type ?? SavingsRecordType.manual.rawValue
    }
}
