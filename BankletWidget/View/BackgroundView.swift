//
//  BankletWidget.swift
//  BankletWidget
//
//  Created by 方君宇 on 2025/2/13.
//

import WidgetKit
import SwiftUI

struct BackgroundView : View {
    var entry: BankletWidgetEntry
    
    var body: some View {
        ZStack {
            Image(entry.background)
                .resizable()
                .scaledToFill()
            VStack(spacing: 2) {
                Text(entry.date, format: .dateTime.day())
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(Color(hex: "2F2F2F"))
                Text(entry.date, format: .dateTime.weekday())
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.8))
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct BackgroundWidget: Widget {
    let kind: String = "BankletWidgetBackground"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BankletWidgetProvider()) { entry in
            BackgroundView(entry: entry)
                .containerBackground(Color.clear,for: .widget)
        }
        .supportedFamilies([.systemSmall]) // 支持小尺寸
        .configurationDisplayName("Small window background image") // 小组件的显示名称
        .description("Shows the background image in the application in a small size.") // 小组件的描述
        .contentMarginsDisabled()
    }
}


#Preview(as: .systemSmall) {
    BackgroundWidget()
} timeline: {
    BankletWidgetEntry(date: Date(), piggyBankIcon: "apple.logo", piggyBankName: "存钱罐", piggyBankAmount: 50, piggyBankTargetAmount: 100, loopAnimation: "Home49",background: "bg0")
}
