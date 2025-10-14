//
//  PlaceholderView.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/13.
//

import WidgetKit
import SwiftUI

struct PlaceholderView : View {
    var body: some View{
        Image("widgetBackground")
            .resizable()
            .scaledToFill()
            .cornerRadius(10)
    }
}
struct PlaceholderWidget: Widget {
    let kind: String = "PlaceholderWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BankletWidgetProvider()) { entry in
            PlaceholderView()
                .containerBackground(Color.clear,for: .widget)
        }
        .supportedFamilies([.systemMedium]) // 支持小尺寸
        .configurationDisplayName("Featured Images") // 小组件的显示名称
        .description("Turn your desktop into your own gallery.") // 小组件的描述
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemMedium) {
    PlaceholderWidget()
} timeline: {
    BankletWidgetEntry(date: Date(), piggyBankIcon: "apple.logo", piggyBankName: "存钱罐", piggyBankAmount: 50, piggyBankTargetAmount: 100, loopAnimation: "Home49",background: "bg0")
}
