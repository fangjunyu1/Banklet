//
//  TradeView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/21.
//

import SwiftUI

struct TradeView: View {
    @EnvironmentObject var appStorage: AppStorageManager
    // 管理存钱/取钱状态和是否显示TradeView
    @EnvironmentObject var homeVM: HomeViewModel
    // 打开存钱/取钱视图时，创建对象并管理金额和备注
    @State private var tradeVM = TradeViewModel()
    @FocusState private var focus: Bool
    var body: some View {
        ZStack {
            // 白色模糊背景
            Rectangle()
                .foregroundColor(.white)
                .ignoresSafeArea()
                .opacity(0.5)
                .onTapGesture {
                    focus = false   // 点击背景，关闭输入框
                }
            // 视图
            VStack(spacing: 40) {
                // 负债名称
                Text("Debt Model")
                    .foregroundColor(Color(hex: "FF7D14"))
                    .padding(.vertical,8)
                    .padding(.horizontal,16)
                    .background(Color(hex: "FF7D14").opacity(0.1))
                    .cornerRadius(10)
                    .opacity(appStorage.isDebtModel ? 1 : 0)
                // 存钱视图
                TradeContentView(focus: $focus)
                if tradeVM.tradeStatus != .finish {
                    Spacer().frame(height:20)
                }
                TradeButtonView(focus: $focus)
                
                Spacer()
            }
            .animation(.easeInOut, value: tradeVM.tradeStatus)
        }
        .environmentObject(tradeVM)
    }
}

#Preview {
    PreviewTradeView()
        .environmentObject(AppStorageManager.shared)
}
