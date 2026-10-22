//
//  HomeTab.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

enum HomeTab: Int, CaseIterable {
    case home
    case activity
    case settings
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .activity: return "flag.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .activity: return "Activity"
        case .settings: return "Settings"
        }
    }
}
