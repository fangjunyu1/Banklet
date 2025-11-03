//
//  AccessTimesView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/3.
//

import SwiftUI
import SwiftData

struct AccessTimesView: View {
    @Query(sort: \PiggyBank.creationDate)   // 所有存钱罐，按创建日期排序
    var allPiggyBank: [PiggyBank]
    @Query(sort: \SavingsRecord.date, order: .reverse)
    var savingsRecords: [SavingsRecord]  // 存取次数
    
    @State private var selectedBank: PiggyBank? = nil
    @State private var collapsedDates: Set<Date> = []   // 折叠数组
    // 筛选存取信息
    var filterRecords: [SavingsRecord] {
        guard let selectedBank else { return savingsRecords }
        return savingsRecords.filter { $0.piggyBank?.name == selectedBank.name }
    }
    
    // 日期分组的列表
    var groupedRecords: [(date: Date,records:[SavingsRecord])] {
        let calendar = Calendar.current
        // 用字典按“年月日”分组
        let groups = Dictionary(grouping: filterRecords) { record in
            calendar.startOfDay(for: record.date)
        }
        
        // 返回按日期降序的数组
        return groups
            .map { (date: $0.key, records: $0.value) }
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            // 1、全部、存钱罐名称
            ScrollView(.horizontal, showsIndicators: false) {
                FilterTabs(allBanks: allPiggyBank, selectedBank: $selectedBank)
            }
            Spacer().frame(height:20)   // 间隔
            // 存钱罐列表
            LazyVStack(spacing: 10) {
                ForEach(groupedRecords, id:\.date) { group in
                    // 分组标题
                    HStack(spacing: 5) {
                        let weekString = group.date.formatted(.dateTime.weekday(.wide))
                        let dateString = group.date.formatted(.dateTime.year().month().day())
                        Text(weekString + ",")
                        Text(dateString)
                        Spacer()
                        Button(action: {
                            withAnimation {
                                if collapsedDates.contains(group.date) {
                                    collapsedDates.remove(group.date)
                                } else {
                                    collapsedDates.insert(group.date)
                                }
                            }
                        }, label: {
                            Image(systemName: collapsedDates.contains(group.date) ? "chevron.up" : "chevron.down")
                        })
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.vertical,10)
                    if !collapsedDates.contains(group.date) {
                        ForEach(group.records, id:\.self) { item in
                            SavingsRecordRow(record: item)
                        }
                    }
                }
            }
        }
        .navigationTitle("Access times")
        .navigationBarTitleDisplayMode(.inline)
        .padding(20)
        .background {
            // 设置默认的背景灰色，防止各视图切换时显示白色闪烁背景
            AppColor.appBgGrayColor
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}

private struct FilterTabs: View {
    let allBanks: [PiggyBank]
    @Binding var selectedBank: PiggyBank?
    var body: some View {
        HStack {
            TabButton(title: "All", isSelected: selectedBank == nil) {
                withAnimation {
                    selectedBank = nil
                }
            }
            // 存钱罐列表
            ForEach(allBanks, id:\.self) { item in
                TabButton(title: item.name, isSelected: item == selectedBank) {
                    withAnimation {
                        selectedBank = item
                    }
                }
            }
        }
    }
}

private struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(LocalizedStringKey(title))
                .font(.footnote)
                .padding(.vertical, 12)
                .padding(.horizontal, 10)
                .lineLimit(1)
                .foregroundColor(isSelected ? .black : .gray)
                .background {
                    Rectangle()
                        .foregroundColor(isSelected ? .white : .clear)
                }
                .cornerRadius(20)
        }
    }
}

private struct PreviewAccessTimesView: View {
    var body: some View {
        NavigationStack {
            AccessTimesView()
        }
    }
}

#Preview {
    PreviewAccessTimesView()
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
}
