//
//  ActiveViewModel.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/18.
//

import SwiftUI

@Observable
final class ActiveViewModel:ObservableObject {
    var input = ActivityInput()
    var step: ActivityStep = .calculate
    var tab: ActivityTab = .LifeSavingsBank
    var isErrorMsg = false
}

// 管理活动输入内容
struct ActivityInput {
    // 人生存钱罐
    var age: Int? = nil
    var annualSalary: Int? = nil
    var lifeSavingsBank: Int? = nil
    // 生活保障金
    var livingExpenses: Int? = nil
    var guaranteeMonth: Int? = 6
    var emergencyFund: Int? = nil
}

enum ActivityStep {
    case calculate
    case create
    case loading
    case complete
}
