//
//  DetailView.swift
//  piglet
//
//  Created by 方君宇 on 2025/2/3.
// 详细信息视图

import SwiftUI
import Charts

struct DetailView: View {
    
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    var CurrentAmount: Double
    var TargetAmount: Double
    var SavingProgress:Double {
        return max(min(CurrentAmount / TargetAmount * 100,100),0)
    }
    var data:[(label: String, value: Double)] {
        return [
            (String(localized:"Deposit"), CurrentAmount),   // 已存入金额
            (String(localized:"Remaining"), max(TargetAmount - CurrentAmount,0))
        ]
    }
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                Spacer().frame(height: 30)
                HStack {
                    // 可视化图表
                    Chart(data, id: \.label) { item in
                        SectorMark(
                            angle: .value("Amount", item.value),
                            innerRadius: .ratio(0.5),
                            outerRadius: .ratio(1),
                            angularInset: 1
                        )
                        .cornerRadius(7)
                        .foregroundStyle(by: .value("Amount", item.label))
                    }
                    .frame(width: 120, height: 170)
                    .padding(20)
                    // 列表信息
                    VStack {
                        // 当前进度
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Current amount")
                                    .font(.footnote)
                                Text("$")
                                    .font(.footnote)
                                + Text(" ") +
                                Text(CurrentAmount.formattedWithTwoDecimalPlaces())
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            Spacer()
                        }
                        // 分割线
                        Rectangle()
                            .frame(maxWidth:.infinity)
                            .frame(height: 0.5)
                            .foregroundColor(.gray)
                            .padding(.vertical,3)
                        // 目标金额
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Target amount")
                                    .font(.footnote)
                                Text("$")
                                    .font(.footnote)
                                + Text(" ") + Text(TargetAmount.formattedWithTwoDecimalPlaces())
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            Spacer()
                        }
                        // 分割线
                        Rectangle()
                            .frame(maxWidth:.infinity)
                            .frame(height: 0.5)
                            .foregroundColor(.gray)
                            .padding(.vertical,3)
                        // 存钱进度
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Saving progress")
                                    .font(.footnote)
                                Text(SavingProgress.formattedWithTwoDecimalPlaces())
                                    .font(.title3)
                                    .fontWeight(.bold)
                                + Text(" ") +
                                Text("%")
                                    .font(.footnote)
                            }
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            Spacer()
                        }
                    }
                }
                .frame(width: width)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .navigationTitle("Saving progress")
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
    DetailView(CurrentAmount: 200, TargetAmount: 500)
        .environment(\.locale, .init(identifier: "de"))
}
