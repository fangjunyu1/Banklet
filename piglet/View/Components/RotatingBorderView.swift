//
//  RotatingBorderView.swift
//  SwiftSlim
//
//  Created by 方君宇 on 2026/6/5.
//

import SwiftUI

// 边框旋转视图
struct RotatingBorderView: View {
    @State private var rotation: Double = 0

    var body: some View {
        Image("border")
            .resizable()
            .scaledToFit()
            .frame(width: 200)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                rotation = 0
                withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}
