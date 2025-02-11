//
//  StatisticsView.swift
//  piglet
//
//  Created by 方君宇 on 2025/2/10.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @Query var savingsRecords: [SavingsRecord]
    
    @State private var currentMonth: Date = Date() // 当前显示的月份
    
    private let rows = [GridItem(.adaptive(minimum: 20))] // 网格行的设置
    private let calendar = Calendar.current // current表示默认日历
    
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
    private func hasSavingRecord(for day: Int) -> Bool {
        let targetDate = calendar.date(bySetting: .day, value: day, of: currentMonth)!
        print("targetDate:\(targetDate)")
        return savingsRecords.contains { calendar.isDate($0.date, inSameDayAs: targetDate) }
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                Spacer().frame(height: 30)
                VStack {
                    // 网格统计视图
                    Text("\(monthLabel(for: Date()))")
                        .fontWeight(.bold)
                    // 网格切换
                    TabView {
                        LazyVGrid(columns: rows, spacing: 5) {
                            ForEach(daysInMonth(for: currentMonth), id: \.self) { day in
                                Rectangle()
                                    .cornerRadius(3)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor( hasSavingRecord(for: day) ? colorScheme == .light ? Color(hex:"FF4B00") :  .gray: colorScheme == .light ? Color(hex:"EBEBEB") : .gray)

                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 80)
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
            }
            .onAppear {
                for i in savingsRecords {
                    print("i.date: \(i.date)")
                }
            }
        }
    }
}

#Preview {
    StatisticsView()
}
