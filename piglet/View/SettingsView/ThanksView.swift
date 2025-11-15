//
//  ThanksView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/8.
//

import SwiftUI

struct ThanksView: View {
    @State private var showAppStore = false
    let platformList: [String] = ["ChatGPT","LottieFiles","iconfont","Pinterest","Dirbbble","GitHub", "px"]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Spacer()
                .frame(height: 20)
            VStack(spacing: 10) {
                // 开发者的致谢
                Text("Developer's Acknowledgments")
                    .modifier(TitleModifier())
                Text("Thank you to every user who downloaded and used our app, thank you to every user who made an in-app purchase for your support, and thank you to all our friends for your support.")
                    .modifier(FootNoteModifier())
            }
            // 致谢动画
            LottieView(filename: "ThanksAnimation", isPlaying: true, playCount: 0, isReversed: false)
                .scaleEffect(0.8)
                .modifier(LottieModifier())
            
            // 资源与技术支持
            VStack(spacing: 10) {
                Text("Resource and technical support")
                    .modifier(TitleModifier())
                Text("Thank you to the following platforms for their selfless contributions.")
                    .modifier(FootNoteModifier())
                // 感谢平台的列表
                ForEach(platformList, id:\.self) { item in
                    Image(item)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                }
            }
            Spacer().frame(height:20)
            // 更多作品
            VStack(spacing: 10) {
                Text("More works")
                    .modifier(TitleModifier())
                Text("iOS & macOS app collection")
                    .modifier(FootNoteModifier())
                Image("FangApp")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .frame(maxWidth: 500)
                Spacer().frame(height:10)
                Link(destination: URL(string: "https://apps.apple.com/cn/developer/%E5%90%9B%E5%AE%87-%E6%96%B9/id1746520472")!) {
                    Text("App Store")
                          .fontWeight(.medium)
                          .padding(.vertical,20)
                          .padding(.horizontal,50)
                          .foregroundColor(.white)
                          .background(AppColor.appColor)
                          .cornerRadius(16)
                          .shadow(radius: 5)
                }
            }
            Spacer().frame(height:50)
        }
        .navigationTitle("Thanks")
        .modifier(BackgroundModifier())
    }
}

#Preview {
    NavigationStack {
        ThanksView()
    }
}
