//
//  Settings.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/9.
//

import SwiftUI

struct Settings: View {
    @Environment(\.openURL) var openURL
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(ModelConfigManager.self) var modelConfigManager    // 从环境中读取modelConfigManager
    @Environment(\.dismiss) var dismiss
    @State private var showNonFunctionalView = false
    @State private var showSponsoredApps = false
    @State private var showThanksView = false
    @State private var showAboutUs = false
    @State private var showThanks = false
    @State private var showGeneral = false
    @State private var showOpenSource = false // 显示开源视图
    @AppStorage("20240523") var isInAppPurchase = false // 内购完成后，设置为true
    @AppStorage("isShowAboutUs") var isShowAboutUs = true
    // false表示隐藏
    @AppStorage("isShowInAppPurchase") var isShowInAppPurchase = true
    // 控制内购按钮，false表示隐藏
    @AppStorage("isShowThanks") var isShowThanks = true
    // 控制鸣谢页面，false表示隐藏
    
    
    
    func sendEmail() {
        let email = "fangjunyu.com@gmail.com"
        let subject = "Banklet Feedback"
        let body = "Hi fangjunyu,\n\n"
        
        // URL 编码参数
        let urlString = "mailto:\(email)?subject=\(subject)&body=\(body)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: urlString ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                // 处理无法打开邮件应用的情况
                print("Cannot open Mail app.")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.95
                let height = geometry.size.height * 0.85
                
                ZStack {
                    Color(hex: colorScheme == .light ?  "f0f0f0" : "0E0E0E")
                        .ignoresSafeArea()
                    // 设置列表
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing:0) {
                            // 第一组：赞助应用
                            if isShowInAppPurchase {
                                VStack(spacing: 0) {
                                    // 内购完成
                                    if isInAppPurchase {
                                        InAppPurchaseCompletionButton(action: {
                                            showThanksView.toggle()
                                        }, content: {
                                            Image(systemName: "checkmark.seal.fill")
                                                .padding(.horizontal,5)
                                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                            Text("Thanks for your support")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(Color(hex:"D8D8D8"))
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
                                                .foregroundColor(Color(hex:"D8D8D8"))
                                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                        })
                                    }
                                }
                                .padding(10)
                            }
                            
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
                                    // 启用iCloud按钮
                                    SettingView(content: {
                                        Image(systemName: "icloud")
                                            .padding(.horizontal,5)
                                            .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                        Text("Enable iCloud")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5) // 最小缩放到 50%
                                        Spacer()
                                        Toggle("",isOn: Binding(get: {
                                            modelConfigManager.cloudKitMode == .privateDatabase
                                        }, set: {
                                            modelConfigManager.cloudKitMode = $0 ? .privateDatabase : .none
                                        }))  // iCloud开关
                                        .frame(height:0)
                                    })
                                    // 分割线
                                    Rectangle()
                                        .frame(maxWidth:.infinity)
                                        .frame(height: 0.5)
                                        .foregroundColor(.gray)
                                        .padding(.leading, 60)
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
                                                .foregroundColor(Color(hex:"D8D8D8"))
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
                                                .foregroundColor(Color(hex:"D8D8D8"))
                                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                        })
                                        
                                    }
                                }
                                
                                .background(colorScheme == .light ? .white : Color(hex:"1f1f1f"))
                                .cornerRadius(10)
                                .padding(10)
                            }
                            
                            // 第三组：问题反馈、使用条款、隐私政策
                            VStack(spacing: 0) {
                                // 问题反馈
                                SettingButton(action: {
                                    sendEmail()
                                }, content: {
                                    Image(systemName: "questionmark.circle")
                                        .padding(.horizontal,5)
                                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                    Text("Problem Reporting")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(hex:"D8D8D8"))
                                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                })
                                
                                // 分割线
                                Rectangle()
                                    .frame(maxWidth:.infinity)
                                    .frame(height: 0.5)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 60)
                                
                                // 使用条款
                                SettingButton(action: {
                                    // 存钱猪猪使用条款
                                    openURL(URL(string: "https://fangjunyu.com/2024/06/03/%e5%ad%98%e9%92%b1%e7%8c%aa%e7%8c%aa-%e4%bd%bf%e7%94%a8%e6%9d%a1%e6%ac%be/")!)
                                }, content: {
                                    Image(systemName: "book.pages")
                                        .padding(.horizontal,5)
                                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                    Text("Terms of Use")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(hex:"D8D8D8"))
                                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                })
                                
                                
                                // 分割线
                                Rectangle()
                                    .frame(maxWidth:.infinity)
                                    .frame(height: 0.5)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 60)
                                
                                // 隐私政策
                                SettingButton(action: {
                                    openURL(URL(string: "https://fangjunyu.com/2024/05/23/%e5%ad%98%e9%92%b1%e7%8c%aa%e7%8c%aa-%e9%9a%90%e7%a7%81%e6%94%bf%e7%ad%96/")!)
                                }, content: {
                                    Image(systemName: "lock.doc")
                                        .padding(.horizontal,5)
                                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                    Text("Privacy Policy")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(hex:"D8D8D8"))
                                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                })
                            }
                            .background(colorScheme == .light ? .white : Color(hex:"1f1f1f"))
                            .cornerRadius(10)
                            .padding(10)
                            
                            
                            // 第四组：关于我们、鸣谢
                            VStack(spacing: 0) {
                                // 关于我们
                                if isShowAboutUs {
                                    
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
                                            .foregroundColor(Color(hex:"D8D8D8"))
                                            .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                    })
                                    
                                }
                                if isShowThanks && isShowAboutUs {
                                    
                                    // 分割线
                                    Rectangle()
                                        .frame(maxWidth:.infinity)
                                        .frame(height: 0.5)
                                        .foregroundColor(.gray)
                                        .padding(.leading, 60)
                                }
                                if isShowThanks {
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
                                            .foregroundColor(Color(hex:"C1C1C1"))
                                            .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                    })
                                }
                                // 分割线
                                Rectangle()
                                    .frame(maxWidth:.infinity)
                                    .frame(height: 0.5)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 60)
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
                                        .foregroundColor(Color(hex:"C1C1C1"))
                                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                })
                            }
                            .background(colorScheme == .light ? .white : Color(hex:"1f1f1f"))
                            .cornerRadius(10)
                            .padding(10)
                            
                            Spacer().frame(height: 40)
                            Group {
                                Text(LocalizedStringKey("Version Number")) +  Text(" : ") +  Text("\(Bundle.main.appVersion).\(Bundle.main.appBuild)")
                            }
                            .foregroundColor(Color(hex: "D6D6D7"))
                            .font(.footnote)
                            
                            .onTapGesture(count: 2) {
                                if isInAppPurchase {
                                    isShowInAppPurchase.toggle()
                                }
                            }
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
                .fullScreenCover(isPresented: $showSponsoredApps, content: {
                    SponsoredAppsView()
                })
                .fullScreenCover(isPresented: $showThanksView, content: {
                    ThanksView()
                })
                .fullScreenCover(isPresented: $showAboutUs, content: {
                    AboutUsView()
                })
                .fullScreenCover(isPresented: $showThanks, content: {
                    Thanks2View()
                })
                .fullScreenCover(isPresented: $showOpenSource, content: {
                    OpenSourceView()
                })
            }
        }
    }
}

#Preview {
    @StateObject var iapManager = IAPManager.shared
    return Settings()
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(iapManager)
//        .environment(\.locale, .init(identifier: "de"))
}

