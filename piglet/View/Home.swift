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
    @State private var homeActivityVM = HomeActivityViewModel()
    @Query(sort: [
        SortDescriptor(\PiggyBank.isPrimary, order: .reverse),
        SortDescriptor(\PiggyBank.sortOrder),
        SortDescriptor(\PiggyBank.creationDate, order: .reverse)
    ])   // 所有存钱罐，按创建日期排序
    var allPiggyBank: [PiggyBank]
    @Query(sort: \SavingsRecord.date, order: .reverse)
    var savingsRecords: [SavingsRecord]  // 存取次数
    @State private var selectedTab = HomeTab.home  // 当前选择的Tab
    @State private var homeVM = HomeViewModel() // 视图步骤
    @State private var isSlientMode = false // 静默视图
    // 获取第一个存钱罐
    var primaryBank: PiggyBank? {
        allPiggyBank.filter { $0.isPrimary }.first
    }
    @State private var lastTouchTime = Date()    // 最后点击时间，检测静默
    // 每秒检查一次
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var idleManager = IdleTimerManager.shared
    @FocusState var focus: Field?
    
    var body: some View {
        ZStack {
            // 主视图
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
                    Background()
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
            .blur(radius: homeVM.isTradeView ? 10 : 0)
            
            // 存取视图
            if homeVM.isTradeView {
                Color.white
                    .opacity(0.1)
                    .onTapGesture {
                        focus = nil
                    }
                TradeView(focus: $focus)
                    .transition(.move(edge: .bottom))   // 从底部滑上来
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: homeVM.isTradeView)
                    .zIndex(1)
            }
            
            if idleManager.isIdle {
                SlientMode(isSlientMode: $idleManager.isIdle)
            }
        }
        .environment(homeActivityVM)
        .environment(homeVM)
        .environmentObject(idleManager)
        .onAppear {
            GlobalTouchManager.shared.onTouch = {
                idleManager.resetTimer()
            }
            GlobalTouchManager.shared.setup()
            // 播放音乐
            if appStorage.isActivityMusic {
                homeActivityVM.playMusicForCurrentTab(for: homeActivityVM.tab)    // 播放音乐
            }
        }
        .contentShape(Rectangle())
        .onChange(of: scenePhase) { _, newValue in
            // 如果应用为活跃状态
            if newValue == .active {
                print("检查定期存款逻辑")
                SavingsScheduler.processAutoDeposits(context: modelContext, piggyBank: allPiggyBank)
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
     .environment(\.locale, .init(identifier: "ta"))
}
