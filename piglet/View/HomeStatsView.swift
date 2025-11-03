//
//  HomeStatsView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI
import SwiftData

struct HomeStatsView: View {
    // var allPiggyBank: [PiggyBank]
    var body: some View {
        ScrollView {
            // 统计信息
            HStack {
                // 日期图标、月份、周末
                VStack {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Color(hex: "DC6054"))
                        let now = Date()
                        
                    }
                    Text("123")
                }
                Spacer()
            }
            .padding(20)
        }
        .navigationTitle("Stats")
        .background {
            AppColor.appBgGrayColor
                .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeStatsView()
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
    // .environment(\.locale, .init(identifier: "ru"))
}
