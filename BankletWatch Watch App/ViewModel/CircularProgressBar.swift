//
//  CircularProgressBar.swift
//  BankletWatch Watch App
//
//  Created by 方君宇 on 2025/2/23.
//

import SwiftUI

struct CircularProgressBar: View {
    var progress: CGFloat  // 进度值，范围从 0 到 1
    
    var body: some View {
        ZStack {
            // 背景圆圈
            Circle()
                .stroke(lineWidth: 10)
                .foregroundColor(Color.gray.opacity(0.3))
            
            // 进度圆圈
            Circle()
                .trim(from: 0, to: progress)  // 根据进度值裁剪
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: -90))  // 使圆圈从顶部开始
                .animation(.easeInOut, value: progress)
        }
    }
}
