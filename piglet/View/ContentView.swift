//
//  ContentView.swift
//  piglet
//
//  Created by 方君宇 on 2024/12/28.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("pageSteps") var pageSteps: Int = 1
    @AppStorage("isBiometricEnabled") var isBiometricEnabled = false   // true表示启用密码保护
    @State private var isAuthenticated = false  // false表示未通过人脸识别
    @State private var piggyBankData: PiggyBankData? =  PiggyBankData()
    @State private var showContentView = false
    @State private var isErrorMessage = false
    @State private var ZoomMainView = false
    
    // 密码保护方法
    func authenticate() {
        // 检查用户是否启用了生物识别验证
        guard isBiometricEnabled else {
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
        if pageSteps == 1 {
            WelcomeView(pageSteps: $pageSteps)
        } else if pageSteps == 2 {
            PrivacyPage(pageSteps: $pageSteps)
        } else if pageSteps == 3 {
            CreatePiggyBankPage1(pageSteps: $pageSteps, piggyBankData: Binding(
                get: { piggyBankData ?? PiggyBankData() },
                set: { piggyBankData = $0 })
            )
        } else if pageSteps == 4 {
            CreatePiggyBankPage2(pageSteps: $pageSteps,piggyBankData: Binding(
                get: { piggyBankData ?? PiggyBankData() },
                set: { piggyBankData = $0 })
            )
        } else if pageSteps == 5 {
            CompletedView(pageSteps: $pageSteps,piggyBankData: Binding(
                get: { piggyBankData ?? PiggyBankData() },
                set: { piggyBankData = $0 })
            )
        }
        else {
            
            if isBiometricEnabled && !isAuthenticated && !showContentView {
                // 当设置人脸识别，并且人脸识别为false时显示验证视图
                BiometricAuthView(isAuthenticated: $isAuthenticated,isErrorMessage:$isErrorMessage) {
                    authenticate()
                }
            } else {
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    Home()
                        .onAppear {
                            showContentView = true
                        }
                }
            }
        }
    }
    
}

#Preview {
    @StateObject var iapManager = IAPManager.shared
    return ContentView()
        .modelContainer(PiggyBank.preview)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(iapManager)
}
