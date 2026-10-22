//
//  WelcomeView.swift
//  piglet
//
//  Created by 方君宇 on 2024/12/29.
//

import SwiftUI
import SwiftData

struct WelcomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    @State private var step: WelcomeStep = .welcome
    @State private var showPrivacyPolicy:Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // Lottie 动画
            LottieView(filename:  step.lottieName, isPlaying: true, playCount: 0, isReversed: false)
                .id(step.lottieName)
                .scaleEffect(1.2)
                .modifier(LottieModifier())
            
            Spacer().frame(height: 50)
            
            // 文字内容
            VStack(spacing: 15) {
                // 标题
                Text(step.title)
                    .modifier(LargeTitleModifier())
                // 副标题
                Text(step.subtitle)
                    .modifier(FootNoteModifier())
                Spacer().frame(height: 10)
                // 圆形进度条
                HStack {
                    Circle()
                        .frame(width: 8)
                    Circle()
                        .frame(width: 8)
                        .foregroundColor(step == .privacy ? colorScheme == .light ? .black : .white : .gray)
                }
            }
            
            Spacer()
            
            // 隐私政策-中文链接
            Button(action: {
                // 振动
                HapticManager.shared.selectionChanged()
                // 显示隐私政策视图
                showPrivacyPolicy = true
            }, label: {
                Text("Privacy Policy")
                    .modifier(FootNoteModifier())
            })
            .sheet(isPresented: $showPrivacyPolicy) {
                SafariView(url: URL(string: "https://fangjunyu.com/2024/05/23/%e5%ad%98%e9%92%b1%e7%8c%aa%e7%8c%aa-%e9%9a%90%e7%a7%81%e6%94%bf%e7%ad%96/")!, entersReaderIfAvailable: true)
                    .ignoresSafeArea()
            }
            .opacity(step == .privacy ? 1 : 0)
            Spacer().frame(height: 10)
            
            // 开始或完成-按钮
            Button(action: {
                // 振动
                HapticManager.shared.selectionChanged()
                
                if step == .welcome {
                    withAnimation {
                        step = .privacy
                    }
                } else {
                    appStorage.isCompletedWelcome = true
                }
            }, label: {
                Text(step == .welcome ? "Start" : "Completed")
                    .modifier(ButtonModifier())
            })
            Spacer()
                .frame(height: 50)
        }
        .padding(.horizontal,20)
    }
}

// 欢迎视图的步骤
enum WelcomeStep {
    case welcome
    case privacy
    
    var lottieName: String {
        switch self {
        case .welcome:
            "welcome"
        case .privacy:
            "security"
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .welcome:
            "Start your savings journey"
        case .privacy:
            "Privacy is in your control"
        }
    }
    
    var subtitle: LocalizedStringKey {
        switch self {
        case .welcome:
            "Welcome to a brand new way of saving, where every penny shines in the future."
        case .privacy:
            "Savings data is stored locally and synced with iCloud, ensuring security and transparency, and giving you complete control."
        }
    }
}

#Preview {
    WelcomeView()
        .environment(AppStorageManager.shared)
//     .environment(\.locale, .init(identifier: "de"))   // 设置语言为阿拉伯语
}
