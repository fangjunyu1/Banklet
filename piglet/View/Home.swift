//
//  Home.swift
//  piglet
//
//  Created by 方君宇 on 2024/12/31.
//

import SwiftUI
import SwiftData
import Combine
import StoreKit
import WidgetKit

struct Home: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    @EnvironmentObject var sound: SoundManager  // 通过 Sound 注入
    @Query(sort: \PiggyBank.creationDate)   // 所有存钱罐，按创建日期排序
    var allPiggyBank: [PiggyBank]
    @Query(sort: \SavingsRecord.date, order: .reverse)
    var savingsRecords: [SavingsRecord]  // 存取次数
    @State private var selectedTab = HomeTab.home  // 当前选择的Tab
    // 获取第一个存钱罐
    var primaryBank: PiggyBank? {
        allPiggyBank.filter { $0.isPrimary }.first
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    // switch selectedTab
                    switch selectedTab {
                        // 主页视图
                    case .home:
                        HomeMainView(allPiggyBank: allPiggyBank, primaryBank: primaryBank)
                        // 活动视图
                    case .activity:
                        HomeActivityView()
                        // 统计视图
                    case .stats:
                          HomeStatsView(allPiggyBank: allPiggyBank, savingsRecords: savingsRecords)
                        // 统计视图
                    case .settings:
                        HomeSettingsView()
                    }
                }
                // 液态玻璃 TabView 视图
                HomeTabView(selectedTab: $selectedTab)
            }
            .background {
                // 设置默认的背景灰色，防止各视图切换时显示白色闪烁背景
                AppColor.appBgGrayColor
                    .ignoresSafeArea()
            }
            // 监听应用状态，如果返回，则调用Widget保存数据
            .onChange(of: scenePhase) { _,newPhase in
                if newPhase == .active {
                    // App 进入活跃状态
                    print("App 进入活跃状态")
                }
                if newPhase == .background {
                    // 在应用进入后台时保存数据
                    saveWidgetData(primaryBank)
                    print("应用移入后台，调用Widget保存数据")
                }
                if newPhase == .inactive {
                    // 应用即将终止时保存数据（iOS 15+）
                    saveWidgetData(primaryBank)
                    print("非活跃状态，调用Widget保存数据")
                }
            }
        }
    }
}


#Preview {
    Home()
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
    // .environment(\.locale, .init(identifier: "ru"))
}
