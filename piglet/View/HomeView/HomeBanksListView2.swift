//
//  HomeBanksListView2.swift
//  piglet
//
//  Created by 方君宇 on 2025/12/5.
//

import SwiftUI
import SwiftData

struct HomeBanksListView2: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @Query(sort: [
        SortDescriptor(\PiggyBank.isPrimary, order: .reverse),
        SortDescriptor(\PiggyBank.creationDate, order: .reverse)
    ])   // 所有存钱罐，按创建日期排序
    var allPiggyBank: [PiggyBank]
    var body: some View {
        VStack(spacing:15) {
            ForEach(Array(allPiggyBank.enumerated()), id:\.offset) { index,item in
                let itemColor: Color = item.isPrimary ? .white : .primary
                let itemBgColor: Color = item.isPrimary ? .white.opacity(0.25) : AppColor.bankList[index % AppColor.bankList.count]
                let itemProgressColor: Color = item.isPrimary ? .white : AppColor.bankList[index % AppColor.bankList.count]
                let itemProgressAmountColor: Color = item.isPrimary ? .white : AppColor.appGrayColor
                let itemProgressTargetAmountColor: Color = item.isPrimary ? .white.opacity(0.8) : AppColor.gray
                let itemProgressBgColor: Color = item.isPrimary ? AppColor.appBgGrayColor.opacity(0.5) : AppColor.gray.opacity(0.5)
                let vsBgColor: Color = item.isPrimary ? .blue : Color.white
                Button(action: {
                    // 振动
                    HapticManager.shared.selectionChanged()
                    // 选择该存钱罐为主存钱罐
                    homeVM.setPiggyBank(for: item)
                }, label: {
                    VStack(spacing: 10) {
                        HStack(spacing: 15) {
                            Image(systemName:item.icon)
                                .imageScale(.small)
                                .foregroundColor(.white)
                                .background {
                                    Circle()
                                        .foregroundColor(itemBgColor)
                                        .frame(width: 35, height: 35)
                                }
                                .frame(width: 35, height: 35)
                            Spacer()
                            Text(item.progressText)
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .foregroundColor(itemColor)
                                        .minimumScaleFactor(0.5)
                        }
                        HStack {
                            Text(LocalizedStringKey(item.name))
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(itemColor)
                            Spacer()
                            HStack(spacing:3) {
                                Text(item.amountText)
                                    .foregroundColor(itemProgressAmountColor)
                                Text("/")
                                Text(item.targetAmountText)
                            }
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(itemProgressTargetAmountColor)
                        }
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .foregroundColor(itemProgressBgColor)
                                .frame(height:10)
                                .cornerRadius(5)
                            Rectangle()
                                .foregroundColor(itemProgressColor)
                                .frame(width: min(item.progress * 116,116),height:10)
                                .cornerRadius(5)
                        }
                    }
                    .frame(height:80)
                    .padding(10)
                    .background(vsBgColor)
                    .cornerRadius(10)
                })
            }
            Spacer()
        }
        .padding(.top,20)
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .navigationTitle("List")
        .modifier(BackgroundModifier())
    }
}

private struct HomeBanksListRow: View {
    let record: SavingsRecord
    
    var body: some View {
        HStack(spacing: 15) {
            // 存钱罐名称和时间、金额
            VStack(spacing: 5) {
                // 奔驰车和金额
                HStack {
                    Text(LocalizedStringKey(record.piggyBank?.name ?? "Unknown"))
                        .font(.footnote)
                        .fontWeight(.medium)
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
        .background(.white)
        .cornerRadius(10)
    }
}

#Preview {
    NavigationStack {
        HomeBanksListView2()
            .modelContainer(PiggyBank.preview)
            .environment(AppStorageManager.shared)
            .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
            .environmentObject(IAPManager.shared)
            .environmentObject(SoundManager.shared)
            .environmentObject(HomeViewModel())
    }
}
