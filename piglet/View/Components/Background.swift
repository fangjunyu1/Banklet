//
//  Background.swift
//  piglet
//
//  Created by 方君宇 on 2025/12/15.
//

import SwiftUI

struct Background: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        // 设置默认的背景灰色，防止各视图切换时显示白色闪烁背景
        if colorScheme == .light {
            AppColor.appBgGrayColor
                .ignoresSafeArea()
        } else {
            Color.black
                .ignoresSafeArea()
        }
    }
}
