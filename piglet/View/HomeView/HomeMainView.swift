//
//  HomeMainView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//
//  默认水平边距为 20
//

import SwiftUI
import SwiftData

struct HomeMainView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    @EnvironmentObject var idleManager: IdleTimerManager
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(AppStorageManager.self) var appStorage
    @State private var showCreateView = false
    @State private var showMoreInformation = false
    
    @Query(
        sort: [
            SortDescriptor(\PiggyBank.sortOrder),
            SortDescriptor(\PiggyBank.creationDate, order: .reverse)
        ]
    )
    var allPiggyBank: [PiggyBank]
    
    // 排序存钱罐列表
    private var sortedPiggyBanks: [PiggyBank] {
        allPiggyBank.sorted {
            if $0.pinnedSortOrder != $1.pinnedSortOrder {
                return $0.pinnedSortOrder < $1.pinnedSortOrder
            }

            if $0.sortOrder != $1.sortOrder {
                return $0.sortOrder < $1.sortOrder
            }

            return $0.creationDate > $1.creationDate
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // 如果有存钱罐
            if !allPiggyBank.isEmpty {
                
                Spacer()
            } else {
                // 显示空白视图
                HomeEmptyView(showCreateView: $showCreateView)
            }
            // 底部空白
            Spacer().frame(height: 50)
        }
        .navigationTitle("存钱罐")
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background {
            BackgroundImgView()
        }
        .navigationDestination(isPresented: $showCreateView) {
            HomeCreateView()
        }
        // 检查存钱罐的定期存款逻辑
        .onChange(of: scenePhase) { _, newValue in
            // 如果应用为活跃状态
            if newValue == .active {
                print("检查定期存款逻辑")
                SavingsScheduler.processAutoDeposits(context: context, piggyBank: allPiggyBank)
            }
        }
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
