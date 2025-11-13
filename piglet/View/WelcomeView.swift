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
    
    var LottieName: String {
        if step == .welcome {
            return "welcome"
        } else if step == .privacy {
            return "security"
        } else {
            return "welcome"
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            // Welcome 动画
            LottieView(filename:  LottieName, isPlaying: true, playCount: 0, isReversed: false)
                .id(LottieName)
                .scaleEffect(step == .welcome ? 1: 1.5)
                .modifier(LottieModifier2())
            Spacer().frame(height: 50)
            // 文字内容
            VStack(spacing: 15) {
                // 标题
                Text(step == .welcome ? "Start your savings journey" : "Privacy is in your control")
                    .modifier(LargeTitleModifier())
                // 副标题
                Text(step == .welcome ? "Welcome to a brand new way of saving, where every penny shines in the future." : "Savings data is stored locally and synced with iCloud, ensuring security and transparency, and giving you complete control.")
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
                if step == .welcome {
                    withAnimation {
                        step = .privacy
                        print("LottieName:\(LottieName)")
                    }
                } else {
                    print("是否完成欢迎界面？\(appStorage.isCompletedWelcome)")
                    appStorage.isCompletedWelcome = true
                }
            }, label: {
                Text(step == .welcome ? "Start" : "Completed")
                    .modifier(ButtonModifier())
            })
            Spacer()
                .frame(height: 50)
        }
        .padding(.horizontal,10)
    }
}

// 欢迎视图的步骤
enum WelcomeStep {
    case welcome
    case privacy
}

#Preview {
    WelcomeView()
        .environment(AppStorageManager.shared)
    // .environment(\.locale, .init(identifier: "de"))   // 设置语言为阿拉伯语
}
