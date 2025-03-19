//
//  ModelConfigManager.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/3.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class ModelConfigManager {
    
    var cloudKitMode: CloudKitMode = .privateDatabase {
        didSet {
            updateConfiguration()
        }
    }
    
    var currentConfiguration: ModelConfiguration = ModelConfiguration(
        "PrivateDatabaseContainer",
        cloudKitDatabase: .private("iCloud.com.fangjunyu.piglet")
    )
    
    func updateConfiguration() {
        switch cloudKitMode {
        case .none:
            currentConfiguration = ModelConfiguration(
                "LocalContainer",
                cloudKitDatabase: .none
            )
        case .privateDatabase:
            currentConfiguration = ModelConfiguration(
                "PrivateDatabaseContainer",
                cloudKitDatabase: .private("iCloud.com.fangjunyu.piglet")
            )
        case .publicDatabase:
            currentConfiguration = ModelConfiguration(
                "PublicDatabaseContainer",
                cloudKitDatabase: .automatic // 自动分配到公共数据库
            )
        }
    }
}

// 定义一个枚举，用于管理 CloudKit 配置状态
enum CloudKitMode {
    case none
    case privateDatabase
    case publicDatabase
}
