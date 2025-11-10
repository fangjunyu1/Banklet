//
//  PremiumView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/10.
//
// 高级会员视图

import SwiftUI

struct PremiumView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            // 当前图标
            Footnote(text: "Current icon")
            // 会员 动画
            LottieView(filename: "vip1", isPlaying: true, playCount: 0, isReversed: false)
                .frame(maxHeight: 180)
                .frame(maxWidth: 500)
            Spacer().frame(height: 20)
            // 所有图标
            HStack {
                Footnote(text: "All icons")
                Spacer()
            }
        }
        .navigationTitle("Premium Member")
        .modifier(BackgroundModifier())
    }
}

#Preview {
    NavigationStack{
        PremiumView()
    }
}
