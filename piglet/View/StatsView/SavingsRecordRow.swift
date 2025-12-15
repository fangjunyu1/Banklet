//
//  SavingsRecordRow.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/3.
//

import SwiftUI

struct SavingsRecordRow: View {
    @Environment(\.colorScheme) var colorScheme
    let record: SavingsRecord
        
    var body: some View {
        HStack(spacing: 15) {
            // 存钱罐图标
            ZStack {
                Circle()
                    .frame(width:35)
                    .foregroundColor(.blue.opacity(0.1))
                Image(systemName: record.piggyBank?.icon ?? "questionmark.circle")
                    .imageScale(.small)
                    .foregroundColor(.blue)
            }
            // 存钱罐名称和时间、金额
            VStack(spacing: 5) {
                // 奔驰车和金额
                HStack {
                    Text(LocalizedStringKey(record.piggyBank?.name ?? "Unknown"))
                        .font(.footnote)
                        .fontWeight(.medium)
                    Text("Regular")
                        .font(.caption2)
                        .textScale(.secondary)
                        .foregroundColor(.white)
                        .padding(.horizontal,6)
                        .background(Color.blue)
                        .cornerRadius(5)
                        .opacity(record.type == SavingsRecordType.automatic.rawValue ? 1 : 0)
                        .onAppear {
                            print("record.type:\(record.type)")
                        }
                    Spacer()
                    Text(LocalizedStringKey(record.amountText))
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                }
                // 存取时间、备注和存入/取出
                HStack {
                    let formattedDate = record.date.formatted(Date.FormatStyle().hour().minute())
                    Text(formattedDate)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text(record.note ?? "")
                        .font(.caption2)
                    Spacer()
                    HStack(spacing:5) {
                        Image(systemName: record.saveMoney ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill")
                        Text(record.saveMoney ? "Deposit" : "Withdraw")
                    }
                    .font(.caption2)
                    .foregroundColor(record.saveMoney ? AppColor.green : AppColor.red)
                }
            }
        }
        .frame(height:40)
        .padding(10)
        .modifier(WhiteBgModifier())
        .cornerRadius(10)
    }
}
