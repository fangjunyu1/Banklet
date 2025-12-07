//
//  StatisticsView.swift
//  piglet
//
//  Created by 方君宇 on 2025/2/10.
//

import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    
    @Query var allPiggyBank: [PiggyBank]
    @Query var savingsRecords: [SavingsRecord]
    
    @State private var currentMonth: Date = Date() // 当前显示的月份
    @State private var months: [Date] = []
    
    // 货币符号
//    @AppStorage("CurrencySymbol") var CurrencySymbol = "USD"
    // 清理1.0.6以前可能存在的孤立存取数据
//    @AppStorage("CleanUpOrphanAccessData") var CleanUpOrphanAccessData = false
    
    private let calendar = Calendar.current // current表示默认日历
    
    // 统计图表
    private var data: [(PiggyBank: String, value: Double)] {
        if allPiggyBank.allSatisfy({ $0.amount == 0}) {
            return [("Empty",1.0)]
        } else {
            return allPiggyBank.map{ ($0.name, $0.amount) }
        }
    }
    // 累计存款金额
    private var savingRecordsCount: String {
        var count = 0.0
        for i in allPiggyBank {
            count += i.amount
        }
        return count.formattedWithTwoDecimalPlaces()
    }
    
    // 存取总次数
    private var savingRecordsTimes: Int {
        return savingsRecords.count
    }
    
    // 存钱罐数量
    private var piggyBanksCount: Int {
        return allPiggyBank.count
    }

    // 当前年份
    private func currentYear(for date: Date) -> String {
        let nowYear = calendar.component(.year, from: date)
        return String(nowYear)
    }

    // 获取今年的全部日期
    private func AllMouths(for date: Date) -> [Date]{
        let nowYear = calendar.component(.year, from: date)
        
        // 设置存储的日期
        var months: [Date] = []
        
        // 获取今年的全部月份
        for month in 1...12 {
            let components = DateComponents(year: nowYear, month: month,day: 1)
            if let date = calendar.date(from: components) {
                print(date) // 转换成功后的具体日期
                months.append(date)
            }
        }
        return months
    }
    
    // 获取当前月份的标签（例如：02）
    private func monthLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter.string(from: date)
    }
    
    // 获取当前月份的所有日期
    private func daysInMonth(for date: Date) -> [Int] {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return Array(range)
    }
    
    // 判断某个日期是否有存钱记录
    private func hasSavingRecord(for day: Int, in month: Date) -> Bool {
        let targetDate = calendar.date(bySetting: .day, value: day, of: month)!
        return savingsRecords.contains { calendar.isDate($0.date, inSameDayAs: targetDate) }
    }
    
    // 1.0.6版本更新，清理孤立的存取记录
    func cleanupOrphanedRecords() {
//        guard !CleanUpOrphanAccessData else {
//            print("已经清理过存取记录")
//            return
//        }
        print("进入cleanupOrphanedRecords方法，执行清理任务")
        do {
            // 获取所有 SavingsRecord
            let allRecords = try modelContext.fetch(FetchDescriptor<SavingsRecord>())
            
            // 过滤掉 piggyBank 为空的记录
            let orphanedRecords = allRecords.filter { $0.piggyBank == nil }
            
            // 删除所有孤立的记录
            for record in orphanedRecords {
                modelContext.delete(record)
            }
            
            if !orphanedRecords.isEmpty {
                try modelContext.save() // 仅在有更改时保存
                print("已删除 \(orphanedRecords.count) 条未绑定 PiggyBank 的存取记录")
            } else {
                print("没有孤立的存取记录")
            }
//            CleanUpOrphanAccessData = true
        } catch {
            print("清理失败: \(error)")
        }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                ZStack {
                    // 背景
                    Color(hex: colorScheme == .light ?  "f0f0f0" : "0E0E0E")
                        .ignoresSafeArea()
                    ScrollView(showsIndicators: false) {
                        Spacer().frame(height: 30)
                        // 累计存款金额
                        HStack {
                            // 存款图表
                            Chart(data, id:\.PiggyBank) { item in
                                SectorMark(
                                    angle: .value("Amount", item.value),
                                    innerRadius: .ratio(0.5),
                                    outerRadius: .ratio(1),
                                    angularInset:  1
                                )
                                .foregroundStyle(by: .value("PiggyBank", item.PiggyBank))
                                .cornerRadius(10)
                            }
                            .frame(width: 80)
                            .chartLegend(.hidden)
                            
                            // 竖线
                            Rectangle()
                                .frame(width: 5,height: 50)
                                .padding(.horizontal, 20)
                                .foregroundColor(colorScheme == .light ? Color(hex:"FF4B00") : .gray)
                            // 累计存款金额
                            VStack(alignment: .leading) {
                                Text("Cumulative deposit amount")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                
                                Spacer().frame(height: 10)
                                
                                Text("\(currencySymbolList.first{ $0.currencyAbbreviation == appStorage.CurrencySymbol}?.currencySymbol ?? "$" )" + " " + "\(savingRecordsCount)")
                                
                            }
                        }
                        .padding(10)
                        .frame(width: width)
                        .background(colorScheme == .light ?  .white : Color(hex:"2C2B2D"))
                        .cornerRadius(10)
                        Spacer().frame(height: 20)
                        
                        // 统计显示组件
                        HStack {
                            Group {
                                // 存取总次数
                                HStack {
                                    Image("Statistics1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(minWidth: 30, maxWidth: 60)
                                        .cornerRadius(10)
                                        .opacity(colorScheme == .light ? 1 : 0.8)
                                    
                                    VStack {
                                        Text("Total access times")
                                        Spacer().frame(height: 10)
                                        Text("\(savingRecordsTimes)")
                                    }
                                }
                                // 存钱罐数量
                                HStack {
                                    Image("Statistics2")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(minWidth: 30, maxWidth: 60)
                                        .cornerRadius(10)
                                        .opacity(colorScheme == .light ? 1 : 0.8)
                                    VStack {
                                        Text("Number of piggy banks")
                                        Spacer().frame(height: 10)
                                        Text("\(piggyBanksCount)")
                                    }
                                }
                            }
                            .font(.footnote)
                            .frame(width: width * 0.45,height: 80)
                            .padding(5)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .background(colorScheme == .light ?  .white : Color(hex:"2C2B2D"))
                            .cornerRadius(10)
                            .padding(.horizontal, width * 0.005)
                        }
                        Spacer().frame(height: 30)
                        // 网格统计视图
                        VStack {
                            // 存取方格
                            Text("Access grid")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity,alignment: .leading)
                            Text("\(currentYear(for:Date()))")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity,alignment: .trailing)
                            // 遍历从当年的全部月份和日期
                            ForEach(months, id: \.self ) { month in
                                HStack(spacing:2) {
                                    Text("\(monthLabel(for:month))")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                        .fixedSize()
                                    Spacer().frame(width: 2)
                                    ForEach(daysInMonth(for: month), id: \.self) { day in
                                        Rectangle()
                                            .frame(width: 8, height: 8)
                                            .cornerRadius(1)
                                            .foregroundColor( hasSavingRecord(for: day, in: month) ? colorScheme == .light ? Color(hex:"FF4B00") :  .white: colorScheme == .light ? Color(hex:"C7C7C7") : .gray)
                                        
                                    }
                                    Spacer()
                                }
                            }
                        }
                        Spacer()
                    }
                    .frame(width: width)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .navigationTitle("Statistics")
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
                    .onAppear {
                        // 清理旧的未关联数据
                        cleanupOrphanedRecords()
                        months = AllMouths(for: Date()) // 仅在视图加载时计算一次
                    }
                }
            }
        }
    }
}

#Preview {
    StatisticsView()
        .modelContainer(PiggyBank.preview)
        // .environment(\.locale, .init(identifier: "de"))
        .environment(AppStorageManager.shared)
}
