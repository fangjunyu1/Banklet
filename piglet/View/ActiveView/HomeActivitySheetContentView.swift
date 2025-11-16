//
//  HomeActivitySheetContentView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/16.
//

import SwiftUI

struct HomeActivitySheetContentView: View {
    @Binding var activityTab: ActivityTab
    @Binding var activityInput: ActivityInput
    @Binding var activityStep: ActivityStep
    var body: some View {
        VStack(spacing: 30) {
            // 内容视图的标题
            HomeActivitySheetContentTitleView(activityTab: $activityTab,activityStep: $activityStep)
            // 内容视图的输入视图
            HomeActivitySheetContentInputView(activityTab: $activityTab,activityInput: $activityInput,activityStep: $activityStep)
            // 确认按钮
            HomeActivitySheetContentButtonView(activityTab: $activityTab,activityStep: $activityStep)
            Spacer().frame(maxWidth: 20)
        }
        .modifier(HomeActivitySheetContentModifier())
    }
}

private struct HomeActivitySheetContentButtonView: View {
    @Binding var activityTab: ActivityTab
    @Binding var activityStep: ActivityStep
    var body: some View {
        Button(action: {
            // 下一步
            
        }, label: {
            switch activityStep {
            case .calculate:
                Text("Calculate")
            case .create:
                Text("Create")
            case .loading:
                ProgressView("")
            case .complete:
                Text("Completed")
            }
        })
        .modifier(ButtonModifier())
    }
}
private struct HomeActivitySheetContentInputView: View {
    @Binding var activityTab: ActivityTab
    @Binding var activityInput: ActivityInput
    @Binding var activityStep: ActivityStep
    var body: some View {
        if activityTab == .LifeSavingsBank {
            HStack {
                // 年龄
                PrivateInputBindingView(text:"Age",image: "person.fill", color: "695CFE", placeholder: "_ _",textField: $activityInput.age,textWidth: 40)
                // 年薪
                PrivateInputBindingView(text:"Annual salary",image: "dollarsign.circle.fill",color: "695CFE",placeholder: "_ _ _ _ _",textField: $activityInput.annualSalary,textWidth: 100)
            }
        } else if activityTab == .EmergencyFund {
            // 生活开销
            PrivateInputBindingView(text:"Living Expenses",image: "dollarsign.circle.fill",color: "FF9A00",placeholder: "_ _ _",textField: $activityInput.livingExpenses,textWidth: 100)
        }
    }
}

private struct PrivateInputBindingView: View {
    var text: String
    var image: String
    var color: String
    var placeholder: String
    @Binding var textField: String
    var textWidth: CGFloat
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 5) {
                Text(LocalizedStringKey(text))
                    .font(.footnote)
                Image(systemName: image)
                    .imageScale(.large)
            }
            TextField(placeholder, text: $textField)
                .font(.title2)
                .fontWeight(.bold)
                .frame(width: textWidth)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical,10)
        .padding(.horizontal,16)
        .background(Color(hex: color))
        .cornerRadius(10)
        .font(.footnote)
        .foregroundColor(.white)
    }
}
private struct HomeActivitySheetContentTitleView: View {
    @Binding var activityTab: ActivityTab
    @Binding var activityStep: ActivityStep
    var body: some View {
        VStack(spacing: 10) {
            if activityTab == .LifeSavingsBank {
                // 人生存钱罐
                // 标题和副标题
                Text("Calculate your lifetime wealth")
                    .modifier(HomeActivityTitleModifier())
                Text("Based on your current age and salary, it automatically calculates your career starting point, retirement age, and salary growth rate, and calculates your lifetime wealth.")
                    .modifier(HomeActivityFootNoteModifier())
            } else if activityTab == .EmergencyFund {
                // 生活保障金或紧急备用金
                // 标题和副标题
                Text("Addressing future risks")
                    .modifier(HomeActivityTitleModifier())
                Text("It is recommended to prepare 3-6 months' worth of living expenses to cope with temporary unemployment, medical expenses, or other emergencies.")
                    .modifier(HomeActivityFootNoteModifier())
            }
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    NavigationStack {
        ZStack {
            HomeActivitySheetPreviewView()
        }
    }
}

private struct HomeActivitySheetContentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.top,30)
            .padding(.bottom,30)
            .padding(.horizontal,20)
            .frame(idealHeight: 300)
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(20)
    }
}
