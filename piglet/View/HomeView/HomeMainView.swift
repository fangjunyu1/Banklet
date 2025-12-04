//
//  HomeMainView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI

struct HomeMainView: View {
    @State private var searchText = ""  // 搜索框
    @State private var showCreateView = false
    @State private var showMoreInformation = false
    var allPiggyBank: [PiggyBank]
    var primaryBank: PiggyBank?
    var appStorage = AppStorageManager.shared
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // 如果有存钱罐
            if !allPiggyBank.isEmpty {
                // 如果有主存钱罐
                if let primaryBank = primaryBank {
                    // 主存钱罐信息
                    VStack(spacing: 10) {
                        // 1、主存钱罐当前金额、金额、图标、名称
                        HomePrimaryBankTitleView(primaryBank: primaryBank,showMoreInformation: $showMoreInformation)
                        Spacer().frame(height:10)
                        // 2、Lottie 动画
                        LottieView(filename: appStorage.LoopAnimation, isPlaying: appStorage.isLoopAnimation, playCount: 0, isReversed: false)
                            .id(appStorage.LoopAnimation)
                            .scaledToFit()
                            .frame(maxWidth: 160)
                            .onTapGesture {
                                appStorage.isLoopAnimation.toggle()
                            }
                        // 3、主存钱罐信息、存入、取出、删除视图
                        HomePrimaryBankButtonView(primaryBank: primaryBank, showMoreInformation: $showMoreInformation)
                            .padding(.top,20)
                            .padding(.vertical,20)
                        // 3、高级功能、创建存钱罐、存取进度
                        HomePrimaryBankAdvancedFeatures(primaryBank: primaryBank,showCreateView: $showCreateView)
                    }
                    .padding(20)
                    .sheet(isPresented: $showMoreInformation) {
                        NavigationStack {
                            HomeMoreInformationView(primary: primaryBank)
                        }
                    }
                }
                // 如果有存钱罐列表
                HomeBanksListView(allPiggyBank: allPiggyBank)
                Spacer()
            } else {
                // 显示空白视图
                HomeEmptyView(showCreateView: $showCreateView)
            }
            // 底部空白
            Spacer().frame(height: 50)
        }
        .navigationTitle("Home")
        .background {
            BackgroundImgView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HomeMainToolBarButton(showCreateView: $showCreateView)
            }
        }
        .navigationDestination(isPresented: $showCreateView) {
            HomeCreateView()
        }
    }
}

private struct HomeMainToolBarButton: View {
    @Binding var showCreateView: Bool
    var body: some View {
        Button(action: {
            // 振动
            HapticManager.shared.selectionChanged()
            showCreateView = true
        }, label: {
            Image("plus")
                .resizable()
                .scaledToFit()
                .frame(width: 20,height: 20)
                .padding(5)
                .background(.white)
                .cornerRadius(5)
        })
    }
}

#Preview {
    Home()
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
}
