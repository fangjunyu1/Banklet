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
class ModelConfigManager: ObservableObject {
    static let shared = ModelConfigManager(
        appStorage: AppStorageManager.shared
    )
    
    private init(appStorage: AppStorageManager) {
        print("进入 ModelConfigManager 构造函数")
        if appStorage.isModelConfigManager {
            cloudKitMode = .privateDatabase
        } else {
            cloudKitMode = .none
        }
        print("完成 ModelConfigManager 构造函数")
    }
    
    var cloudKitMode: CloudKitMode
    
    var currentConfiguration: ModelConfiguration {
        switch cloudKitMode {
        case .none:
            ModelConfiguration(
                "LocalContainer",
                cloudKitDatabase:  .none
            )
        case .privateDatabase:
            ModelConfiguration(
                "PrivateDatabaseContainer",
                cloudKitDatabase: .private("iCloud.com.fangjunyu.piglet")
            )
        case .automaticDatabase:
            ModelConfiguration(
                "AutomaticDatabaseContainer",
                cloudKitDatabase: .automatic
            )
        }
    }
}

// 定义一个枚举，用于管理 CloudKit 配置状态
enum CloudKitMode {
    case none
    case privateDatabase
    case automaticDatabase
}
