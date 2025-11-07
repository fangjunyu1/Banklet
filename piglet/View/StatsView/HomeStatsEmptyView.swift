//
//  StatsEmptyView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/7.
//

import SwiftUI

struct HomeStatsEmptyView: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 50)
            LottieView(filename: "emptyStats", isPlaying: true, playCount: 0, isReversed: false)
                .scaledToFit()
                .frame(maxHeight: 180)
                .frame(maxWidth: 500)
            Spacer().frame(height: 30)
            // 文字内容
            VStack(spacing: 20) {
                // 标题
                Text("Have the statistics disappeared?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                // 副标题
                Text("Let the data witness your every accumulation and change.")
                    .font(.footnote)
                    .padding(.horizontal,30)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
    }
}

#Preview {
    HomeStatsEmptyView()
}
