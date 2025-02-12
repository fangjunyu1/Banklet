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
    
    @Query var allPiggyBank: [PiggyBank]
    @Query var savingsRecords: [SavingsRecord]
    
    @State private var currentMonth: Date = Date() // 当前显示的月份
    @State private var selectedTab: String = ""
    @State private var months: [Date] = []
    
    // 货币符号
    @AppStorage("CurrencySymbol") var CurrencySymbol = "USD"
    // 清理1.0.6以前可能存在的孤立存取数据
    @AppStorage("CleanUpOrphanAccessData") var CleanUpOrphanAccessData = false
    
    private let rows = [GridItem(.adaptive(minimum: 20))] // 网格行的设置
    private let calendar = Calendar.current // current表示默认日历
    
    // 统计图表
    private var data: [(PiggyBank: String, value: Double)] {
        if allPiggyBank.isEmpty {
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
    
    // 获取 2025年1月 到当前月份的日期
    private func AllMouths(for date: Date) -> [Date]{
        var calendar = Calendar.current // 当前日历
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        // 2025年1月的起始日期
        var components = DateComponents()
        components.year = 2025
        components.month = 1
        components.day = 1
        
        // 获取起始日期
        guard let startDate = calendar.date(from: components) else {
            return [] // 如果 `startDate` 为空，则返回空数组
        }
        print("startDate:\(startDate)")  // 输出：2025-01-01 00:00:00 +0000 (UTC)
        
        // 设置存储的日期
        var months: [Date] = []
        var currentAllMonth = startDate
        
        // 循环到当前月份
        while currentAllMonth <= date {
            months.append(currentAllMonth)
            if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentAllMonth) {
                currentAllMonth = nextMonth
            } else {
                break
            }
        }
        return months
    }
    
    // 获取当前月份的标签（例如：2025-2）
    private func monthLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
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
        guard !CleanUpOrphanAccessData else {
            print("已经清理过存取记录")
            return
        }
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
            CleanUpOrphanAccessData = true
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
                                
                                Spacer().frame(height: 10)
                                
                                Text("\(currencySymbolList.first{ $0.currencyAbbreviation == CurrencySymbol}?.currencySymbol ?? "$" )" + " " + "\(savingRecordsCount)")
                                
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
                                        Text("Total number of deposits and withdrawals")
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
                            .frame(width: width * 0.48,height: 80)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .background(colorScheme == .light ?  .white : Color(hex:"2C2B2D"))
                            .cornerRadius(10)
                            .padding(.horizontal, width * 0.012)
                        }
                        Spacer().frame(height: 30)
                        // 网格统计视图
                        VStack {
                            // 存取方格
                            Text("Access grid")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity,alignment: .leading)
                            Text("\(selectedTab)")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity,alignment: .trailing)
                            // 网格切换
                            TabView(selection: $selectedTab) {
                                // 遍历从2025年1月1日到现在的月份
                                ForEach(months, id: \.self ) { month in
                                    LazyVGrid(columns: rows, spacing: 5) {
                                        ForEach(daysInMonth(for: month), id: \.self) { day in
                                            Rectangle()
                                                .cornerRadius(3)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor( hasSavingRecord(for: day, in: month) ? colorScheme == .light ? Color(hex:"FF4B00") :  .white: colorScheme == .light ? Color(hex:"C7C7C7") : .gray)
                                            
                                        }
                                    }
                                    .tag("\(monthLabel(for: month))")
                                    .padding(10)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .frame(height: 80)
                            .id("\(selectedTab)")
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
                        cleanupOrphanedRecords()
                        if let lastMonth = AllMouths(for: Date()).last {
                            selectedTab = monthLabel(for: lastMonth)
                        }
                        months = AllMouths(for: Date()) // 仅在视图加载时计算一次
                        for i in allPiggyBank {
                            print("存钱罐名称:\(i.name)")
                        }
                        for i in savingsRecords {
                            print("存取记录日期：\(i.date)")
                            print("存取记录关联的存钱罐:\(i.piggyBank?.name)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    StatisticsView()
        .modelContainer(PiggyBank.preview)
}
