//
//  MoreInformationView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/14.
//

import SwiftUI
import SwiftData

struct MoreInformationView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @Query(filter: #Predicate<PiggyBank> { $0.isPrimary == true })
    var piggyBank: [PiggyBank]
    @State private var EditStatus = false   // true表示编辑状态
    @State private var EditName = ""    // 编辑名称
    @State private var EditTargetAmount = "" // 编辑金额
    
    
    // 存钱进度
    var accessProgress: Double {
        let progress = piggyBank[0].amount / piggyBank[0].targetAmount
        return min(progress,1)
    }
    
    // 存取次数
    var recordCount: Int {
        let count = (piggyBank[0].records ?? []).count
        return count
    }
    
    var recordRecentlyDate: Date {
        let recentDate = (piggyBank[0].records?.sorted(by: {$0.date > $1.date}).first?.date ?? Date())
        return recentDate
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                
                List {
                    Section(header: Text("Piggy Bank Information")) {
                        // 名称
                        HStack {
                            Text("Name")
                            Spacer()
                            TextField("", text: Binding (
                                get: {
                                    if EditName.isEmpty {
                                        piggyBank[0].name
                                    } else {
                                        EditName
                                    }
                                },
                                set: {
                                    EditName = $0
                                }
                            ))
                            .foregroundColor(EditStatus ? colorScheme == .light ? .black :.white : .gray)
                            .multilineTextAlignment(.trailing) // 文本靠右对齐
                            .disabled(EditStatus ? false : true)
                        }
                        // 图标
                        HStack {
                            Text("icon")
                            Spacer()
                            Image(systemName: "\(piggyBank[0].icon)")
                                .foregroundColor(.gray)
                        }
                        // 当前金额
                        HStack {
                            Text("Current amount")
                            Spacer()
                            Text("\(piggyBank[0].amount.formattedWithTwoDecimalPlaces())")
                                .foregroundColor(.gray)
                        }
                        // 目标金额
                        HStack {
                            Text("Target amount")
                            Spacer()
                            TextField("", text: Binding (
                                get: {
                                    // 如果用户输入为空，则显示模型中的值；否则显示用户输入的值
                                    if EditTargetAmount.isEmpty {
                                        return piggyBank[0].targetAmount.formattedWithTwoDecimalPlaces()
                                    } else {
                                        // 确保用户输入是合法数字，如果非法则返回默认值
                                        if let validAmount = Double(EditTargetAmount) {
                                            return validAmount.formattedWithTwoDecimalPlaces()
                                        } else {
                                            return "0.00"
                                        }
                                    }
                                },
                                set: { newValue in
                                    let userInput = parseInput(newValue)
                                    EditTargetAmount = String(userInput)
                                }
                            ))
                            .foregroundColor(EditStatus ? colorScheme == .light ? .black :.white : .gray)
                            .multilineTextAlignment(.trailing) // 文本靠右对齐
                            .disabled(EditStatus ? false : true)
                        }
                        // 存取进度
                        HStack {
                            Text("Saving progress")
                            Spacer()
                            Text(accessProgress,format: .percent.precision(.fractionLength(2)))
                                .foregroundColor(.gray)
                        }
                        // 创建日期
                        HStack {
                            Text("Creation Date")
                            Spacer()
                            Text(piggyBank[0].creationDate,format: Date.FormatStyle.dateTime)
                                .foregroundColor(.gray)
                        }
                        // 如果有截止日期，显示截止日期
                        if piggyBank[0].isExpirationDateEnabled {
                            // 截止日期
                            HStack {
                                Text("Expiration date")
                                Spacer()
                                Text(piggyBank[0].expirationDate,format: Date.FormatStyle.dateTime)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    Section(header: Text("Access records")) {
                        // 名称
                        HStack {
                            Text("Access times")
                            Spacer()
                            Text("\(recordCount)")
                                .foregroundColor(.gray)
                        }
                        if recordCount != 0 {
                            // 名称
                            HStack {
                                Text("Latest access date")
                                Spacer()
                                Text(recordRecentlyDate,format: Date.FormatStyle.dateTime)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Completed")
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        })
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            // 如果完成编辑（EditStatus 为 true），保存更改
                            if EditStatus {
                                guard !piggyBank.isEmpty else { return } // 确保数组不为空
                                
                                // 更新名称
                                if !EditName.isEmpty {
                                    piggyBank[0].name = EditName
                                }
                                
                                // 更新目标金额
                                if let newTargetAmount = Double(EditTargetAmount), newTargetAmount > 0 {
                                    piggyBank[0].targetAmount = newTargetAmount
                                }
                            }
                            try? modelContext.save()    // 保存
                            EditStatus.toggle()
                        }, label: {
                            Text(EditStatus ? "Finished Editing" : "Edit")
                                .foregroundColor(EditStatus ? .blue : colorScheme == .light ? .black : .white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    MoreInformationView()
        .modelContainer(PiggyBank.preview)
//        .environment(\.locale, .init(identifier: "de"))
}
