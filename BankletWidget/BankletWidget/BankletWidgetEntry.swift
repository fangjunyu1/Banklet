//
//  Untitled.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/12.
//

import WidgetKit
import SwiftUI

// Banklet显示的小组件条目
struct BankletWidgetEntry: TimelineEntry {
    var date: Date
    let piggyBankIcon: String
    let piggyBankName: String
    let piggyBankAmount: Double
    let piggyBankTargetAmount: Double
    let loopAnimation: String
    let background: String
}
