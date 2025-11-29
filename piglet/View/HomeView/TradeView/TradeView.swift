//
//  TradeView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/21.
//

import SwiftUI

enum Field {
    case amount
    case note
}

struct TradeView: View {
    @EnvironmentObject var idleManager: IdleTimerManager
    @EnvironmentObject var appStorage: AppStorageManager
    // 管理存钱/取钱状态和是否显示TradeView
    @EnvironmentObject var homeVM: HomeViewModel
    // 打开存钱/取钱视图时，创建对象并管理金额和备注
    @State private var tradeVM = TradeViewModel()
    @FocusState var focus: Field?
    var body: some View {
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
            TradeButtonView(focus: $focus)
            
            Spacer()
        }
        .animation(.easeInOut, value: tradeVM.tradeStatus)
        .environmentObject(tradeVM)
        .onAppear {
            focus = .amount
        }
        .onAppear {
            // 显示时，设置标志位为 true
            print("显示交易视图，关闭计时器")
            idleManager.isShowingIdleView = true
            idleManager.stopTimer()
        }
        .onDisappear {
            // 隐藏时，设置标志位为 false
            print("关闭交易视图，重启计时器")
            idleManager.isShowingIdleView = false
            idleManager.resetTimer()
        }
    }
}

#Preview {
    PreviewTradeView()
        .environmentObject(AppStorageManager.shared)
}
