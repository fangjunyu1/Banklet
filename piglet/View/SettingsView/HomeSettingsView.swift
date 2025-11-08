//
//  HomeSettingsView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI
import SwiftData
import MessageUI

struct HomeSettingsView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appStorage: AppStorageManager
    @Environment(ModelConfigManager.self) var modelConfigManager
    @State private var showTermsofUse = false   // 使用条款SafariView
    @State private var showPrivacyPolicy = false    // 隐私政策SafariView
    @State private var showMailComposer = false // 显示邮箱
    @State private var showMailError = false    // 邮箱报错信息
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LottieView(filename: appStorage.LoopAnimation, isPlaying: appStorage.isLoopAnimation, playCount: 0, isReversed: false)
                .frame(height: 100)
                .offset(y: -10)
            
            VStack(spacing: 10) {
                // 启用iCloud
                HomeSettingRow(color: .color("226AD6"),icon: .sficon("icloud.fill"),title: "Enable iCloud",footnote:"iCloud is in beta, so please be careful when switching on and off.", accessory: .toggle($appStorage.isModelConfigManager, modelConfigManager))
                // 通用
                HomeSettingRow(color: .color("A422D6"), icon: .img("general"), title: "General",footnote: "Configure the application's background, animations, icons, and other related parameters.", accessory:.none)
                
                // 问题反馈、使用条款、隐私政策
                VStack(spacing: 0) {
                    // 问题反馈
                    Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                            showMailComposer.toggle()
                        } else {
                            if !showMailError {
                                withAnimation {
                                    showMailError = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        showMailError = false
                                    }
                                }
                            }
                            print("不支持邮箱")
                        }
                    }, label: {
                        HomeSettingRow(color: .color("E79B34"), icon: .sficon("questionmark.circle.fill"), title: "Problem Reporting",accessory: .remark("E-mail"))
                    })
                    .sheet(isPresented: $showMailComposer) {
                        MailView()
                            .ignoresSafeArea()
                    }
                    Divider().padding(.leading,60)
                    // 使用条款
                    Button(action: {
                        showTermsofUse = true
                    }, label: {
                        HomeSettingRow(color: .color("E64E5A"), icon: .sficon("book.pages.fill"), title: "Terms of Use",accessory: .remark("Web page"))
                    })
                    .sheet(isPresented: $showTermsofUse) {
                        SafariView(url: URL(string: "https://fangjunyu.com/2024/06/03/%e5%ad%98%e9%92%b1%e7%8c%aa%e7%8c%aa-%e4%bd%bf%e7%94%a8%e6%9d%a1%e6%ac%be/")!, entersReaderIfAvailable: true)
                            .ignoresSafeArea()
                    }
                    Divider().padding(.leading,60)
                    // 隐私政策
                    Button(action: {
                        showPrivacyPolicy = true
                    }, label: {
                        HomeSettingRow(color: .color("1CB02E"), icon: .sficon("lock.fill"), title: "Privacy Policy",accessory: .remark("Web page"))
                    })
                    .sheet(isPresented: $showPrivacyPolicy) {
                        SafariView(url: URL(string: "https://fangjunyu.com/2024/05/23/%e5%ad%98%e9%92%b1%e7%8c%aa%e7%8c%aa-%e9%9a%90%e7%a7%81%e6%94%bf%e7%ad%96/")!, entersReaderIfAvailable: true)
                            .ignoresSafeArea()
                    }
                }
                .background(colorScheme == .dark ? AppColor.appGrayColor : .white)
                .cornerRadius(10)
                
                // 高级会员
                HomeSettingRow(color: .line("9A4CF3", "6025E2"), icon: .img("vip"), title: "Premium Member",accessory: .none)
                
                // 关于我们、鸣谢、开源
                VStack(spacing: 0) {
                    // 关于我们
                    NavigationLink(destination: {
                        AboutUsView()
                    }, label: {
                        HomeSettingRow(color: .color("226AD6"), icon: .sficon("person.2.fill"), title: "About Us",accessory: .none)
                    })
                    Divider().padding(.leading,60)
                    // 鸣谢
                    NavigationLink(destination: {
                        ThanksView()
                    }, label: {                        HomeSettingRow(color: .color("E45050"), icon: .sficon("heart.fill"), title: "Thanks",accessory: .none)
                    })
                    Divider().padding(.leading,60)
                    // 开源
                    NavigationLink(destination: {
                        OpenSourceView()
                    }, label: {
                        HomeSettingRow(color: .color("EAA22A"), icon: .img("OpenSource"), title: "Open source",accessory: .none)
                    })
                }
                .background(colorScheme == .dark ? AppColor.appGrayColor : .white)
                .cornerRadius(10)
                
                // 版本号
                Text("version: \(Bundle.main.appVersion)")
                    .font(.caption2)
                    .foregroundColor(AppColor.gray)
            }
#if DEBUG
            Spacer().frame(height:20)
            // 重置内购和欢迎界面
            Button(action: {
                AppStorageManager.shared.isInAppPurchase = false
                AppStorageManager.shared.hasCompletedWelcome = false
            }, label: {
                Text("重置内购和欢迎界面")
                    .font(.caption2)
                    .foregroundColor(.gray)
            })
#endif
            
            Spacer()
                .frame(height:70)
        }
        .navigationTitle("Settings")
        .padding(.horizontal, 20)
        .overlay {
            if showMailError {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "xmark")
                        Text("E-mail not configured")
                    }
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding(10)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    Spacer().frame(height: 20)
                }
            }
        }
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
