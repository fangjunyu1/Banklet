//
//  BankletWidgetEntryView.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/12.
//

import WidgetKit
import SwiftUI

struct BankletWidgetEntryView : View {
    var entry: BankletWidgetEntry
    
    var SavingProgress:Double {
        // 防止除以零的错误
        guard entry.piggyBankTargetAmount != 0 else { return 0 }
        return max(min(entry.piggyBankAmount / entry.piggyBankTargetAmount * 100,100),0)
    }
    
    var body: some View {
        GeometryReader { geometry in
            // 通过 `geometry` 获取布局信息
            ZStack {
                // 图片背景
                Image("png_\(entry.loopAnimation)") // 显示存钱罐图标
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .offset(y:35)
                // 文本区域
                VStack{
                    Spacer().frame(height:5)
                    Text("\(entry.piggyBankName)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "888888"))
                    Spacer().frame(height:5)
                    
                    GeometryReader { geometry in
                        
                        let width = geometry.size.width
                        ZStack {
                            // 白色背景图
                            Rectangle()
                                .foregroundColor(Color(hex: "DDDDDD"))
                                .cornerRadius(10)
                            // 蓝色进度条
                            HStack {
                                Rectangle()
                                    .foregroundColor(.blue.opacity(0.8))
                                    .frame(width: width * SavingProgress * 0.01 + 10)
                                    .offset(x: -10)
                                    .cornerRadius(10)
                                    .blur(radius: 3)
                                Spacer()
                            }
                            // 显示存钱罐图标
                            VStack {
                                HStack {
                                    Spacer().frame(width:12)
                                    ZStack {
                                        Circle().foregroundColor(Color(hex: "EEEEEE"))
                                            .frame(width: 25)
                                            .opacity(0.8)
                                        Image(systemName: entry.piggyBankIcon)
                                    }
                                    Spacer()
                                    Text(String(format:"%.0f",SavingProgress.formattedWithTwoDecimalPlaces())+"%")
                                        .font(.system(size: 10))
                                        .fontWeight(.bold)
                                    Spacer().frame(width:10)
                                }
                            }
                        }
                    }
                    .frame(width:140,height:40)
                    .cornerRadius(10)
                    .clipped()
                    Spacer()
                }
            }
            .font(.footnote)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .padding(0)
        }
    }
}

struct BankletWidget: Widget {
    let kind: String = "BankletWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BankletWidgetProvider()) { entry in
            ZStack {
                Image(entry.background)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 3)
                    .opacity(0.3)
                BankletWidgetEntryView(entry: entry)
                    .containerBackground(.clear, for: .widget)
            }
        }
        .supportedFamilies([.systemSmall]) // 支持小尺寸
        .configurationDisplayName("Progress widget") // 小组件的显示名称
        .description("Shows the current progress percentage of the piggy bank.") // 小组件的描述
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    BankletWidget()
} timeline: {
    BankletWidgetEntry(date: Date(), piggyBankIcon: "apple.logo", piggyBankName: "存钱罐", piggyBankAmount: 50, piggyBankTargetAmount: 100, loopAnimation: "Home49",background: "bg0")
}
