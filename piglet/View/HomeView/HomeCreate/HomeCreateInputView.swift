//
//  HomeCreateInputView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/20.
//

import SwiftUI

// 创建存钱罐-输入框
struct HomeCreateInputView: View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @EnvironmentObject var step: CreateStepViewModel
    @FocusState.Binding var isFocus: Bool
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                switch step.tab {
                case .name:
                    VStack {
                        HomeCreateInputNameView(isFocus: $isFocus)
                            .modifier(HomeCreateInputModifier())
                            .transition(.move(edge: .top).combined(with: .opacity))
                        HomeCreateInputFootNoteView()
                    }
                    
                case .targetAmount:
                    VStack {
                        HomeCreateInputTargetAmountView(isFocus: $isFocus)
                            .modifier(HomeCreateInputModifier())
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        HomeCreateInputFootNoteView()
                    }
                    
                case .icon:
                    VStack {
                        HomeCreateInputIconView(isFocus: $isFocus)
                            .modifier(HomeCreateInputModifier())
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        HomeCreateInputFootNoteView()
                    }
                    
                case .amount:
                    VStack {
                        HomeCreateInputAmountView(isFocus: $isFocus)
                            .modifier(HomeCreateInputModifier())
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        HomeCreateInputFootNoteView()
                    }
                    
                case .regular:
                    VStack {
                        HomeCreateInputRegularView(isFocus: $isFocus)
                            .modifier(HomeCreateInputModifier())
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        HomeCreateInputFootNoteView()
                        // 启用定期存款，显示定期存款金额视图
                        if piggyBank.isFixedDeposit {
                            VStack {
                                HomeCreateInputRegularAmountView(isFocus: $isFocus)
                                    .modifier(HomeCreateInputModifier())
                                FixedDepositFootNoteView()
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                        Spacer().frame(height:20)
                        HomeCreateInputRegularComponentsView()
                    }
                    
                case .expirationDate:
                    VStack {
                        HomeCreateInputExpirationDateView(isFocus: $isFocus)
                            .modifier(HomeCreateInputModifier())
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        HomeCreateInputFootNoteView()
                    }
                    
                case .complete:
                    EmptyView()
                }
            }
            .animation(.easeInOut, value: step.tab)
        }
    }
}

struct HomeCreateInputRegularComponentsView: View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @EnvironmentObject var step: CreateStepViewModel
    
    var weekSymbol: [String] {
        let dateFormat = DateFormatter()
        return dateFormat.veryShortStandaloneWeekdaySymbols
    }
    var body: some View {
        // 每日组件
        if piggyBank.isFixedDeposit {
            if piggyBank.fixedDepositType == FixedDepositEnum.day.rawValue {
                
                VStack {
                    DatePicker("",
                               selection: $piggyBank.fixedDepositTime,
                               displayedComponents: .hourAndMinute
                    )
                    .frame(width: 70)
                    Footnote(text: "Automatically save at the selected time each day.")
                        .multilineTextAlignment(.center)
                        .padding(.top,3)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            } else if piggyBank.fixedDepositType == FixedDepositEnum.week.rawValue {
                VStack {
                    HStack(spacing:30) {
                        ForEach(Array(weekSymbol.enumerated()), id:\.offset) { index,item in
                            Button(action:{
                                piggyBank.fixedDepositWeekday = index
                                print("\(index)")
                            }, label: {
                                Text("\(item)")
                                    .foregroundColor(index == piggyBank.fixedDepositWeekday ? Color.blue : .secondary)
                                    .background {
                                        if index == piggyBank.fixedDepositWeekday  {
                                            Circle().fill(Color.blue.opacity(0.15))
                                                .frame(width: 40, height: 40)
                                        }
                                    }
                            })
                        }
                    }
                    Footnote(text: "Automatically saves data weekly at selected days and specific times.")
                        .multilineTextAlignment(.center)
                        .padding(.top,3)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            } else if piggyBank.fixedDepositType == FixedDepositEnum.month.rawValue {
                VStack {
                    Text("月")
                    Footnote(text: "The funds will be automatically deposited each month at the selected weekday and a specific time; if no date is selected for the month (such as the 31st), the system will automatically roll over to the last day of the month.")
                        .multilineTextAlignment(.center)
                        .padding(.top,3)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            } else if piggyBank.fixedDepositType == FixedDepositEnum.year.rawValue {
                VStack {
                    Text("年")
                    Footnote(text: "Automatically saves data annually on selected dates and at specific times.")
                        .multilineTextAlignment(.center)
                        .padding(.top,3)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}


// 定期存款金额提示
struct FixedDepositFootNoteView: View {
    var body: some View {
        HStack {
            Text("Set a fixed deposit amount for the piggy bank.")
                .font(.footnote)
                .foregroundColor(Color.gray)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }
}

struct HomeCreateInputModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColor.gray.opacity(0.3), lineWidth: 10)
                    .background(.white)
                    .cornerRadius(10)
            }
    }
}

#Preview {
    NavigationStack {
        HomeCreateView()
    }
}
