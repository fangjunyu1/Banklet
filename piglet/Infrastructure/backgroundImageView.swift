//
//  backgroundImageView.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/30.
//

import SwiftUI

@ViewBuilder
func backgroundImageView() -> some View {
    @Environment(AppStorageManager.self) var appStorage
    @Environment(\.colorScheme) var colorScheme
    
    if !appStorage.BackgroundImage.isEmpty {
        Image(appStorage.BackgroundImage)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .brightness(colorScheme == .dark ? -0.5 : 0) // 让深色模式降低亮度
    } else {
        EmptyView()
    }
}
