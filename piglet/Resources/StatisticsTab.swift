//
//  StatisticsTab.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/2.
//
//  存钱罐完成状态
//

enum ProgressStatusTab: Int, CaseIterable {
    case all
    case inProgress
    case completed
    
    var title: String {
        switch self {
        case .all: return "All"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        }
    }
}
