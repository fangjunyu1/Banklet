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
    }
}

#Preview {
    PreviewTradeView()
        .environmentObject(AppStorageManager.shared)
}
