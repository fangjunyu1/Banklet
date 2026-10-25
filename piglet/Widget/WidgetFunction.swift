//
//  WidgetFunction.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/16.
//
//  2026-10-25
//  删除主存钱罐的信息
//

import SwiftUI
import SwiftData
import WidgetKit


func saveWidgetData() {
    let appStorage:AppStorageManager = AppStorageManager.shared
    let userDefaults = UserDefaults(suiteName: "group.com.fangjunyu.piglet")
    
    userDefaults?.set(appStorage.LoopAnimation, forKey: "LoopAnimation")
    userDefaults?.set(appStorage.BackgroundImage, forKey: "background")
    
    // 然后手动触发 Widget 刷新
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        // 刷新以下小组件的视图
        WidgetCenter.shared.reloadTimelines(ofKind: "BankletWidget")
        WidgetCenter.shared.reloadTimelines(ofKind: "BankletWidgetBackground")
        WidgetCenter.shared.reloadTimelines(ofKind: "GifWidget")
        
        print("刷新小组件内容")
        print("当前动画为:\(appStorage.LoopAnimation)")
    }
}
