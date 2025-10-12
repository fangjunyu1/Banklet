//
//  BankletWidgetProvider.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/12.
//

import WidgetKit
import SwiftUI

// Banklet显示的小组件时间轴提供者
struct BankletWidgetProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> BankletWidgetEntry {
        return loadBankletData()
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
