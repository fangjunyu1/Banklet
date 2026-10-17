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
    @State private var iapManager: IAPManager = IAPManager.shared
    @State private var appStorage: AppStorageManager = AppStorageManager.shared
    @State private var modelConfigManager: ModelConfigManager = ModelConfigManager.shared
    @State private var modelContainerManager: ModelContainerManager = ModelContainerManager.shared
    @State private var sound = SoundManager.shared
    @State var avatarImage = AvatarImage.shared
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await iapManager.loadProduct()   // 加载产品信息
                    await iapManager.handleTransactions()   // 加载内购交易更新
                }
                .task(id: appStorage.avatarUpdatedUUID) {
                    await avatarImage.loadAvatar(appStorage: appStorage)
                }
        }
        .environment(sound) // 加载音乐环境
        .environment(appStorage)    // 加载 UserDefaults 属性环境
        .environment(iapManager)    // 加载内购商品环境
        .environment(modelConfigManager)    // ModelConfiguration
        .modelContainer(modelContainerManager.container)   // ModelContainer
    }
}
