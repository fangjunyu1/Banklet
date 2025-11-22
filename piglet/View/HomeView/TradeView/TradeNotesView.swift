//
//  TradeNotesView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/22.
//

import SwiftUI

struct TradeNotesView: View {
    @EnvironmentObject var appStorage: AppStorageManager
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var tradeVM: TradeViewModel
    @FocusState.Binding var focus: Bool
    var body: some View {
        HStack {
            Text("Notes")
                .font(.footnote)
                .foregroundColor(AppColor.appGrayColor)
            TextField("", text: $tradeVM.remark)
                .font(.footnote)
                .focused($focus)
                .onChange(of: tradeVM.remark) {
                    // 振动
                    HapticManager.shared.selectionChanged()
                }
        }
        .padding(.vertical,8)
        .padding(.horizontal,10)
        .background(AppColor.gray.opacity(0.3))
        .cornerRadius(6)
        .padding(.top,10)
    }
}
