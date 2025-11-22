//
//  TradeShowContentView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/22.
//

import SwiftUI

struct TradeShowContentView: View {
    @EnvironmentObject var appStorage: AppStorageManager
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var tradeVM: TradeViewModel
    var body: some View {
        VStack(spacing: 10) {
            LottieView(filename: "check1", isPlaying: true, playCount: 1, isReversed: false)
                .scaledToFit()
                .scaleEffect(1.2)
                .frame(maxWidth: 100)
            HStack {
                Text(currencySymbol)
                    .font(.system(size: 45))
                    .fontWeight(.bold)
                    .foregroundColor(AppColor.gray)
                Text("\(tradeVM.amount?.formatted() ?? "")")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .frame(width: 230)
            VStack(spacing: 20) {
                // 存钱时间
                HStack {
                    Text("Time")
                    Spacer()
                    Text(tradeVM.date ?? Date(), format: Date.FormatStyle.dateTime)
                        .foregroundColor(AppColor.gray)
                }
                // 存钱备注
                if appStorage.isAccessNotes {
                    HStack {
                        Text("Notes")
                        Spacer()
                        if tradeVM.remark.isEmpty {
                            Text("None")
                                .foregroundColor(AppColor.gray)
                        } else {
                            Text("\(tradeVM.remark)")
                                .foregroundColor(AppColor.gray)
                        }
                    }
                }
            }
            .font(.subheadline)
            .padding(.top,10)
            .padding(.horizontal,20)
        }
    }
}

#Preview {
    PreviewTradeView()
        .environmentObject(AppStorageManager.shared)
}
