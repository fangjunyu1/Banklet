//
//  ContentView.swift
//  piglet
//
//  Created by 方君宇 on 2024/12/28.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false  // false表示未通过人脸识别
    @State private var piggyBankData: PiggyBankData? =  PiggyBankData()
    @State private var showHomeView = false
    @State private var isErrorMessage = false
    @State private var ZoomMainView = false
    @Environment(AppStorageManager.self) var appStorage
    
    // 密码保护方法
    func authenticate() {
        // 检查用户是否启用了生物识别验证
        guard appStorage.isBiometricEnabled else {
            print("Biometric authentication is disabled by the user.")
            return
        }
        BiometricAuth.shared.authenticate(reason: "Authenticate to access your account") { success, error in
            if success {
                isAuthenticated = true
                isErrorMessage = false
            } else {
                isAuthenticated = false
                isErrorMessage = true
            }
        }
    }
    
    var body: some View {
        if !appStorage.hasCompletedWelcome {
            WelcomeView()
        } else {
            if appStorage.isBiometricEnabled && !isAuthenticated && !showHomeView {
                BiometricAuthView(isAuthenticated: $isAuthenticated, isErrorMessage: $isErrorMessage) {
                    authenticate()
                }
            } else {
                Home()
                    .onAppear {
                        // 该变量标识进入Home视图
                        // 进入Home视图后，显示true
                        // 防止在设置人脸识别功能后
                        // 立即弹出人脸识别的功能
                        showHomeView = true
                    }
            }
        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(PiggyBank.preview)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environment(AppStorageManager.shared)
        .environmentObject(IAPManager.shared)
}
