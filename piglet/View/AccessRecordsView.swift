//
//  AccessRecordsView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/12.
//  存取记录页面

import SwiftUI
import SwiftData

struct AccessRecordsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    var piggyBank: PiggyBank
    
    // 删除存取记录
    func removeRows(at offsets: IndexSet) {
        guard let records = piggyBank.records else { return }
        // 获取排序后的数组
        let sortedRecords = records.sorted(by: { $0.date > $1.date })
        
        // 找到需要移除的元素
        let itemsToRemove = offsets.map { sortedRecords[$0] }
        
        // 从原始数组中移除这些元素
        withAnimation {
            piggyBank.records?.removeAll(where: { itemsToRemove.contains($0) })
        }
        try? modelContext.save()
    }
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                let records = piggyBank.records ?? [] // 解包处理
                VStack {
                    VStack {
                        List {
                            ForEach(records.sorted(by: { $0.date > $1.date }).prefix(50), id: \.self) {record in
                                Section {
                                    VStack {
                                        HStack {
                                            Text("\(NSLocalizedString(piggyBank.name, comment: "存钱罐名称"))")
                                                .fontWeight(.bold)
                                            Spacer()
                                            Image(systemName: "\(piggyBank.icon)")
                                                .foregroundColor(.gray)
                                        }
                                        Rectangle()
                                            .frame(height: 0.5)
                                            .foregroundColor(.gray)
                                            .padding(.bottom,5)
                                        HStack {
                                            (record.saveMoney == true ?
                                             Image(systemName: "arrowshape.down")
                                                .foregroundColor(.green) :
                                                Image(systemName: "arrowshape.up")
                                                .foregroundColor(.red))
                                            .fontWeight(.bold)
                                            VStack(alignment:.leading) {
                                                (record.saveMoney == true ?
                                                 Text("Deposit time") :
                                                    Text("Withdrawal time"))
                                                .font(.footnote)
                                                .fontWeight(.bold)
                                                Text(record.date,format: Date.FormatStyle()
                                                    .year(.defaultDigits)
                                                    .month(.twoDigits)
                                                    .day(.twoDigits)
                                                    .hour(.twoDigits(amPM: .omitted))
                                                    .minute(.twoDigits)
                                                    .locale(Locale(identifier: "en_US"))
                                                )
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                            }
                                            Spacer()
                                            Group {
                                                Text("\(currencySymbolList.first{ $0.currencyAbbreviation == appStorage.CurrencySymbol}?.currencySymbol ?? "$")") + Text(" ") + Text(record.amount.formattedWithTwoDecimalPlaces())
                                            }
                                            .foregroundColor(record.saveMoney == true ? .green : .red)
                                            .fontWeight(.bold)
                                        }
                                        
                                    }
                                    .padding(10)
                                }
                                .frame(width: width)
                            }
                            .onDelete(perform: removeRows)
                            .frame(maxWidth: .infinity, alignment: .center) // 将列表居中对齐
                        }
                        .listStyle(.insetGrouped) // 使用分组样式
                    }
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
            }
        }
    }
}

private struct previewAccessRecordsView: View {
    @Query var allpiggyBank: [PiggyBank]
    var body: some View {
        AccessRecordsView(piggyBank: allpiggyBank[0])
    }
}
#Preview {
    previewAccessRecordsView()
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
}
