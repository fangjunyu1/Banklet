//
//  HomeMainView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI

struct HomeMainView: View {
    @Binding var searchText: String
    var allPiggyBank: [PiggyBank]
    var primaryBank: PiggyBank?
    var appStorage = AppStorageManager.shared
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // 如果有存钱罐
            if !allPiggyBank.isEmpty {
                // 顶部动画效果
                HStack {
                    Spacer()
                    LottieView(filename: appStorage.LoopAnimation, isPlaying: appStorage.isLoopAnimation, playCount: 0, isReversed: false)
                        .id(appStorage.LoopAnimation)
                        .modifier(LottieModifier3())
                }
                // 如果有主存钱罐
                if let primaryBank = primaryBank {
                    // 主存钱罐视图
                    HomePrimaryBankView(primaryBank: primaryBank)
                }
                // 如果有存钱罐列表
                HomeBanksListView(allPiggyBank: allPiggyBank)
                Spacer()
            } else {
                // 显示空白视图
                HomeEmptyView()
            }
            // 底部空白
            Spacer().frame(height: 50)
        }
        .navigationTitle("Home")
        .searchable(text: $searchText, prompt: "Search for piggy banks")
        .background {
            BackgroundImgView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    // 新增按钮
                    print("点击了新增按钮")
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
    }
}
