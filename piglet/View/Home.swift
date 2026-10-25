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
    @Environment(SoundManager.self) var sound
    @State private var homeActivityVM = HomeActivityViewModel()
    @Query(sort: \SavingsRecord.date, order: .reverse)
    var savingsRecords: [SavingsRecord]  // 存取次数
    @State private var selectedTab = HomeTab.home  // 当前选择的Tab
    @State private var homeVM = HomeViewModel() // 视图步骤
    @State private var isSlientMode = false // 静默视图
    @State private var lastTouchTime = Date()    // 最后点击时间，检测静默
    @State private var idleManager = IdleTimerManager.shared
    
    var body: some View {
        ZStack {
            NavigationStack {
                homeView
            }
            // 静默模式
            if idleManager.isIdle {
                SlientMode(isSlientMode: $idleManager.isIdle)
                    .environmentObject(idleManager)
            }
        }
    }
    
    // 主视图
    var homeView: some View {
        ZStack {
            Group {
                switch selectedTab {
                    // 主页视图
                case .home:
                    HomeMainView()
                    // 活动视图
                case .activity:
                    HomeActivityView()
                    // 统计视图
                case .settings:
                    HomeSettingsView()
                }
            }
            // 液态玻璃 TabView 视图
            HomeTabView(selectedTab: $selectedTab)
        }
        .background {
            Background()
        }
        .onAppear {
            // 重置计时
            GlobalTouchManager.shared.onTouch = {
                idleManager.resetTimer()
            }
            // 设置计时
            GlobalTouchManager.shared.setup()
        }
        .onChange(of: scenePhase) { _, newPhase in
            // 播放音乐
            guard newPhase == .active else { return }
            // 播放音乐
            if appStorage.isActivityMusic {
                homeActivityVM.playMusicForCurrentTab(for: homeActivityVM.tab)    // 播放音乐
            }
        }
        // 监听应用状态，如果返回，则调用 Widget 保存数据
        .onChange(of: scenePhase) { _,newPhase in
            if newPhase == .active {
                // App 进入活跃状态
                print("App 进入活跃状态")
            }
            if newPhase == .background {
                // 在应用进入后台时保存数据
                saveWidgetData()
                print("应用移入后台，调用Widget保存数据")
            }
            if newPhase == .inactive {
                // 应用即将终止时保存数据（iOS 15+）
                saveWidgetData()
                print("非活跃状态，调用Widget保存数据")
            }
        }
        .environment(homeActivityVM)
        .environment(homeVM)
        .environment(idleManager)
    }
}


#Preview {
    ContentView()
        .modelContainer(PiggyBank.preview)
        .environment(SoundManager.shared) // 加载音乐环境
        .environment(AppStorageManager.shared)    // 加载 UserDefaults 属性环境
        .environment(IAPManager.shared)    // 加载内购商品环境
        .environment(ModelConfigManager.shared)    // 加载 iCloud 配置环境
        .modelContainer(ModelContainerManager.shared.container)   // 加载 iCloud 容器环境
}
