//
//  BanksRow.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/3.
//

import SwiftUI

struct BanksRow: View {
    let bank: PiggyBank
    var index: Int
        
    var body: some View {
        VStack {
            // 存钱罐标题、名称和金额
            HStack(spacing:10) {
                Image(systemName: bank.icon)
                    .imageScale(.small)
                Text(LocalizedStringKey(bank.name))
                    .font(.footnote)
                Spacer()
                Text(bank.progressText)
                    .font(.footnote)
            }
            .modifier(DrakGrayTextModifier())
            // 存钱罐金额和进度方格
            HStack(alignment: .bottom) {
                Text(bank.amountText)
                    .font(.footnote)
                    .modifier(DrakGrayTextModifier())
                Spacer()
                // 进度方格
                VStack {
                    GridProgressView(rows: 4, columns: 10, progress: bank.progress,filledColor:AppColor.bankList[index % AppColor.bankList.count])
                }
            }
        }
        .padding(20)
        .modifier(WhiteBgModifier())
        .cornerRadius(10)
    }
}
