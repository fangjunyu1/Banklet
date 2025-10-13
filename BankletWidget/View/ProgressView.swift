//
//  BankletWidgetEntryView.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/12.
//

import WidgetKit
import SwiftUI

struct ProgressView : View {
    @Environment(\.colorScheme) var color
    var entry: BankletWidgetEntry
    
    var SavingProgress:Double {
        // 防止除以零的错误
        guard entry.piggyBankTargetAmount != 0 else { return 0 }
        return max(min(entry.piggyBankAmount / entry.piggyBankTargetAmount * 100,100),0)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.blue)
                .frame(width: 130)
                .opacity(0.6)
            VStack {
                Group {
                    
                    Image(systemName: entry.piggyBankIcon)
                        .imageScale(.large)
                    Spacer().frame(height:6)
                    Text(String(format:"%.0f",SavingProgress.formattedWithTwoDecimalPlaces())+"%")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer().frame(height:6)
                    Text("\(entry.piggyBankName)")
                        .font(.footnote)
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct ProgressWidget: Widget {
    let kind: String = "BankletWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BankletWidgetProvider()) { entry in
                ProgressView(entry: entry)
                    .containerBackground(.clear, for: .widget)
        }
        .supportedFamilies([.systemSmall]) // 支持小尺寸
        .configurationDisplayName("Progress widget") // 小组件的显示名称
        .description("Shows the current progress percentage of the piggy bank.") // 小组件的描述
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    ProgressWidget()
} timeline: {
        BankletWidgetEntry(date: Date(), piggyBankIcon: "apple.logo", piggyBankName: "存钱罐", piggyBankAmount: 50, piggyBankTargetAmount: 100, loopAnimation: "Home49",background: "bg0")
}
