//
//  pigletApp.swift
//  piglet
//
//  Created by 方君宇 on 2024/5/16.
//

import SwiftUI
import SwiftData
import WatchConnectivity

@main
struct pigletApp: App {
    @State private var iapManager = IAPManager.shared
    @State private var appStorage = AppStorageManager.shared
    @State private var modelConfigManager = ModelConfigManager.shared
    @State private var dataController = DataController.shared
    @State private var sound = SoundManager.shared
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        if appStorage.isModelConfigManager {
            // isModelConfigManager为 true 时，设置为私有iCloud
            modelConfigManager.cloudKitMode = .privateDatabase
        } else {
            // isModelConfigManager为 false 时，设置为空
            modelConfigManager.cloudKitMode = .none
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await iapManager.loadProduct()   // 加载产品信息
                    await iapManager.handleTransactions()   // 加载内购交易更新
                }
        }
        .environment(sound)
        .environment(appStorage)
        .environment(iapManager)
        .environment(modelConfigManager)
        .modelContainer(dataController.container)
    }
}
