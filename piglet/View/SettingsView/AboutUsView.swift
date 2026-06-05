//
//  AboutUsView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/10.
//

import SwiftUI
import Lottie

struct AboutUsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) var openURL
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                LottieView(filename: "WorkingCat",isPlaying: true, playCount: 0, isReversed: false)
                    .scaleEffect(1.3)
                    .modifier(LottieModifier())
                VStack(spacing: 10) {
                    Text("Who are we?")
                        .modifier(TitleModifier())
                    Text("An independent developer from China")
                        .modifier(FootNoteModifier())
                }
                VStack(spacing: 10) {
                    ForEach(aboutUsList, id:\.self) { item in
                        Text(LocalizedStringKey(item))
                            .font(.footnote)
                            .padding(10)
                            .background(Color("AppColor"))
                            .cornerRadius(10)
                            .multilineTextAlignment(.center)
                        
                    }
                    Text("We hope this app will bring you a relaxed and enjoyable user experience.")
                        .font(.footnote)
                        .padding(10)
                        .foregroundColor(.white)
                        .background(AppColor.appColor)
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                }
                // 联系我们
                ContactUs
                // 更多作品
                MoreApps
            }
            Spacer().frame(height: 50)
        }
        .navigationTitle("About Us")
        .modifier(BackgroundModifier())
    }
    
    
    let aboutUsList:[String] = [
        "Hello, I am Fang Junyu, an independent developer from China.",
        "I am a novice independent developer. Before becoming a developer, I worked in sales, on-site project work, and the catering industry.",
        "In 2024, after leaving my previous company, I began to think about what I really wanted to do.",
        "At the time, I was working towards my goals of owning a house and a car, which gave me the idea to develop a money-saving app.",
        "So I started learning iOS development and completed and released the first version of \"Banklet\" that month.",
        "As of June 2025, this little pig has evolved through 9 versions.",
        "I hope it can help more people achieve their goals, and I will continue to update it to make the app even better."
    ]
    
    // 联系我们
    var ContactUs: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Text("Contact Us")
                    .modifier(TitleModifier())
                Text("Feedback and issues are welcome")
                    .modifier(FootNoteModifier())
            }
            VStack(spacing: 10) {
                // 邮箱
                HStack(spacing: 0) {
                    Text("Email")
                    Text(verbatim: " : ")
                    Text(verbatim: "fangjunyu.com@gmail.com")
                }
                // 网站
                HStack(spacing: 0) {
                    Text("Website")
                    Text(verbatim: " : ")
                    Text(verbatim: "www.fangjunyu.com")
                }
                // 反馈标语
                Text("If you encounter any issues while using the app, or have any suggestions, you can let me know through “Feedback” in Settings. I read every piece of feedback carefully.")
            }
            .modifier(FootNoteModifier())
        }
    }
    
    // 更多作品
    var MoreApps: some View {
        VStack(spacing: 30) {
            VStack(spacing: 10) {
                Text("More Apps")
                    .modifier(TitleModifier())
                Text("iOS & macOS app collection")
                    .modifier(FootNoteModifier())
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(AppStoreItem.allCases) { item in
                        Button(action: {
                            // 打开方君宇的 AppStore 页面
                            openURL(item.link)
                        }, label: {
                            Image(item.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(10)
                        })
                    }
                }
            }
            Button(action: {
                // 触发振动
                HapticManager.shared.selectionChanged()
                
                // 打开方君宇的 AppStore 页面
                openURL(URL(string: "https://apps.apple.com/cn/developer/%E5%90%9B%E5%AE%87-%E6%96%B9/id1746520472")!)
            }, label: {
                Text(verbatim: "App Store")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 50)
                    .background(AppColor.appColor)
                    .cornerRadius(10)
                    .shadow(radius: 3)
            })
            .padding(.vertical, 20)
        }
    }
}

enum AppStoreItem: String, Identifiable, CaseIterable {
    var id: String {
        self.rawValue
    }
    
    case App1
    case App2
    case App3
    case App4
    case App5
    
    var link: URL {
        switch self {
            // 轻压图片
        case .App1:
            URL(string:"https://apps.apple.com/cn/app/%E8%BD%BB%E5%8E%8B%E5%9B%BE%E7%89%87/id6748277056?mt=12")!
            
            // 轻学编程
        case .App2:
            URL(string:"https://apps.apple.com/app/qinote-app-development/id6748941042")!
            // 存钱猪猪
        case .App3:
            URL(string:"https://apps.apple.com/cn/app/%E5%AD%98%E9%92%B1%E7%8C%AA%E7%8C%AA-%E5%AD%98%E9%92%B1%E7%BD%90/id6503047096")!
            // 汇率仓库
        case .App4:
            URL(string:"https://apps.apple.com/cn/app/%E6%B1%87%E7%8E%87%E4%BB%93%E5%BA%93/id6737148150")!
            // 方方块
        case .App5:
            URL(string:"https://apps.apple.com/us/app/%E6%96%B9%E6%96%B9%E5%9D%97/id6742731756?l=zh-Hans-CN")!
        }
    }
}

#Preview {
    NavigationStack {
        AboutUsView()
    }
}
