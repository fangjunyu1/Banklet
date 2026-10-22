//
//  ActivityTab.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

enum ActivityTab: String, CaseIterable,Identifiable {
    var id: String { rawValue }
    case LifePiggy  // 人生存钱罐
    case LifeFund    // 生活保障金
    
    // 标题
    var title: String {
        switch self {
        case .LifePiggy:
            "LifePiggy"
        case .LifeFund:
            "LifeFund"
        }
    }
    
    // 描述
    var description: String {
        switch self {
        case .LifePiggy:
            "lifetime wealth planning"
        case .LifeFund:
            "Maintain a sense of security in your life"
        }
    }
    
    // 图片
    var image: String {
        switch self {
        case .LifePiggy:
            "life0"
        case .LifeFund:
            "life1"
        }
    }
}
