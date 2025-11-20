//
//  CreateStep.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/19.
//

import SwiftUI

enum CreateStep: Int,CaseIterable {
    case name   // 名称
    case targetAmount   // 目标金额
    case icon   // 图标
    case amount  // 金额和初始金额
    case expirationDate // 截止日期
    case complete   // 完成
    
    var index: Int {
        self.rawValue + 1
    }
    var count: Int {
        Self.allCases.count
    }
    
    var isLast: Bool {
        self == Self.allCases.last
    }
}
