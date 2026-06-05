//
//  ThanksView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/8.
//

import SwiftUI

struct ThanksView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showAppStore = false
    let platformList: [String] = ["ChatGPT","LottieFiles","iconfont","Pinterest","Dirbbble","GitHub", "px"]
    let platformBlackList: [String] = ["ChatGPT-white","LottieFiles-white","iconfont-white","Pinterest-white","Dirbbble-white","GitHub", "px"]
    
    var body: some View {
        let list = colorScheme == .light ? platformList : platformBlackList
        ScrollView(showsIndicators: false) {
            VStack {
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
                    ForEach(list, id:\.self) { item in
                        Image(item)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180)
                    }
                }
                Spacer().frame(height:50)
            }
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
