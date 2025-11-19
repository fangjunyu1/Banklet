//
//  ActivityContentCompleteView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/19.
//

import SwiftUI

struct ActivityCompleteView: View {
    @EnvironmentObject var activityVM: ActiveViewModel
    var body: some View {
        VStack {
            // 标题 - 创建完成
            Text("Creation completed")
                .modifier(HomeActivityTitleModifier())
            
            LottieView(filename: "check1", isPlaying: true, playCount: 1, isReversed: false)
                .scaledToFit()
                .modifier(ActivityCompleteLottieModifier())
        }
    }
}


private struct ActivityCompleteLottieModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .frame(maxWidth: 120)
            .scaleEffect(1.1)
    }
}
