//
//  HomeBanksListView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI

struct HomeBanksListView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var allPiggyBank: [PiggyBank]
    
    var body: some View {
        VStack {
            // 我的存钱罐标题和显示更多
            HStack {
                Text("My piggy bank")
                    .fontWeight(.medium)
                Spacer()
                Button(action: {
                    // 振动
                    HapticManager.shared.selectionChanged()
                    print("显示更多")
                }, label: {
                    Text("Show more")
                        .foregroundColor(AppColor.appColor)
                        .font(.footnote)
                })
            }
            // 存钱罐列表
            VStack(spacing: 15) {
                ForEach(Array(allPiggyBank.prefix(3).enumerated()), id: \.offset) { index,item in
                    Button(action: {
                        // 振动
                        HapticManager.shared.selectionChanged()
                        // 选择该存钱罐为主存钱罐
                        homeVM.setPiggyBank(for: item)
                    }, label: {
                        HStack {
                            // 我的存钱罐图标
                            Image(systemName:item.icon)
                                .imageScale(.small)
                                .foregroundColor(AppColor.bankList[index % AppColor.bankList.count])
                                .background {
                                    Rectangle()
                                        .fill(AppColor.bankList[index % AppColor.bankList.count])
                                        .frame(width: 35, height: 35)
                                        .cornerRadius(5)
                                        .opacity(0.1)
                                }
                                .frame(width: 35, height: 35)
                            // 我的存钱罐名称
                            VStack(alignment: .leading,spacing: 3) {
                                Text(LocalizedStringKey(item.name))
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                HStack(spacing:2) {
                                    Text(item.amountText)
                                        .foregroundColor(AppColor.appGrayColor)
                                    Group {
                                        Text("/")
                                        Text(item.targetAmountText)
                                    }
                                    .foregroundColor(Color.gray)
                                }
                                .font(.caption2)
                            }
                            Spacer()
                            // 我的存钱罐进度
                            Text(item.progressText)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                        }
                        .padding(10)
                        .frame(height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .stroke(item.isPrimary ? .blue : .clear, lineWidth: 2)
                                .shadow(radius: 1)
                        )
                    })
                    .contentShape(Rectangle())
                }
            }
        }
        .padding(.vertical,16)
        .padding(.horizontal,16)
        .background(.white)
        .cornerRadius(10)
        .padding(.vertical,5)
        .padding(.horizontal,16)
    }
}
