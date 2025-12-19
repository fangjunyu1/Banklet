//
//  HomeBanksListView2.swift
//  piglet
//
//  Created by 方君宇 on 2025/12/5.
//

import SwiftUI
import SwiftData

struct HomeBanksListView2: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    @EnvironmentObject var homeVM: HomeViewModel
    var primaryBank: PiggyBank?
    @Query(sort: [
        SortDescriptor(\PiggyBank.isPrimary, order: .reverse),
        SortDescriptor(\PiggyBank.sortOrder),
        SortDescriptor(\PiggyBank.creationDate, order: .reverse)
    ])   // 所有存钱罐，按创建日期排序
    var allPiggyBank: [PiggyBank]
    var body: some View {
        List {
            ForEach(Array(allPiggyBank.enumerated()), id:\.offset) { index,item in
                let primary: Bool = (primaryBank != nil && item == primaryBank)
                let itemColor: Color = primary ? .white : .primary
                var itemBgColor: Color {
                    if colorScheme == .light {
                        primary ? .white.opacity(0.25) : AppColor.bankList[index % AppColor.bankList.count]
                    } else {
                        primary ?
                        AppColor.appColor.opacity(0.8) :
                            .white.opacity(0.25)
                    }
                }
                var itemProgressColor: Color {
                    if colorScheme == .light {
                        primary ? .white : AppColor.bankList[index % AppColor.bankList.count]
                    } else {
                        primary ? .white : .gray
                    }
                }
                let itemProgressAmountColor: Color = primary ? .white : AppColor.appGrayColor
                let itemProgressTargetAmountColor: Color = primary ? .white.opacity(0.8) : AppColor.gray
                let itemProgressBgColor: Color = primary ? AppColor.appBgGrayColor.opacity(0.5) : AppColor.gray.opacity(0.5)
                var vsBgColor: Color {
                    if colorScheme == .light {
                        primary ? .blue : Color.white
                    } else {
                        AppColor.appGrayColor
                    }
                }
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
                    .padding(.horizontal,20)
                })
            }
            .onMove(perform: HomeBanksListMove)
            .onDelete(perform: HomeBanksListDelete)
            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)) // 上下间隔 8
            .listRowBackground(Color.clear) // 保证行之间显示背景间隔
            .listRowSeparator(.hidden)
            .background(Color.clear) // 为整个 List 设置您想要的背景色
        }
        .scrollIndicators(.never)
        .listSectionSeparator(.hidden)
        .listStyle(.plain)
        .padding(.top,20)
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .navigationTitle("List")
        .modifier(BackgroundListModifier())
    }
    
    private func HomeBanksListMove(from indices: IndexSet,to newOffset: Int) {
        var banks = allPiggyBank
        banks.move(fromOffsets: indices, toOffset: newOffset)
        for (index,bank) in banks.enumerated() {
            bank.sortOrder = index
        }
        do {
            try context.save()
        } catch {
            print("保存失败")
        }
    }
    
    private func HomeBanksListDelete(offsets:IndexSet) {
        let itemToRemove = offsets.map { allPiggyBank[$0] }
        
        if let piggyBank = itemToRemove.first {
            homeVM.deletePiggyBank(for: piggyBank)
        }
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
        .cornerRadius(10)
    }
}

#Preview {
    Home()
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
        .environment(\.locale, .init(identifier: "ru"))
}
