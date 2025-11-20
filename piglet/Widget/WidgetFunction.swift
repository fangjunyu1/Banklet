//
//  WidgetFunction.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/16.
//

import SwiftUI
import SwiftData
import WidgetKit

func saveWidgetData(_ piggyBank:PiggyBank?) {
    let appStorage:AppStorageManager = AppStorageManager.shared
    let userDefaults = UserDefaults(suiteName: "group.com.fangjunyu.piglet")
    
    // 存储存钱罐数据
    if let piggyBank = piggyBank {
        userDefaults?.set(piggyBank.icon, forKey: "piggyBankIcon")
        userDefaults?.set(piggyBank.name, forKey: "piggyBankName")
        userDefaults?.set(piggyBank.amount, forKey: "piggyBankAmount")
        userDefaults?.set(piggyBank.targetAmount, forKey: "piggyBankTargetAmount")
        userDefaults?.set(appStorage.LoopAnimation, forKey: "LoopAnimation")
        userDefaults?.set(appStorage.BackgroundImage, forKey: "background")
        print("piggyBankName:\(piggyBank.name)")
        // 然后手动触发 Widget 刷新
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // 刷新以下小组件的视图
            WidgetCenter.shared.reloadTimelines(ofKind: "BankletWidget")
            WidgetCenter.shared.reloadTimelines(ofKind: "BankletWidgetBackground")
            WidgetCenter.shared.reloadTimelines(ofKind: "GifWidget")
            
            print("刷新小组件内容")
            print("当前动画为:\(appStorage.LoopAnimation)")
        }
    } else {
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
}
