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
    var body: some View {
        if !appStorage.BackgroundImage.isEmpty {
            Image(appStorage.BackgroundImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.5)
        } else {
            AppColor.appBgGrayColor
                .ignoresSafeArea()
        }
    }
}
