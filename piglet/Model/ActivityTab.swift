//
//  ActivityTab.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

enum ActivityTab: String, CaseIterable,Identifiable {
    var id: String { rawValue }
    case LifeSavingsBank  // 人生存钱罐
    case LivingAllowance    // 生活保障金
    
    // 标题
    var title: String {
        switch self {
        case .LifeSavingsBank:
            "Life savings jar"
        case .LivingAllowance:
            "Living allowance"
        }
    }
    
    // 描述
    var description: String {
        switch self {
        case .LifeSavingsBank:
            "lifetime wealth planning"
        case .LivingAllowance:
            "Maintain a sense of security in your life"
        }
    }
    
    // 图片
    var image: String {
        switch self {
        case .LifeSavingsBank:
            "life0"
        case .LivingAllowance:
            "life1"
        }
    }
}
