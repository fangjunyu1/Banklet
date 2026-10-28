//
//  StatisticsTab.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/2.
//
//  HomeView 存钱罐完成进度
//

enum ProgressStatusTab: Int, CaseIterable {
    case all
    case active
    case done
    case expiring
    
    var title: String {
        switch self {
        case .all: return "all"
        case .active: return "active"
        case .expiring: return "expiring"
        case .done: return "done"
        }
    }
}
