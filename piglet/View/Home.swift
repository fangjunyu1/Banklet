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
    @Query(filter: #Predicate<PiggyBank> { $0.isPrimary == true },
           sort: [SortDescriptor(\.creationDate, order: .reverse)]) var piggyBank: [PiggyBank]
    @Query var allPiggyBank: [PiggyBank]
    @State private var selectedTab = 0  // 当前选择的Tab
    
    // 振动
    let generator = UISelectionFeedbackGenerator()
    ///
    /// if appStorage.isVibration {
    /// 发生振动
    /// generator.prepare()
    /// generator.selectionChanged()
    ///}
    ///
    // 存钱罐差额
    var difference: Double {
        let differenceNum = piggyBank[0].targetAmount - piggyBank[0].amount
        return differenceNum > 0 ? differenceNum : 0.0
    }
    
    // 存钱罐进度
    var progress: Double {
        let progressNum =  piggyBank[0].amount / piggyBank[0].targetAmount
        return progressNum
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景图片
                HomeBackground()
                // 主页视图
                VStack {
                    Text("123")
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            // 新增按钮
                            print("点击了新增按钮")
                        }, label: {
                            Image(systemName: "plus")
                                .background(.white)
                        })
                    }
                }
                // 监听应用状态，如果返回，则调用Widget保存数据
                .onChange(of: scenePhase) { _,newPhase in
                    if newPhase == .active {
                        // App 进入活跃状态
                        print("App 进入活跃状态")
                    }
                    if newPhase == .background {
                        // 在应用进入后台时保存数据
                        saveWidgetData(piggyBank)
                        print("应用移入后台，调用Widget保存数据")
                    }
                    if newPhase == .inactive {
                        // 应用即将终止时保存数据（iOS 15+）
                        saveWidgetData(piggyBank)
                        print("非活跃状态，调用Widget保存数据")
                    }
                }
                // 液态玻璃 TabView 视图
                HomeTabView(selectedTab: $selectedTab)
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
