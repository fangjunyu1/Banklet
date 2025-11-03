//
//  HomeSettingsView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI
import SwiftData

struct HomeSettingsView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    @Environment(ModelConfigManager.self) var modelConfigManager
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                LottieView(filename: appStorage.LoopAnimation, isPlaying: appStorage.isLoopAnimation, playCount: 0, isReversed: false)
                    .scaleEffect(3.6)
                    .frame(height: 60)
                Spacer()
            }
            
        }
        .navigationTitle("Settings")
    }
}

private struct PreviewHomeSettingsView: View {
    var body: some View {
        NavigationStack {
            HomeSettingsView()
                .background {
                    AppColor.appBgGrayColor
                        .ignoresSafeArea()
                }
        }
    }
}
#Preview {
    PreviewHomeSettingsView()
        .environment(ModelConfigManager())  // iCloud配置
        .environmentObject(IAPManager.shared)
        .environment(AppStorageManager.shared)
}
