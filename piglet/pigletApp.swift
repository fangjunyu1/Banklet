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
    @State private var modelConfigManager = ModelConfigManager()
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
        .environmentObject(iapManager)
        .modelContainer(try! ModelContainer(for: PiggyBank.self,SavingsRecord.self,configurations: modelConfigManager.currentConfiguration))
    }
}
