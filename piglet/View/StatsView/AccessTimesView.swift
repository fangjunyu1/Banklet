//
//  AccessTimesView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/3.
//

import SwiftUI
import SwiftData

struct AccessTimesView: View {
    @Environment(\.modelContext) var modelContext   // 容器上下文
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
            .sorted { $0.date > $1.date}
    }
    
    // 删除存取记录
    func removeGroupedRows(_ offsets: IndexSet, from record: [SavingsRecord]) {
        let itemToRemove = offsets.map { record[$0] }
        
        withAnimation {
            for item in itemToRemove {
                modelContext.delete(item)
            }
        }
        
        try? modelContext.save()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 1、全部、存钱罐名称
            ScrollView(.horizontal, showsIndicators: false) {
                FilterTabs(allBanks: allPiggyBank, selectedBank: $selectedBank)
            }
            // 2、存钱罐列表
            List {
                ForEach(groupedRecords, id:\.date) { group in
                    Section(header: groupRecordsHeader(group: group,collapsedDates: $collapsedDates)) {
                        if !collapsedDates.contains(group.date) {
                            ForEach(group.records, id:\.self) { item in
                                SavingsRecordRow(record: item)
                            }
                            .onDelete { offsets in
                                removeGroupedRows(offsets, from: group.records)
                            }
                        }
                    }
                }
                .background(Color.clear)
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)) // 上下间隔 8
                .listRowBackground(Color.clear) // 保证行之间显示背景间隔
                .listRowSeparator(.hidden)
                .background(Color.clear) // 为整个 List 设置您想要的背景色
            }
            .listStyle(.plain)
        }
        .navigationTitle("Access records")
        .padding(.top, 20)
        .modifier(BackgroundModifier())
    }
}

private struct groupRecordsHeader: View {
    let group: (date: Date,records:[SavingsRecord])
    @Binding var collapsedDates: Set<Date>
    var weekString: String {
        group.date.formatted(.dateTime.weekday(.wide))
    }
    var dateString: String {
        group.date.formatted(.dateTime.year().month().day())
    }
    var body: some View {
        HStack {
            Text(weekString + "," + dateString).font(.caption2)
            Spacer()
            Button(action: {
                // 振动
                HapticManager.shared.selectionChanged()
                withAnimation {
                    if collapsedDates.contains(group.date) {
                        collapsedDates.remove(group.date)
                    } else {
                        collapsedDates.insert(group.date)
                    }
                }
            }, label: {
                Image(systemName: collapsedDates.contains(group.date) ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            })
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
private struct FilterTabs: View {
    let allBanks: [PiggyBank]
    @Binding var selectedBank: PiggyBank?
    var body: some View {
        HStack {
            TabButton(title: "All", isSelected: selectedBank == nil) {
                // 振动
                HapticManager.shared.selectionChanged()
                withAnimation {
                    selectedBank = nil
                }
            }
            // 存钱罐列表
            ForEach(allBanks, id:\.self) { item in
                TabButton(title: item.name, isSelected: item == selectedBank) {
                    // 振动
                    HapticManager.shared.selectionChanged()
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
        Button(action: {
            action()
        }, label: {
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
        })
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
