//
//  ActivityTab.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

enum ActivityTab: String, CaseIterable,Identifiable {
    var id: String { rawValue }
    case LifeSavingsBank  // 人生存钱罐
    case EmergencyFund    // 生活保障金
    
    // 标题
    var title: String {
        switch self {
        case .LifeSavingsBank:
            "Life savings jar"
        case .EmergencyFund:
            "Emergency Fund"
        }
    }
    
    // 描述
    var description: String {
        switch self {
        case .LifeSavingsBank:
            "lifetime wealth planning"
        case .EmergencyFund:
            "Maintain a sense of security in your life"
        }
    }
    
    // 图片
    var image: String {
        switch self {
        case .LifeSavingsBank:
            "life0"
        case .EmergencyFund:
            "life1"
        }
    }
}
