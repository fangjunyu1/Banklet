//
//  GeneralView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/15.
//

import SwiftUI
import UserNotifications

struct GeneralView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appStorage: AppStorageManager
    @State private var Notification = false
    
    var body: some View {
        ScrollView {
            Spacer().frame(height: 10)
            // 外层，分隔所有组件视图
            VStack(spacing: 10) {
                // 图标、动画、背景
                VStack(spacing: 0) {
                    // 图标
                    if UIApplication.shared.supportsAlternateIcons {
                        NavigationLink(destination: AppIconView()) {
                            HomeSettingRow(color: .color("EAA22A"),icon: .img("icon"),title: "icon", accessory: .none)
                        }
                        Divider().padding(.leading,60)
                    }
                    // 动画
                    NavigationLink(destination: AnimationView()) {
                        HomeSettingRow(color: .color("56BCA6"),icon: .img("Animation"),title: "Animation", accessory: .none)
                    }
                    Divider().padding(.leading,60)
                    // 背景
                    NavigationLink(destination: BackgroundView()) {
                        HomeSettingRow(color: .color("3477F5"),icon: .img("Background"),title: "Background", accessory: .none)
                    }
                }
                .modifier(SettingVStackRowModifier())
                
                // 静默模式
                GeneralSilentRow(title: "Silent Mode",footnote: "After waiting for 10 seconds, hide the main view buttons and only show the animation.", mode:$appStorage.isSilentMode)
                
                // 货币符号
                NavigationLink(destination: CurrencySymbolView() ) {
                    HomeSettingRow(color: .color("6025E2"),icon: .img("CurrencySymbol"),title: "Currency Symbol",footnote: "The piggy bank displays the currency symbol; currency conversion is not currently supported.", accessory: .none)
                }
                
                // 音效、振动、提醒时间、密码保护、存取备注
                VStack(spacing: 0) {
                    // 音效
                    HomeSettingRow(color: .color("E64E5A"),icon: .img("SoundEffects"),title: "Sound effects", accessory: .binding($appStorage.isSoundEffects))
                    Divider().padding(.leading,60)
                    // 振动
                    HomeSettingRow(color: .color("9E0AB4"),icon: .img("Vibration"),title: "Vibration", accessory: .binding($appStorage.isVibration))
                    Divider().padding(.leading,60)
                    // 提醒时间
                    HomeSettingRow(color: .color("0682C4"),icon: .img("ReminderTime"),title: "Reminder time", accessory: .reminder($Notification))
                    Divider().padding(.leading,60)
                    // 密码保护
                    HomeSettingRow(color: .color("B1A507"),icon: .img("password"),title: "Password protection", accessory: .binding($appStorage.isBiometricEnabled))
                    Divider().padding(.leading,60)
                    // 存取备注
                    HomeSettingRow(color: .color("EAA22A"),icon: .img("AccessNotes"),title: "Access Notes", accessory: .binding($appStorage.isAccessNotes))
                }
                .modifier(SettingVStackRowModifier())
            }
            .overlay {
                if Notification { NoNotice() }
            }
        }
        .navigationTitle("General")
        .modifier(BackgroundModifier())
    }
}

private struct NoNotice: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("No notification permission")
            }
            .modifier(ToastTipsModifier())
            Spacer().frame(height: 20)
        }
    }
}
#Preview {
    NavigationStack {
        GeneralView()
            .environment(AppStorageManager.shared)
    }
}
