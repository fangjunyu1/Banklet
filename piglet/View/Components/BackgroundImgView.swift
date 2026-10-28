//
//  BackgroundImgView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/9.
//
// 显示主界面和背景视图的背景

import SwiftUI

struct BackgroundImgView: View {
    @Environment(AppStorageManager.self) var appStorage
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 先确定背景容器的尺寸
                Color.clear
                    .overlay {
                        Group {
                            if !appStorage.BackgroundImage.isEmpty {
                                Image(appStorage.BackgroundImage)
                                    .resizable()
                                    .scaledToFill()
                            } else if colorScheme == .light {
                                Image("travel_pattern_background")
                                    .resizable()
                                    .scaledToFill()
                                    .opacity(0.1)
                            } else {
                                Color.black
                            }
                        }
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                        .blur(
                            radius: appStorage.isBlurBackground ? 30 : 0
                        )
                    }
                    .clipped()

                // 深色模式下，给自定义背景添加暗色遮罩
                if !appStorage.BackgroundImage.isEmpty,
                   colorScheme == .dark {
                    Color.black.opacity(0.95)
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
            .clipped()
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
