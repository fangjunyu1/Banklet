//
//  Settings.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/9.
//

import SwiftUI
import DeviceKit

struct Settings: View {
    @Environment(\.openURL) var openURL
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(ModelConfigManager.self) var modelConfigManager    // 从环境中读取modelConfigManager
    @Environment(AppStorageManager.self) var appStorage
    @Environment(\.dismiss) var dismiss
    
    @State private var showNonFunctionalView = false
    @State private var showSponsoredApps = false
    @State private var showThanksView = false
    @State private var showAboutUs = false
    @State private var showThanks = false
    @State private var showGeneral = false
    @State private var showOpenSource = false // 显示开源视图
    @State private var showAlert = false    // 重制UserDefaults
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.95
                ZStack {
                    Color(hex: colorScheme == .light ?  "f0f0f0" : "0E0E0E")
                        .ignoresSafeArea()
                    // 设置列表
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing:0) {
                            // 第一组：赞助应用
                            //                            if appStorage.isShowInAppPurchase {
                            VStack(spacing: 0) {
                                // 内购完成
                                if appStorage.isInAppPurchase {
                                    InAppPurchaseCompletionButton(action: {
                                        showThanksView.toggle()
                                    }, content: {
                                        Image(systemName: "checkmark.seal.fill")
                                            .padding(.horizontal,5)
                                            .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                        Text("A")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .imageScale(.small)
                                            .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                    })
                                } else {
                                    // 未完成内购的场景
                                    // 赞助应用按钮
                                    SettingButton(action: {
                                        showSponsoredApps = true
                                    }, content: {
                                        Image(systemName: "checkmark.seal")
                                            .padding(.horizontal,5)
                                            .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                        Text("Sponsored Apps")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .imageScale(.small)
                                            .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                    })
                                }
                            }
                            .padding(10)
                            //                            }
                            
                            // 第二组：启用iCloud、通用、辅助功能
                            // 功能不完善、临时隐藏
                            Group {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("iCloud is in beta, so please be careful when switching on and off.")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.8)
                                }
                                .padding(.horizontal,15)
                                .padding(.top,10)
                                VStack(spacing: 0) {
                                    // 分割线
                                    Divider().padding(.leading,50)
                                    // 通用功能
                                    NavigationLink(destination: GeneralView()){
                                        SettingView(content: {
                                            Image(systemName: "gear")
                                                .padding(.horizontal,5)
                                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                            Text("General")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .imageScale(.small)
                                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                        })
                                    }
                                    
                                    // 如果内购完成，解锁辅助功能。
                                    if showNonFunctionalView {
                                        // 辅助功能按钮
                                        SettingButton(action: {
                                            showGeneral.toggle()
                                        }, content: {
                                            Image(systemName: "accessibility")
                                                .padding(.horizontal,5)
                                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                            Text("Accessibility")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5) // 最小缩放到 50%
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .imageScale(.small)
                                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                        })
                                        
                                    }
                                }
                                
                                .background(colorScheme == .light ? .white : Color(hex:"1f1f1f"))
                                .cornerRadius(10)
                                .padding(10)
                            }
                            
                            // 第四组：关于我们、鸣谢
                            VStack(spacing: 0) {
                                // 关于我们
                                SettingButton(action: {
                                    showAboutUs.toggle()
                                }, content: {
                                    Image(systemName: "figure.2")
                                        .font(.caption)
                                        .padding(.horizontal,5)
                                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                    Text("About Us")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .imageScale(.small)
                                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                })
                                //                                if appStorage.isShowAboutUs { }
                                // 分割线
                                Divider().padding(.leading,50)
                                //                                if appStorage.isShowThanks && appStorage.isShowAboutUs {    }
                                // 鸣谢
                                SettingButton(action: {
                                    showThanks.toggle()
                                }, content: {
                                    Image(systemName: "questionmark.circle")
                                        .padding(.horizontal,5)
                                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                    Text("Thanks")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .imageScale(.small)
                                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                })
                                //                                if appStorage.isShowThanks {}
                                // 分割线
                                Divider().padding(.leading,50)
                                // 开源
                                SettingButton(action: {
                                    showOpenSource.toggle()
                                }, content: {
                                    Image(systemName: "fossil.shell")
                                        .font(.subheadline)
                                        .padding(.horizontal,5)
                                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                    Text("Open source")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .imageScale(.small)
                                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                })
                            }
                            .background(colorScheme == .light ? .white : Color(hex:"1f1f1f"))
                            .cornerRadius(10)
                            .padding(10)
                            
                            Spacer().frame(height: 40)
                            Group {
                                Text(LocalizedStringKey("Version Number")) +  Text(" : ") +  Text("\(Bundle.main.appVersion).\(Bundle.main.appBuild)")
#if DEBUG
                                Spacer().frame(height:20)
                                Button("重置内购标识") {
                                    showAlert = true
                                }
                                .alert("是否重置内购标识？", isPresented: $showAlert) {
                                    // 确定
                                    Button("确定", role: .destructive) {
                                        AppStorageManager.shared.isInAppPurchase = false
                                    }
                                } message: {
                                    Text("是否重制内购标识？")
                                }
#endif
                            }
                            .foregroundColor(Color(hex: "D6D6D7"))
                            .font(.footnote)
                            //                            .onTapGesture(count: 2) {
                            //                                if appStorage.isInAppPurchase {
                            //                                    appStorage.isShowInAppPurchase.toggle()
                            //                                }
                            //                            }
                            Spacer()
                            
                        }
                        .navigationTitle("Settings")
                        .navigationBarTitleDisplayMode(.inline)
                        .frame(width: width)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button(action: {
                                    dismiss()
                                }, label: {
                                    Text("Completed")
                                        .fontWeight(.bold)
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Settings()
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environment(AppStorageManager.shared)
    //        .environment(\.locale, .init(identifier: "de"))
}
