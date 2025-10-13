//
//  BankletWidgetEntryView.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/12.
//

import WidgetKit
import SwiftUI

struct BankletWidgetEntryView : View {
    @Environment(\.colorScheme) var color
    var entry: BankletWidgetEntry
    
    var SavingProgress:Double {
        // 防止除以零的错误
        guard entry.piggyBankTargetAmount != 0 else { return 0 }
        return max(min(entry.piggyBankAmount / entry.piggyBankTargetAmount * 100,100),0)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let fullWidth = geometry.size.width
            // 通过 `geometry` 获取布局信息
            ZStack {
                // 存钱罐名称-标题
//                VStack {
//                    Spacer()
//                    HStack {
//                        Text("\(entry.piggyBankName)")
//                            .font(.footnote)
//                            .fontWeight(.bold)
//                            .foregroundColor(Color(hex: "888888"))
//                            .offset(x:10)
//                        Spacer()
//                    }
//                }
//                .frame(maxWidth: 150, alignment: .leading)
                //                .background(.red)
                // 图片背景
                Image("png_\(entry.loopAnimation)") // 显示存钱罐图标
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .offset(y:25)
                // 文本区域
                VStack(spacing: 0){
                    Spacer().frame(height:20)
                    
                    ZStack {
                        // 背景图
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(color == .light ? Color(hex: "DDDDDD") : .black)
                            .cornerRadius(10)
                        GeometryReader { geometry in
                            
                            let width = geometry.size.width
                            
                            // 进度条
                            HStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(color == .light ? .blue.opacity(0.8) : .gray)
                                    .frame(width: width * SavingProgress * 0.01)
                                    .cornerRadius(10)
                                Spacer()
                            }
                            VStack {
                                Spacer()
                                
                                // 显示存钱罐图标
                                VStack(spacing: 0) {
                                    HStack {
                                        Spacer().frame(width:12)
                                        ZStack {
                                            Circle().foregroundColor(color == .light ? Color(hex: "EEEEEE") : Color(hex: "2f2f2f"))
                                                .frame(width: 20)
                                                .opacity(0.8)
                                            Image(systemName: entry.piggyBankIcon)
                                        }
                                        Spacer()
                                        Text(String(format:"%.0f",SavingProgress.formattedWithTwoDecimalPlaces())+"%")
                                            .font(.system(size: 10))
                                            .fontWeight(.bold)
                                        Spacer().frame(width:15)
                                    }
                                }
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.green)
                    }
                    .frame(width:140,height:40)
                    .cornerRadius(10)
                    .overlay {
                        // 白色描边
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(.white, lineWidth: 5)
                    }
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
                // Color.red
                
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
