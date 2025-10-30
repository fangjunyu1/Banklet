//
//  HomeBackground.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/30.
//

import SwiftUI

struct HomeBackground: View {
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
