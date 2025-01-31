//
//  GeneralView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/15.
//

import SwiftUI

struct GeneralView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isBiometricEnabled") var isBiometricEnabled = false
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.95
                ZStack {
                    // 背景
                    Color(hex: colorScheme == .light ?  "f0f0f0" : "0E0E0E")
                        .ignoresSafeArea()
                    // 设置列表
                    VStack {
                        Group {
                            VStack(spacing: 0) {
                                NavigationLink(destination: MainInterfaceBackgroundView()){
                                    SettingView(content: {
                                        Image(systemName: "photo.artframe")
                                            .padding(.horizontal,5)
                                        Text("Main interface background")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color(hex:"D8D8D8"))
                                    })
                                }
                                // 分割线
                                Rectangle()
                                    .frame(maxWidth:.infinity)
                                    .frame(height: 0.5)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 60)
                                // 主界面动画
                                NavigationLink(destination:
                                                MainInterfaceAnimationView()){
                                    SettingView(content: {
                                        Image(systemName: "film.stack")
                                            .padding(.horizontal,5)
                                        Text("Main interface animation")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color(hex:"D8D8D8"))
                                    })
                                }
                                // 分割线
                                Rectangle()
                                    .frame(maxWidth:.infinity)
                                    .frame(height: 0.5)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 60)
                                NavigationLink(destination: AppIconView()){
                                    SettingView(content: {
                                        Image(systemName: "photo.fill")
                                            .padding(.horizontal,5)
                                        Text("App Icon")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color(hex:"D8D8D8"))
                                    })
                                }
                            }
                            .background(colorScheme == .light ? .white : Color(hex:"1f1f1f"))
                            .cornerRadius(10)
                            .padding(10)
                        }
                        SettingView(content: {
                            Image(systemName: "faceid")
                                .padding(.horizontal,5)
                            Text("Password protection")
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            Spacer()
                            Toggle("",isOn: $isBiometricEnabled)  // iCloud开关
                                .frame(height:0)
                        })
                        .padding(10)
                        Spacer()
                    }
                    .frame(width: width)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .navigationTitle("General")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

#Preview {
    GeneralView()
    //        .environment(\.locale, .init(identifier: "de"))
}
