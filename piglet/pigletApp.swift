//
//  pigletApp.swift
//  piglet
//
//  Created by 方君宇 on 2024/5/16.
//

import SwiftUI
import SwiftData

@main
struct pigletApp: App {
    @StateObject var iapManager = IAPManager.shared
    @State var appStorage = AppStorageManager.shared
    @State private var modelConfigManager = ModelConfigManager()
    //    @AppStorage("isModelConfigManager") var isModelConfigManager = true // 控制iCloud
    
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
                    await iapManager.checkAllTransactions()  // 先检查历史交易
                    await iapManager.handleTransactions()   // 加载内购交易更新
                }
        }
        .environment(modelConfigManager)
        .environment(appStorage)
        .environmentObject(iapManager)
        .modelContainer(try! ModelContainer(for: PiggyBank.self,SavingsRecord.self,configurations: modelConfigManager.currentConfiguration))
        
    }
}
