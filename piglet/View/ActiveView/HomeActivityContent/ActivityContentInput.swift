//
//  ActivityContentInputView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/18.
//

import SwiftUI

struct ActivityContentInputView: View {
    @EnvironmentObject var activityVM: ActiveViewModel
    @FocusState.Binding var isFocused: Bool
    var body: some View {
        if activityVM.tab == .LifeSavingsBank {
            HStack {
                // 年龄
                PrivateInputBindingView(text:"Age",image: "person.fill", color: "695CFE", placeholder: "_ _",textField: $activityVM.input.age,textWidth: 40,isFocused: $isFocused)
                // 年薪
                PrivateInputBindingView(text:"Annual salary",image: "dollarsign.circle.fill",color: "695CFE",placeholder: "_ _ _ _ _",textField: $activityVM.input.annualSalary,textWidth: 100,isFocused: $isFocused)
            }
        } else if activityVM.tab == .EmergencyFund {
            // 生活开销
            PrivateInputBindingView(text:"Living Expenses",image: "dollarsign.circle.fill",color: "FF9A00",placeholder: "_ _ _",textField: $activityVM.input.livingExpenses,textWidth: 100,isFocused: $isFocused)
        }
    }
}


private struct PrivateInputBindingView: View {
    var text: String
    var image: String
    var color: String
    var placeholder: String
    @Binding var textField: Int?
    var textWidth: CGFloat
    @FocusState.Binding var isFocused: Bool
    var body: some View {
        HStack(spacing: 10) {
            VStack(spacing: 5) {
                Text(LocalizedStringKey(text))
                    .font(.caption2)
                    .fixedSize(horizontal: true, vertical: false)
                Image(systemName: image)
                    .imageScale(.large)
            }
            TextField(placeholder, value: $textField, format: .number)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .onChange(of: textField) {
                    // 振动
                    HapticManager.shared.selectionChanged()
                }
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.vertical,10)
        .padding(.horizontal,16)
        .background(Color(hex: color))
        .cornerRadius(10)
        .font(.footnote)
        .foregroundColor(.white)
    }
}
