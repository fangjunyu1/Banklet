//
//  HomeStatsView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI
import SwiftData

struct HomeStatsView: View {
    var allPiggyBank: [PiggyBank]
    var savingsRecords: [SavingsRecord]  // 存取次数
    
    @State var selectedTab1 = StatisticsTab.all
    var filteredBanks: [PiggyBank] {
        switch selectedTab1 {
        case .all:
            allPiggyBank
        case .inProgress:
            allPiggyBank.filter{ $0.progress < 1}
        case .completed:
            allPiggyBank.filter{ $0.progress == 1}
        }
    }
    
    // 本月、日
    var formattedData: String {
        Date().formatted(
            Date.FormatStyle()
                .month(.wide)
                .day(.defaultDigits).day()
        )
    }
    
    // 本周
    var formattedWeekday: String {
        Date().formatted(
            Date.FormatStyle()
                .weekday(.abbreviated)
        )
    }
    
    // 存钱罐金额
    var savingRecordsCount: String {
        var count = 0.0
        for i in allPiggyBank {
            count += i.amount
        }
        return count.formattedWithTwoDecimalPlaces()
    }
    
    // 最近的三条存钱罐
    var recentRecords: [SavingsRecord] {
        Array(savingsRecords.prefix(3))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // 如果统计数据（存钱罐）
            if !allPiggyBank.isEmpty {
                VStack(spacing: 15) {
                    Spacer().frame(height:0)
                    // 1、统计顶部日期、存取次数、存款等信息
                    HStack(spacing:12) {
                        // 日期图标、月份、周末
                        VStack(alignment: .leading,spacing: 10) {
                            HStack(spacing: 10) {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color(hex: "DC6054"))
                                Text("\(formattedData)")
                                    .font(.footnote)
                            }
                            Text("\(formattedWeekday)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        // 分割线
                        Divider().offset(x: 2)
                        // 存取次数
                        NavigationLink(destination: AccessTimesView(), label: {
                            VStack(alignment: .leading,spacing: 10) {
                                HStack(spacing: 10) {
                                    Image(systemName: "square.and.arrow.down.on.square.fill")
                                        .imageScale(.small)
                                        .foregroundColor(.gray)
                                    Text("\(savingsRecords.count)")
                                        .font(.footnote)
                                        .foregroundColor(.black)
                                        .frame(minWidth: 40,alignment: .leading)
                                }
                                Text("Access times")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        })
                        // 分割线
                        Divider().offset(x: 2)
                        // 存款金额
                        VStack(alignment: .leading,spacing: 10) {
                            HStack(spacing: 10) {
                                Text(currencySymbol)
                                    .foregroundColor(.gray)
                                Text(savingRecordsCount)
                                    .font(.footnote)
                            }
                            Text("Deposit Amount")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    // 2、全部、进行中、完成，三个切换进度
                    HStack {
                        HStack(spacing:8) {
                            // 列表（显示最多三个）
                            ForEach(StatisticsTab.allCases, id:\.self) { item in
                                Button(action: {
                                    // 振动
                                    HapticManager.shared.selectionChanged()
                                    withAnimation { selectedTab1 = item }
                                }, label: {
                                    Text(LocalizedStringKey(item.title))
                                        .font(.footnote)
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 20)
                                        .frame(width: 80)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .foregroundColor(selectedTab1 == item ? .black : .gray)
                                        .cornerRadius(20)
                                })
                            }
                        }
                        .background {
                            HStack {
                                Rectangle()
                                    .frame(width:80,height:40)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                                    .offset(x: CGFloat(selectedTab1.rawValue) * CGFloat(88))
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                    // 3、存钱罐列表
                    VStack {
                        ForEach(Array(filteredBanks.enumerated()), id: \.offset) { index,item in
                            // 每一个存钱罐的信息
                            BanksRow(bank: item, index: index)
                        }
                    }
                    // 4、存取次数，显示更多
                    if !savingsRecords.isEmpty {
                        HStack {
                            Text("Access times")
                                .fontWeight(.medium)
                            Spacer()
                            NavigationLink(destination: AccessTimesView(), label: {
                                Text("Show more")
                                    .foregroundColor(AppColor.appColor)
                                    .font(.footnote)
                            })
                        }
                        VStack {
                            ForEach(recentRecords, id:\.self) { item in
                                SavingsRecordRow(record: item)
                            }
                        }
                    }
                }
                Spacer().frame(height:70)   // 增加底部空白间隙
            } else {
                // 没有统计数据
                HomeStatsEmptyView()
            }
        }
        .navigationTitle("Stats")
        .padding(.horizontal,20)
    }
}

struct PreviewHomeStatsView: View {
    @Query(sort: \PiggyBank.creationDate)   // 所有存钱罐，按创建日期排序
    var allPiggyBank: [PiggyBank]
    @Query(sort: \SavingsRecord.date, order: .reverse)
    var savingsRecords: [SavingsRecord]  // 存取次数

    var body: some View {
        NavigationStack {
            HomeStatsView(allPiggyBank: allPiggyBank, savingsRecords: savingsRecords)
                .background {
                    // 设置默认的背景灰色，防止各视图切换时显示白色闪烁背景
                    AppColor.appBgGrayColor
                        .ignoresSafeArea()
                }
        }
    }
}

#Preview {
    PreviewHomeStatsView()
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
}
