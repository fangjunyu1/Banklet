//
//  HomeMainView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI
import SwiftData

struct HomeMainView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    @EnvironmentObject var idleManager: IdleTimerManager
    @EnvironmentObject var homeVM: HomeViewModel
    @State private var showCreateView = false
    @State private var showMoreInformation = false
    
    @Query(sort: [
        SortDescriptor(\PiggyBank.sortOrder),
        SortDescriptor(\PiggyBank.creationDate, order: .reverse)
    ])   // 所有存钱罐，按创建日期排序
    var allPiggyBank: [PiggyBank]
    
    var appStorage = AppStorageManager.shared
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // 如果有存钱罐
            if !allPiggyBank.isEmpty {
                
                // 如果有主存钱罐
//                if allPiggyBank.isEmpty {
//                    // 主存钱罐信息
//                    VStack(spacing: 10) {
//                        // 1、主存钱罐当前金额、金额、图标、名称
//                        HomePrimaryBankTitleView(primaryBank: primaryBank,showMoreInformation: $showMoreInformation)
//                        Spacer().frame(height:10)
//                        // 2、Lottie 动画
//                        LottieView(filename: appStorage.LoopAnimation, isPlaying: appStorage.isLoopAnimation, playCount: 0, isReversed: false)
//                            .id(appStorage.LoopAnimation)
//                            .scaledToFit()
//                            .frame(maxWidth: 160)
//                            .onTapGesture {
//                                appStorage.isLoopAnimation.toggle()
//                            }
//                        // 3、主存钱罐信息、存入、取出、删除视图
//                        HomePrimaryBankButtonView(primaryBank: primaryBank, showMoreInformation: $showMoreInformation)
//                            .padding(.top,20)
//                            .padding(.vertical,20)
//                        // 4、高级功能、创建存钱罐、存取进度
//                        HomePrimaryBankAdvancedFeatures(primaryBank: primaryBank,showCreateView: $showCreateView)
//                    }
//                    .sheet(isPresented: $showMoreInformation) {
//                        NavigationStack {
//                            HomeMoreInformationView(primary: primaryBank)
//                                .environment(idleManager)
//                        }
//                    }
//                    .sheet(isPresented: $homeVM.isTradeView) {
//                        NavigationStack {
//                            TradeView()
//                                .environment(appStorage)
//                                .environment(homeVM)
//                                .environmentObject(idleManager)
//                        }
//                    }
//                }
                Spacer()
            } else {
                // 显示空白视图
                HomeEmptyView(showCreateView: $showCreateView)
            }
            // 底部空白
            Spacer().frame(height: 50)
        }
        .navigationTitle("Home")
        .padding(.horizontal,20)
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
