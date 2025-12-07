//
//  HomeCreateComponents.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/20.
//

import SwiftUI

// 应用名称界面
struct HomeCreateInputNameView: View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @FocusState.Binding var isFocus: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Text("Name")
                .fontWeight(.medium)
            TextField("Set the name of the piggy bank", text: $piggyBank.name)
                .focused($isFocus)
                .onChange(of: piggyBank.name) {
                    if piggyBank.name.count > 30 {
                        piggyBank.name = String(piggyBank.name.prefix(30))
                    }
                }
        }
    }
}

// 应用目标金额界面
struct HomeCreateInputTargetAmountView: View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @FocusState.Binding var isFocus: Bool
    var body: some View {
        HStack(spacing: 15) {
            Text("Amount")
                .fontWeight(.medium)
            TextField("0", value: $piggyBank.targetAmount, format: .number)
                .focused($isFocus)
                .keyboardType(.decimalPad)   // 数字 + 小数点键盘
        }
    }
}

// 应用图标界面
struct HomeCreateInputIconView: View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @FocusState.Binding var isFocus: Bool
    let columns = Array(repeating: GridItem(.fixed(30)), count: 3)
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: columns) {
                ForEach(IconList.list, id: \.self) { item in
                    Button(action: {
                        piggyBank.icon = item
                    }, label: {
                        Image(systemName: item)
                            .foregroundColor(AppColor.gray)
                            .imageScale(.large)
                            .fontWeight(.bold)
                    })
                }
            }
        }
    }
}

// 初始金额界面
struct HomeCreateInputAmountView: View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @FocusState.Binding var isFocus: Bool
    @State private var isNegative = false
    var body: some View {
        HStack(spacing: 15) {
            Text("Initial amount")
                .fontWeight(.medium)
            HStack(spacing:2) {
                TextField("0", value: Binding<Double?>(get: {
                    piggyBank.amount
                }, set: {
                    if let amount = $0 {
                        piggyBank.amount = isNegative ? -abs(amount) : abs(amount)
                    } else {
                        piggyBank.amount = $0
                    }
                }), format: .number)
                .focused($isFocus)
                .keyboardType(.decimalPad)   // 数字 + 小数点键盘
                .foregroundColor(isNegative ? .red : .primary)
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    isNegativeButton()
                }, label: {
                    Image(systemName: isNegative ? "minus" : "plus")
                        .foregroundColor(isNegative ? Color.red : AppColor.gray)
                })
            }
        }
    }
    
    private func isNegativeButton() {
        isNegative.toggle()
        if let amount = piggyBank.amount {
            if isNegative {
                piggyBank.amount = -abs(amount)
            } else {
                piggyBank.amount = abs(amount)
            }
        }
    }
}

// 定额存款界面
struct HomeCreateInputRegularView:View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @FocusState.Binding var isFocus: Bool
    var body: some View {
        HStack(spacing: 10) {
            Text("Fixed deposit")
                .fontWeight(.medium)
            Spacer()
            Toggle("",isOn: $piggyBank.isFixedDeposit.animation(.bouncy))
                .frame(width: 50,height: 0)
                .background(.red)
        }
    }
}

// 定额存款金额界面
struct HomeCreateInputRegularAmountView:View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @FocusState.Binding var isFocus: Bool
    var body: some View {
        HStack(spacing: 10) {
            Text("Fixed deposit")
                .fontWeight(.medium)
            Spacer()
            TextField("0", value: $piggyBank.fixedDepositAmount, format: .number)
            .focused($isFocus)
            .keyboardType(.decimalPad)   // 数字 + 小数点键盘
        }
    }
}

// 应用截止日期界面
struct HomeCreateInputExpirationDateView: View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @FocusState.Binding var isFocus: Bool
    var body: some View {
        HStack(spacing: 10) {
            Text("Expiration date")
                .fontWeight(.medium)
            Spacer()
            Toggle("",isOn: $piggyBank.isExpirationDateEnabled.animation(.bouncy))
                .frame(width: 50,height: 0)
                .background(.red)
        }
    }
}

struct HomeCreateDateView: View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @EnvironmentObject var step: CreateStepViewModel
    @State private var isShowSheet = false
    var body: some View {
        VStack(alignment: .center) {
            Button(action: {
                isShowSheet.toggle()
            }, label: {
                Text(piggyBank.expirationDate.formatted(
                    .dateTime
                        .year()
                        .month(.wide)
                        .day()
                )) // 输出类似 "2025年1月14日"
                .padding(10)
                .tint(.primary)
                .background(AppColor.gray.opacity(0.3))
                .cornerRadius(10)
            })
            .sheet(isPresented: $isShowSheet) {
                VStack {
                    DatePicker("", selection: $piggyBank.expirationDate, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .opacity(piggyBank.isExpirationDateEnabled ? 1 : 0)
                        .presentationDetents([.height(300)])
                        .padding(.trailing, 20)
                    Button(action: {
                        isShowSheet.toggle()
                    }, label: {
                        Text("Completed")
                            .modifier(ButtonModifier())
                    })
                }
            }
            .opacity(step.tab.isDate && piggyBank.isExpirationDateEnabled ? 1 : 0)
        }
    }
}

// 占位视图 - 显示日期或者图标
struct HomeCreatePreviewImage: View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @EnvironmentObject var step: CreateStepViewModel
    var body: some View {
        ZStack {
            // 截止日期
            HomeCreateDateView()
            // App图标
            Image(systemName: piggyBank.icon)
                .font(.largeTitle)
                .foregroundColor(AppColor.gray)
                .imageScale(.large)
                .opacity(step.tab == .icon ? 1 : 0)
                .frame(height: 45)
            // 定期存款的选项
            HomeCreatePickerFixedDepositView()
        }
    }
}

struct HomeCreatePickerFixedDepositView: View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @EnvironmentObject var step: CreateStepViewModel
    var body: some View {
        Picker("",selection: $piggyBank.fixedDepositType) {
            ForEach(FixedDepositEnum.allCases) { option in
                Text(LocalizedStringKey(option.rawValue)).tag(option.rawValue) // 设置标识符
                    .onAppear {
                        print("value:\(option.rawValue),type:\(type(of:option.rawValue))")
                    }
            }
        }
        .labelsHidden()
        .pickerStyle(.segmented)
        .opacity(step.tab.isRegular && piggyBank.isFixedDeposit ? 1 : 0)
        .padding(5)
    }
}
// 底部显示的视图
struct HomeCreateInputFootNoteView: View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @EnvironmentObject var step: CreateStepViewModel
    
    var remainCharacters: Int {
        30 - piggyBank.name.count
    }
    
    var body: some View {
        HStack {
            switch step.tab {
            case .name:
                HStack(spacing: 5) {
                    Text("Remaining")
                    Text("\(remainCharacters)")
                    Text("Characters.")
                }
            case .targetAmount:
                Text("Set a target amount for your piggy bank.")
            case .icon:
                Text("Select the piggy bank icon.")
            case .amount:
                Text("Set the initial amount for the piggy bank.")
            case .regular:
                Text("Set up a fixed deposit for your piggy bank.")
            case .expirationDate:
                Text("Set an expiration date for the piggy bank.")
            case .complete:
                EmptyView()
            }
            Spacer()
        }
        .font(.footnote)
        .foregroundColor(Color.gray)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    NavigationStack {
        HomeCreateView()
    }
}
