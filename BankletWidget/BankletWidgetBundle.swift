//
//  BankletWidgetBundle.swift
//  BankletWidget
//
//  Created by 方君宇 on 2025/2/13.
//
//  2026-10-25:隐藏进度小组件
//

import WidgetKit
import SwiftUI

@main
struct BankletWidgetBundle: WidgetBundle {
    var body: some Widget {
//        ProgressWidget()    // 进度小组件
        BackgroundWidget()  // 背景（日历）图片小组件
        PlaceholderWidget() // 精选图片小组件
        GifAnimateWidget()  // Gif小组件
//        BankletWidgetLiveActivity()
    }
}
