//
//  BankletWidget.swift
//  BankletWidget
//
//  Created by 方君宇 on 2025/2/13.
//

import WidgetKit
import SwiftUI
// 不需要配置的小组件
struct SimpleProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleProviderEntry {
        SimpleProviderEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleProviderEntry) -> ()) {
        let entry = SimpleProviderEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleProviderEntry>) -> ()) {
        let entry = SimpleProviderEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}
// 不需要配置的小组件
struct Provider: AppIntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
}
// 不需要配置的小组件
struct SimpleProviderEntry: TimelineEntry {
    let date: Date
}
// 需要配置的小组件
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
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

struct BankletWidgetEntryView : View {
    
    @State private var piggyBankIcon: String = ""
    @State private var piggyBankName: String = ""
    @State private var piggyBankAmount: Double = 0.0
    @State private var piggyBankTargetAmount: Double = 0.0
    @State private var LoopAnimation: String = ""
    
    var entry: SimpleProvider.Entry
    
    var SavingProgress:Double {
        // 防止除以零的错误
        guard piggyBankTargetAmount != 0 else { return 0 }
        return max(min(piggyBankAmount / piggyBankTargetAmount * 100,100),0)
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
                            Image(systemName: "\(piggyBankIcon)")
                                .imageScale(.small)
                                .foregroundColor(Color(hex:"FF4B00"))
                        }
                    Spacer()
                        .frame(height: 5)
                    // 读取主应用存储的存钱罐数据
                    Text("\(piggyBankName)")
                        .foregroundColor(.white)
                        .widgetAccentable()
                }
                .frame(height: height)
                .frame(maxWidth: .infinity)
                Spacer()
                HStack(spacing: 0) {
                    // 使用 Link 替代 widgetURL
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
                    Image(LoopAnimation) // 显示存钱罐图标
                        .resizable()
                        .scaledToFit()
                        .imageScale(.large)
                }
            }
            .font(.footnote)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .padding(0)
        }
        .onAppear {
            // 读取存钱罐的数据
            let userDefaults = UserDefaults(suiteName: "group.com.fangjunyu.piglet")
            piggyBankIcon = userDefaults?.string(forKey: "piggyBankIcon") ?? "dollarsign"
            piggyBankName = userDefaults?.string(forKey: "piggyBankName") ?? "PiggyBank"
            piggyBankAmount = userDefaults?.double(forKey: "piggyBankAmount") ?? 100.0
            piggyBankTargetAmount = userDefaults?.double(forKey: "piggyBankTargetAmount") ?? 10.0
            LoopAnimation = userDefaults?.string(forKey: "LoopAnimation") ?? "Home0"
        }
    }
}

struct BankletWidgetBackgroundView : View {
    
    @State private var background: String = "bg0"
    var entry: SimpleProvider.Entry
    
    var body: some View {
        ZStack {
            Image(background)
                .resizable()
                .scaledToFill()
        }
        .onAppear {
            // 读取存钱罐背景
            let userDefaults = UserDefaults(suiteName: "group.com.fangjunyu.piglet")
            background = userDefaults?.string(forKey: "background") ?? "bg0"
        }
    }
}

struct BankletWidget: Widget {
    @State private var background: String = "bg0"
    let kind: String = "BankletWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SimpleProvider()) { entry in
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
        StaticConfiguration(kind: kind, provider: SimpleProvider()) { entry in
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
    SimpleProviderEntry(date: .now)
}

#Preview(as: .systemSmall) {
    BankletWidgetBackground()
} timeline: {
    SimpleProviderEntry(date: .now)
}
