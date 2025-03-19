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
    
    // 货币符号
//    @AppStorage("CurrencySymbol") var CurrencySymbol = "USD"
    
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
                    if records.isEmpty {
                        Image("emptyBox")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 0.8 * width)
                        Text("Image by freepik")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .offset(x:100, y: -20)
                        Text("This is empty.")
                        Spacer()
                    } else {
                        VStack {
                            List {
                                ForEach(records.sorted(by: { $0.date > $1.date }).prefix(50), id: \.self) {record in
                                    Section {
                                        VStack {
                                            HStack {
                                                Text("\(piggyBank.name)")
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
                                            if let note = record.note,!note.isEmpty {
                                                Rectangle()
                                                    .frame(height: 0.5)
                                                    .foregroundColor(.gray)
                                                    .font(.footnote)
                                                    .padding(.bottom,5)
                                                HStack {
                                                    Text("Notes")
                                                        .fontWeight(.bold)
                                                        .font(.footnote)
                                                    Text("\(note)")
                                                        .foregroundColor(.gray)
                                                        .font(.footnote)
                                                    Spacer()
                                                }
                                            }
                                            
                                        }
                                        .padding(10)
                                    }
                                    .frame(width: width)
                                }
                                .onDelete(perform: removeRows)
                                .frame(maxWidth: .infinity, alignment: .center) // 将列表居中对齐
                                Section(footer: Text("By default, the most recent 50 records are displayed.")
                                    .foregroundStyle(.gray)
                                    .font(.footnote)
                                    .background(.clear)){}
                            }
                            .listStyle(.insetGrouped) // 使用分组样式
                        }
                    }
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .navigationTitle("Access records")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement:.topBarLeading) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Completed")
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    let container = PiggyBank.preview
    let context = container.mainContext
    let places = try! context.fetch(FetchDescriptor<PiggyBank>()) // 从上下文中获取数据
    return AccessRecordsView(piggyBank: places[0])
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
}
