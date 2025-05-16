//
//  BankletWidget.swift
//  BankletWidget
//
//  Created by 方君宇 on 2025/2/13.
//

import WidgetKit
import SwiftUI

// Banklet显示的小组件时间轴提供者
struct BankletWidgetProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> BankletWidgetEntry {
        loadBankletData()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (BankletWidgetEntry) -> ()) {
        let entry = loadBankletData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BankletWidgetEntry>) -> ()) {
        var entries: [BankletWidgetEntry] = []
        
        // 获取当前时间
        let currentDate = Date()
        
        // 仅生成当前时间点的条目
        var entry = loadBankletData()
        entry.date = currentDate
        entries.append(entry)

        // 定义更新时间策略为“每次到期后”更新
        let timeline = Timeline(entries: entries, policy: .after(Date().addingTimeInterval(3600)))
        
        // 返回生成的时间线
        completion(timeline)
    }
    private func loadBankletData() -> BankletWidgetEntry {
            // 从 UserDefaults 中获取存钱罐的数据
            let userDefaults = UserDefaults(suiteName: "group.com.fangjunyu.piglet")
            
            let piggyBankIcon = userDefaults?.string(forKey: "piggyBankIcon") ?? "dollarsign"
            let piggyBankName = userDefaults?.string(forKey: "piggyBankName") ?? "PiggyBank"
            let piggyBankAmount = userDefaults?.double(forKey: "piggyBankAmount") ?? 100.0
            let piggyBankTargetAmount = userDefaults?.double(forKey: "piggyBankTargetAmount") ?? 10.0
            let loopAnimation = userDefaults?.string(forKey: "LoopAnimation") ?? "Home0"
            let background = userDefaults?.string(forKey: "background") ?? "bg0"
            // 返回加载的数据
            return BankletWidgetEntry(
                date: Date(),
                piggyBankIcon: piggyBankIcon,
                piggyBankName: piggyBankName,
                piggyBankAmount: piggyBankAmount,
                piggyBankTargetAmount: piggyBankTargetAmount,
                loopAnimation: loopAnimation,
                background: background
            )
        }
}

// Banklet显示的小组件条目
struct BankletWidgetEntry: TimelineEntry {
    var date: Date
    let piggyBankIcon: String
    let piggyBankName: String
    let piggyBankAmount: Double
    let piggyBankTargetAmount: Double
    let loopAnimation: String
    let background: String
}

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
            let height = geometry.size.height * 0.5
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    // 显示存钱罐图标
                    Circle()
                        .frame(width: 24,height: 24)
                        .foregroundColor(.white)
                        .overlay {
                            Image(systemName: entry.piggyBankIcon)
                                .imageScale(.small)
                                .foregroundColor(Color(hex:"FF4B00"))
                        }
                    Spacer()
                        .frame(height: 5)
                    // 读取主应用存储的存钱罐数据
                    Text(entry.piggyBankName)
                        .foregroundColor(.white)
                        .widgetAccentable()
                }
                .frame(height: height)
                .frame(maxWidth: .infinity)
                Spacer()
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(width: 60, height: 40)
                        .foregroundColor(Color(hex:"FF4B00"))
                        .cornerRadius(10)
                        .overlay {
                            Text("\(SavingProgress.formattedWithTwoDecimalPlaces()) %")
                                .foregroundColor(.white)
                        }
                    
                    RightTriangle()
                        .frame(width: 10,height:10)
                        .foregroundColor(Color(hex:"FF4B00"))
                    Image(entry.loopAnimation) // 显示存钱罐图标
                        .resizable()
                        .scaledToFit()
                        .imageScale(.large)
                }
            }
            .font(.footnote)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .padding(0)
        }
    }
}

struct BankletWidgetBackgroundView : View {
    var entry: BankletWidgetEntry
    
    var body: some View {
        ZStack {
            Image(entry.background)
                .resizable()
                .scaledToFill()
                .onAppear {
                    DispatchQueue.global().async {
                        print("现在在哪？", Thread.isMainThread) // false

                        Task {
                            print("Task 在哪？", Thread.isMainThread) // false 仍在后台
                        }
                    }
                }
        }
    }
}
struct BankletWidget: Widget {
    let kind: String = "BankletWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BankletWidgetProvider()) { entry in
            BankletWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Image("WidgetBackground")
                }
        }
        .supportedFamilies([.systemSmall]) // 支持小尺寸
        .configurationDisplayName("Progress widget") // 小组件的显示名称
        .description("Shows the current progress percentage of the piggy bank.") // 小组件的描述
    }
}

struct BankletWidgetBackground: Widget {
    let kind: String = "BankletWidgetBackground"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BankletWidgetProvider()) { entry in
            BankletWidgetBackgroundView(entry: entry)
                .containerBackground(Color.clear,for: .widget)
        }
        .supportedFamilies([.systemSmall]) // 支持小尺寸
        .configurationDisplayName("Small window background image") // 小组件的显示名称
        .description("Shows the background image in the application in a small size.") // 小组件的描述
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    BankletWidget()
} timeline: {
    BankletWidgetEntry(date: Date(), piggyBankIcon: "apple.logo", piggyBankName: "存钱罐", piggyBankAmount: 50, piggyBankTargetAmount: 100, loopAnimation: "Home49",background: "bg0")
}

#Preview(as: .systemSmall) {
    BankletWidgetBackground()
} timeline: {
    BankletWidgetEntry(date: Date(), piggyBankIcon: "apple.logo", piggyBankName: "存钱罐", piggyBankAmount: 50, piggyBankTargetAmount: 100, loopAnimation: "Home49",background: "bg0")
}


extension Double {
    func formattedWithTwoDecimalPlaces() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}

// 对话三角
struct RightTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        
        // 如果十六进制字符串有前缀 '#', 去掉它
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
