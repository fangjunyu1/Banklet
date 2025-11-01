//
//  CustomProgressViewStyle.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/31.
//
// 自定义进度条

import SwiftUI

struct CustomProgressViewStyle: ProgressViewStyle {
    var height = 10.0
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            let progressWidth = geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                Capsule()
                    .fill(AppColor.appColor)
                    .frame(width: progressWidth)
            }
            .onAppear {
                print("progressWidth:\(progressWidth)")
            }
        }
        .frame(height: height)
        
    }
}
