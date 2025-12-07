//
//  TradeButtonView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/22.
//

import SwiftUI
import StoreKit

struct TradeButtonView:View {
    @EnvironmentObject var appStorage: AppStorageManager
    // 管理存钱/取钱状态和是否显示TradeView
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var tradeVM: TradeViewModel
    @FocusState.Binding var focus: Field?
    var body: some View {
        // 存钱按钮
        VStack(spacing: 20) {
            Button(action: {
                // 振动
                HapticManager.shared.selectionChanged()
                // 取消输入框焦点
                focus = nil
                // 根据存钱状态，调用方法
                switch tradeVM.tradeStatus {
                case .prepare:
                    tradeVM.tradeAmount(piggyBank: homeVM.piggyBank, tardeModel: homeVM.tardeModel)
                case .finish:
                    withAnimation(.easeInOut(duration: 0.3)) { homeVM.isTradeView = false }
                    // 评分弹窗
                    if !appStorage.isRatingWindow {
                        SKStoreReviewController.requestReview()
                        appStorage.isRatingWindow = true
                    } else {
                        print("已经弹出过评分弹窗，不再设置")
                    }
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
                
                UIView.animate(withDuration: 0.3) {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                
                withAnimation(.easeInOut(duration: 0.3)) { homeVM.isTradeView = false }
                // 取消任务
                tradeVM.cancelTask()
            }, label: {
                Text("Closure")
                    .foregroundColor(AppColor.appGrayColor)
            })
            .opacity(tradeVM.tradeStatus != .finish ? 1 : 0)
        }
    }
}
