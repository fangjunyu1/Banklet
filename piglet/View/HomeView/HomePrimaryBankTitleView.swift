//
//  HomePrimaryBankTitleView.swift
//  piglet
//
//  Created by 方君宇 on 2025/12/3.
//

import SwiftUI

// 顶部标题
struct HomePrimaryBankTitleView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var hideAmount = false
    var primaryBank: PiggyBank
    @Binding var showMoreInformation: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // 当前金额
            Text("Current amount")
                .font(.footnote)
                .modifier(GrayTextModifier())
            // 存钱金额
            HStack {
                Button(action: {
                    hideAmount.toggle()
                }, label: {
                    if !hideAmount {
                        Text("\(primaryBank.amountText)")
                            .font(.largeTitle)
                            .imageScale(.large)
                            .fontWeight(.bold)
                    } else {
                        Text(currencySymbol + " " + "****")
                            .font(.largeTitle)
                            .imageScale(.large)
                            .fontWeight(.bold)
                    }
                })
                .modifier(BlueTextModifier())
            }
            // 图标和名称
            HStack(spacing:10) {
                Image(systemName: primaryBank.icon)
                    .imageScale(.small)
                Text(LocalizedStringKey(primaryBank.name))
            }
            .font(.caption2)
            .modifier(BlueTextModifier())
            .padding(.vertical,5)
            .padding(.horizontal,10)
            .modifier(LightBlueBgModifier())
            .cornerRadius(5)
            .onTapGesture {
                showMoreInformation.toggle()
            }
        }
    }
}

#Preview {
    Home()
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
        .environment(\.locale, .init(identifier: "ta"))
}
