//
//  TradeButtonView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/22.
//

import SwiftUI

struct TradeButtonView:View {
    @EnvironmentObject var appStorage: AppStorageManager
    // 管理存钱/取钱状态和是否显示TradeView
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var tradeVM: TradeViewModel
    @FocusState.Binding var focus: Bool
    var body: some View {
        // 存钱按钮
        VStack(spacing: 20) {
            Button(action: {
                // 振动
                HapticManager.shared.selectionChanged()
                // 取消输入框焦点
                focus = false
                // 根据存钱状态，调用方法
                switch tradeVM.tradeStatus {
                case .prepare:
                    tradeVM.tradeAmount(piggyBank: homeVM.piggyBank, tardeModel: homeVM.tardeModel)
                case .finish:
                    withAnimation(.easeInOut(duration: 0.3)) { homeVM.isTradeView = false }
                case .loading:
                    break
                }
            }, label: {
                switch tradeVM.tradeStatus {
                case .prepare:
                    Text(homeVM.tardeModel == .deposit ? "Deposit" : "Withdraw")
                        .modifier(ButtonModifier())
                case .loading:
                    Text(homeVM.tardeModel == .deposit ? "Deposit" : "Withdraw")
                        .modifier(ButtonModifier())
                case .finish:
                    Text("Completed")
                        .modifier(ButtonModifier())
                }
            })
            .disabled(tradeVM.tradeStatus == .loading ? true : false )
            Button(action: {
                // 振动
                HapticManager.shared.selectionChanged()
                // 取消任务
                tradeVM.cancelTask()
                // 取消输入框焦点
                focus = false
                withAnimation(.easeInOut(duration: 0.3)) { homeVM.isTradeView = false }
            }, label: {
                Text("Closure")
                    .foregroundColor(AppColor.appGrayColor)
            })
            .opacity(tradeVM.tradeStatus != .finish ? 1 : 0)
        }
    }
}

#Preview {
    PreviewTradeView()
        .environmentObject(AppStorageManager.shared)
}
