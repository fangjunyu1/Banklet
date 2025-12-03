//
//  HomePrimaryBankTitleView.swift
//  piglet
//
//  Created by 方君宇 on 2025/12/3.
//

import SwiftUI

// 顶部标题
struct HomePrimaryBankTitleView: View {
    var primaryBank: PiggyBank
    
    var body: some View {
        VStack(spacing: 20) {
            // 当前金额
            Text("Current amount")
                .font(.footnote)
                .foregroundColor(AppColor.gray)
            // 存钱金额
            HStack {
                Text("\(primaryBank.amountText)")
                    .font(.largeTitle)
                    .imageScale(.large)
                    .fontWeight(.bold)
            }
            // 图标和名称
            HStack(spacing:10) {
                Image(systemName: primaryBank.icon)
                    .imageScale(.small)
                Text(LocalizedStringKey(primaryBank.name))
            }
            .font(.caption2)
            .foregroundColor(AppColor.appColor)
            .padding(.vertical,5)
            .padding(.horizontal,10)
            .background(AppColor.appColor.opacity(0.1))
            .cornerRadius(5)
        }
    }
}
