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
        ZStack {
            if !appStorage.BackgroundImage.isEmpty {
                ZStack {
                    Image(appStorage.BackgroundImage)
                        .resizable()
                        .scaledToFill()
                        .blur(radius: appStorage.isBlurBackground ? 30 : 0)
                        .ignoresSafeArea()
                    Color.black.opacity(colorScheme == .light ? 0 : 0.95)
                        .ignoresSafeArea()
                }
            } else {
                if colorScheme == .light {
                    AppColor.appBgGrayColor
                        .ignoresSafeArea()
                } else {
                    Color.black
                        .ignoresSafeArea()
                }
            }
        }
    }
}
