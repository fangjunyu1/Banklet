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
                .keyboardType(.numbersAndPunctuation)   // 数字 + 符号键盘
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
    var body: some View {
        HStack(spacing: 15) {
            Text("Initial amount")
                .fontWeight(.medium)
            TextField("0", value: $piggyBank.amount, format: .number)
                .focused($isFocus)
                .keyboardType(.numbersAndPunctuation)   // 数字 + 符号键盘
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
            DatePicker("", selection: $piggyBank.expirationDate, displayedComponents: .date)
                .datePickerStyle(DefaultDatePickerStyle())
                .frame(height:0)
                .frame(maxWidth: 120)
                .scaleEffect(0.8)
                .opacity(piggyBank.isExpirationDateEnabled ? 1 : 0)
            Toggle("",isOn: $piggyBank.isExpirationDateEnabled.animation(.bouncy))
                .frame(width: 50,height: 0)
                .background(.red)
        }
    }
}

// 显示图标
struct HomeCreatePreviewImage: View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @EnvironmentObject var step: CreateStepViewModel
    var body: some View {
        Image(systemName: piggyBank.icon)
            .font(.largeTitle)
            .foregroundColor(AppColor.gray)
            .imageScale(.large)
            .opacity(step.tab == .icon ? 1 : 0)
            .frame(height: 45)
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
            case .expirationDate:
                Text("Set an expiration date for the piggy bank.")
            case .complete:
                EmptyView()
            }
            Spacer()
        }
        .font(.footnote)
        .foregroundColor(Color.gray)
    }
}

#Preview {
    NavigationStack {
        HomeCreateView()
    }
}
