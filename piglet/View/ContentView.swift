//
//  ContentView.swift
//  piglet
//
//  Created by 方君宇 on 2024/12/28.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false  // false表示未通过人脸识别
    @State private var showHomeView = false
    @State private var isErrorMessage = false
    @State private var ZoomMainView = false
    @Environment(AppStorageManager.self) var appStorage
    
    // 密码保护方法
    func authenticate() {
        // 检查用户是否启用了生物识别验证
        guard appStorage.isBiometricEnabled else {
            print("用户已禁用生物识别认证。")
            return
        }
        // 振动
        HapticManager.shared.selectionChanged()
        BiometricAuth.shared.authenticate(reason: "请验证身份以访问您的帐户") { success, error in
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
        if !appStorage.isCompletedWelcome {
            WelcomeView()
        } else {
            // 用户启用密码 && 密码验证未通过 && 当前显示的不是 Home 视图
            // -> 显示密码验证视图
            if appStorage.isBiometricEnabled && !isAuthenticated && !showHomeView {
                BiometricAuthView(isAuthenticated: $isAuthenticated, isErrorMessage: $isErrorMessage) {
                    authenticate()
                }
            } else {
                Home()
                    .onAppear {
                        // 该变量标识进入Home视图，防止人脸识别影响已进入 Home 视图的问题
                        showHomeView = true
                    }
            }
        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(PiggyBank.preview)
        .environment(SoundManager.shared) // 加载音乐环境
        .environment(AppStorageManager.shared)    // 加载 UserDefaults 属性环境
        .environment(IAPManager.shared)    // 加载内购商品环境
        .environment(ModelConfigManager.shared)    // 加载 iCloud 配置环境
        .modelContainer(ModelContainerManager.shared.container)   // 加载 iCloud 容器环境
}
