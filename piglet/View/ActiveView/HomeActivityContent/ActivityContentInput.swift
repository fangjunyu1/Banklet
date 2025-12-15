//
//  ActivityContentInputView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/18.
//

import SwiftUI

struct ActivityContentInputView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var homeActivityVM: HomeActivityViewModel
    @EnvironmentObject var activityVM: ActiveViewModel
    @FocusState.Binding var isFocused: Bool
    var body: some View {
        // 人生存钱罐
        if homeActivityVM.tab == .LifePiggy {
            let viewColor:Color = colorScheme == .light ? Color(hex:"695CFE") : Color(hex:"695CFE").opacity(0.8)
            // MARK: - 人生存钱罐
            switch activityVM.step {
            case .calculate, .calculating:
                HStack {
                    // 年龄
                    PrivateInputBindingView(text:"Age",image: .sficon("person.fill"), color: viewColor, mode: .input(placeholder: "_ _", textField: $activityVM.input.age, textWidth: 40, isFocused: $isFocused))
                    // 年薪
                    PrivateInputBindingView(text:"Salary",image: .sficon("dollarsign.circle.fill"),color: Color(hex: "695CFE"), mode: .input(placeholder: "_ _ _ _ _", textField: $activityVM.input.annualSalary, textWidth: 100, isFocused: $isFocused))
                }
            default:
                // 目标金额
                PrivateInputBindingView(text:"Amount",image: .img("whiteBanklet"), color: AppColor.appColor, mode: .display(value: activityVM.input.LifePiggy ?? 0))
            }
        } else if homeActivityVM.tab == .LifeFund {
            let viewColor:Color = colorScheme == .light ? Color(hex:"FF9A00") : Color(hex:"FF9A00").opacity(0.8)
            // MARK: - 生活保障金
            switch activityVM.step {
            case .calculate, .calculating:
                // 生活开销
                PrivateInputBindingView(text:"Expense",image: .sficon("dollarsign.circle.fill"),color: viewColor, mode: .input(placeholder: "_ _ _", textField: $activityVM.input.livingExpenses, textWidth: 100, isFocused: $isFocused))
            default:
                // 目标金额
                PrivateInputBindingView(text:"Amount",image: .img("whiteBanklet"), color: AppColor.appColor, mode: .display(value: activityVM.input.lifeFund ?? 0))
            }
        }
    }
}


private struct PrivateInputBindingView: View {
    
    var text: String
    var image: inputImage
    var color: Color
    var mode: Mode
    var body: some View {
        HStack(spacing: 10) {
            VStack(spacing: 5) {
                Text(LocalizedStringKey(text))
                    .font(.caption2)
                    .fixedSize(horizontal: true, vertical: false)
                image.image
            }
            switch mode {
            case .input(let placeholder, let textField, let textWidth, let isFocused):
                TextField(placeholder, value: textField, format: .number)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)   // 数字 + 小数点键盘
                    .focused(isFocused)
                    .onChange(of: textField.wrappedValue) {
                        // 振动
                        HapticManager.shared.selectionChanged()
                    }
                    .fixedSize(horizontal: true, vertical: false)
                
            case .display(let value):
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)   // 数字 + 小数点键盘
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        .padding(.vertical,10)
        .padding(.horizontal,16)
        .background(color)
        .cornerRadius(10)
        .font(.footnote)
        .foregroundColor(.white)
    }
    
    enum Mode {
        case input(placeholder: String, textField: Binding<Int?>, textWidth: CGFloat, isFocused: FocusState<Bool>.Binding)
        case display(value: Int)
    }
    
    enum inputImage {
        case sficon(String)
        case img(String)
        
        @ViewBuilder
        var image: some View {
            switch self {
            case .sficon(let string):
                Image(systemName: string)
                    .imageScale(.large)
            case .img(let string):
                Image(string)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
            }
        }
    }
}
