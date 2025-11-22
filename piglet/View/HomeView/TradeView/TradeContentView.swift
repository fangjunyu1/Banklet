//
//  TradeContentView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/22.
//

import SwiftUI

struct TradeContentView: View {
    @EnvironmentObject var appStorage: AppStorageManager
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var tradeVM: TradeViewModel
    @FocusState.Binding var focus: Bool
    var body: some View {
        VStack(spacing: 0) {
            // 存钱金额和图标
            HStack(alignment: .top) {
                Text(homeVM.tardeModel == .deposit ? "Amount Deposited" : "Withdraw Amount")
                    .fontWeight(.medium)
                    .font(.title2)
                Spacer()
                VStack(spacing: 3) {
                    Image(systemName: homeVM.piggyBank?.icon ?? "")
                        .imageScale(.small)
                        .foregroundColor(Color(hex: "216DFA"))
                        .padding(8)
                        .background(Color(hex: "216DFA").opacity(0.15))
                        .cornerRadius(5)
                    Text("\(homeVM.piggyBank?.name ?? "")")
                        .font(.footnote)
                        .fontWeight(.medium)
                }
            }
            switch tradeVM.tradeStatus {
            case .finish:
                TradeShowContentView()
            default:
                ZStack {
                    TradeContentAmountView(focus: $focus)
                        .opacity(tradeVM.tradeStatus == .prepare ? 1 : 0)
                    TradeLoadingView()
                        .opacity(tradeVM.tradeStatus == .loading ? 1 : 0)
                }
            }
        }
        .padding(20)
        .frame(width: 320)
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct TradeLoadingView: View {
    var body: some View {
        LottieView(filename: "FreeBlueLoadingAnimation", isPlaying: true, playCount: 0, isReversed: false)
            .scaledToFit()
            .scaleEffect(1.5)
            .frame(maxWidth: 100)
    }
}

struct TradeContentAmountView: View {
    @EnvironmentObject var appStorage: AppStorageManager
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var tradeVM: TradeViewModel
    @FocusState.Binding var focus: Bool
    var body: some View {
        VStack(spacing: 5) {
            HStack(alignment: .center) {
                Text(currencySymbol)
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .foregroundColor(AppColor.gray)
                TextField("_ _ ", value: $tradeVM.amount, format: .number)
                    .fontWeight(.bold)
                    .font(.system(size: 60))
                    .foregroundColor(AppColor.appColor)
                    .focused($focus)
                    .frame(minWidth: 160)
                    .frame(height: 60)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .onChange(of: tradeVM.amount) {
                        // 振动
                        HapticManager.shared.selectionChanged()
                    }
            }
            // 备注
            if appStorage.isAccessNotes {
                TradeNotesView(focus: $focus)
            }
        }
    }
}

#Preview {
    PreviewTradeView()
        .environmentObject(AppStorageManager.shared)
}
