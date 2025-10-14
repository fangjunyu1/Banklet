//
//  GifWidgetProvider.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/14.
//

import WidgetKit
import SwiftUI

// Banklet显示的小组件时间轴提供者
struct GifWidgetProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> GifWidgetEntry {
        return GifWidgetEntry(
            date: Date(), loopAnimation: "Home0"
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (GifWidgetEntry) -> ()) {
        let entry = GifWidgetEntry(
            date: Date(), loopAnimation: "Home0"
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<GifWidgetEntry>) -> ()) {
        let entries = loadBankletData()
        // 永不刷新
        let timeline = Timeline(entries: [entries], policy: .never)
        // 返回生成的时间线
        completion(timeline)
    }
    private func loadBankletData() -> GifWidgetEntry {
            // 从 UserDefaults 中获取存钱罐的数据
            let userDefaults = UserDefaults(suiteName: "group.com.fangjunyu.piglet")
            let loopAnimation = userDefaults?.string(forKey: "LoopAnimation") ?? "Home0"
            // 返回加载的数据
            return GifWidgetEntry(
                date: Date(),
                loopAnimation: loopAnimation
            )
        }
}
