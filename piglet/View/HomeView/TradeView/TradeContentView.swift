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
                VStack(alignment: .trailing,spacing: 3) {
                    Image(systemName: homeVM.piggyBank?.icon ?? "")
                        .imageScale(.small)
                        .foregroundColor(Color(hex: "216DFA"))
                        .padding(8)
                        .background(Color(hex: "216DFA").opacity(0.15))
                        .cornerRadius(5)
                    Text(LocalizedStringKey(homeVM.piggyBank?.name ?? ""))
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
    @State private var textOffset: CGFloat = 40
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Text(currencySymbol)
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .foregroundColor(AppColor.gray)
                    .offset(x: textOffset)
                    .onChange(of: tradeVM.amount) { _, newAmount in
                        if let amount = newAmount {
                            let length = String(Int(amount)).count
                            print("length:\(length)")
                            if length != 1 {
                                if length > 3 {
                                    print("金额超过4位数")
                                    textOffset = 0
                                } else {
                                    print("金额未超过4位数，偏移\(CGFloat(length * -10)),textOffset:\(textOffset)")
                                    textOffset = 40 + CGFloat(length * -10)
                                }
                            }
                        } else {
                            textOffset = 40
                        }
                    }
                TextField("_", value: $tradeVM.amount, format: .number)
                    .fontWeight(.bold)
                    .font(.system(size: 60))
                    .foregroundColor(AppColor.appColor)
                    .focused($focus)
                    .frame(width: 140)
                    .keyboardType(.decimalPad)   // 数字 + 小数点键盘
                    .frame(height: 70)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
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
