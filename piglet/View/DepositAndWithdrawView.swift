//
//  DepositAndWithdrawView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/10.
//

import SwiftUI
import SwiftData

struct DepositAndWithdrawView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @Query(filter: #Predicate<PiggyBank> { $0.isPrimary == true })
    var piggyBank: [PiggyBank]
    @FocusState private var isFocus: Bool
    @State private var deposit = true
    @State private var selectedOption = "Deposit"
    @State private var EnterAmount: Double = 0.0    // 输入框的金额
    @Binding var isReversed: Bool
    let options = ["Deposit","Withdraw"]
    // 新增 onComplete 回调
    var onComplete: () -> Void = {}
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                ZStack {
                    Color(hex: colorScheme == .light ?  "f0f0f0" : "0E0E0E")
                        .ignoresSafeArea()
                        .onTapGesture {
                            isFocus = false
                        }
                    VStack {
                        // 选取
                        Picker("", selection: $selectedOption) {
                            ForEach(options, id: \.self) { option in
                                Text(LocalizedStringKey(option)).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.vertical, 20)
                        // 设置存入/取出金额
                        HStack {
                            Text(selectedOption == "Deposit" ?  LocalizedStringKey("Deposit amount") : LocalizedStringKey("Withdraw amount"))
                                .padding(.horizontal,20)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .onTapGesture {
                                    isFocus = false
                                }
                            TextField(selectedOption == "Deposit" ?  LocalizedStringKey("Please enter deposit amount") : LocalizedStringKey("Please enter withdrawal amount"), text: Binding(
                                get: {
                                    EnterAmount == 0 ? "" : String(EnterAmount.formattedWithTwoDecimalPlaces())
                                },
                                set: { newValue in
                                    let userInput = parseInput(newValue)
                                    EnterAmount = Double(userInput)
                                }
                            ))
                            .focused($isFocus)
                            .keyboardType(.decimalPad)
                            .submitLabel(.continue)
                            .padding(.trailing,20)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            
                        }
                        .frame(width: width,height: 66)
                        .background(colorScheme == .light ? .white : Color(hex:"1f1f1f"))
                        .cornerRadius(10)
                        Spacer().frame(height:20)
                        // 存取按钮
                        Button(action: {
                            // 设置动画方向，如果是存入，动画正放
                            // 如果是取出，动画反放
                            if selectedOption == "Deposit" {
                                isReversed = false
                            } else {
                                isReversed = true
                            }
                            
                            // 只有输入的金额不为0或不为空时，才会计算存入/取出金额并插入存取记录。
                            if EnterAmount != 0 {
                                // 处理存入/取出金额
                                if selectedOption == "Deposit" {
                                    // 存入金额的情况
                                    if EnterAmount + piggyBank[0].amount >= piggyBank[0].targetAmount {
                                        
                                        // 如果当前存钱罐不是满的，当存入金额大于等于目标金额时，记录完成日期
                                        if piggyBank[0].amount != piggyBank[0].targetAmount {
                                            // 记录完成日期
                                            piggyBank[0].completionDate = Date()
                                        }
                                        // 新增存取记录为，目标金额 - 当前金额 = 本次存满的差额。
                                        // 存取记录的金额为存满的差额
                                        let savingRecord = SavingsRecord(amount: piggyBank[0].targetAmount - piggyBank[0].amount, saveMoney: true,piggyBank: piggyBank[0])
                                        modelContext.insert(savingRecord)
                                        // 新增存取记录
                                        
                                        
                                        // 如果 当前金额 + 存入金额 >= 目标金额
                                        // 当前金额 = 目标金额
                                        piggyBank[0].amount = piggyBank[0].targetAmount
                                        
                                    } else {
                                        // 新增存取记录为： 存入金额
                                        let savingRecord = SavingsRecord(amount: EnterAmount, saveMoney: true,piggyBank: piggyBank[0])
                                        modelContext.insert(savingRecord)
                                        
                                        // 否则，当前金额 = 当前金额 + 存入金额
                                        piggyBank[0].amount = EnterAmount + piggyBank[0].amount
                                        
                                    }
                                } else {
                                    // 取出金额的情况
                                    if EnterAmount >= piggyBank[0].amount {
                                        // 新增取出记录为： 取出金额为当前的所有金额
                                        let savingRecord = SavingsRecord(amount: piggyBank[0].amount, saveMoney: false,piggyBank: piggyBank[0])
                                        modelContext.insert(savingRecord)
                                        
                                        
                                        // 如果 取出金额 >= 当前金额
                                        // 当前金额为 0
                                        piggyBank[0].amount = 0
                                    } else {
                                        // 新增取出记录为： 取出金额为本次取出的金额
                                        let savingRecord = SavingsRecord(amount: EnterAmount, saveMoney: false,piggyBank: piggyBank[0])
                                        modelContext.insert(savingRecord)
                                        
                                        
                                        // 否则，当前金额 = 当前金额 - 取出金额
                                        piggyBank[0].amount = piggyBank[0].amount - EnterAmount
                                    }
                                }
                                // 保存上下文
                                do {
                                    try modelContext.save()
                                    print("PiggyBank records after operation: \(piggyBank[0].records)")
                                } catch {
                                    print("Failed to save context: \(error)")
                                }
                            }
                            
                            
                            // 点击后，退出存入/取出视图
                            dismiss()
                            if EnterAmount != 0 {
                                // 假设存入或取出金额逻辑处理完成
                                onComplete() // 通知父视图操作完成
                            }
                        }, label: {
                            Text(LocalizedStringKey(selectedOption))
                                .frame(width: 320,height: 60)
                                .foregroundColor(Color.white)
                                .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                .cornerRadius(10)
                        })
                        Spacer()
                    }
                    .frame(width: width)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationTitle(LocalizedStringKey(selectedOption))
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
}

#Preview {
    DepositAndWithdrawView(isReversed: .constant(true))
        .modelContainer(PiggyBank.preview)
        .environment(\.locale, .init(identifier: "de"))
}
