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
    @State private var iapManager: IAPManager = IAPManager.shared   // AppStore 内购代码
    @State private var appStorage: AppStorageManager = AppStorageManager.shared // 集中管理 AppStorage
    @State private var modelConfigManager: ModelConfigManager = ModelConfigManager.shared   // ModelConfiguration 配置
    @State private var modelContainerManager: ModelContainerManager = ModelContainerManager.shared  // ModelContainer 容器
    @State private var sound = SoundManager.shared  // 音乐
    @State var avatarImage = AvatarImage.shared // 用户头像
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .task {
                    await iapManager.loadProduct()   // 加载产品信息
                    await iapManager.handleTransactions()   // 加载内购交易更新
                }
                .task(id: appStorage.avatarUpdatedUUID) {   // 更新头像 ID 后，刷新视图以获取最新头像
                    await avatarImage.loadAvatar(appStorage: appStorage)    // 加载用户头像
                }
        }
        .environment(sound) // 加载音乐环境
        .environment(appStorage)    // 加载 UserDefaults 属性环境
        .environment(iapManager)    // 加载内购商品环境
        .environment(modelConfigManager)    // ModelConfiguration
        .modelContainer(modelContainerManager.container)   // ModelContainer
    }
}
