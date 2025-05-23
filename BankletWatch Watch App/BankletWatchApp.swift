//
//  BankletWatchApp.swift
//  BankletWatch Watch App
//
//  Created by 方君宇 on 2025/2/18.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct BankletWatch_Watch_AppApp: App {
    
    @State private var modelConfigManager = ModelConfigManager()
    @AppStorage("isModelConfigManager") var isModelConfigManager = true // 控制iCloud
    
    init() {
        let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("授权失败：\(error.localizedDescription)")
                } else {
                    print("授权结果：\(granted ? "允许" : "拒绝")")
                }
            }
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .onAppear{
                if isModelConfigManager {
                    // isModelConfigManager为 true 时，设置为私有iCloud
                    modelConfigManager.cloudKitMode = .privateDatabase
                } else {
                    // isModelConfigManager为 false 时，设置为空
                    modelConfigManager.cloudKitMode = .none
                }
            }
        }
        .modelContainer(try! ModelContainer(for: PiggyBank.self,SavingsRecord.self,configurations: modelConfigManager.currentConfiguration))
    }
}
