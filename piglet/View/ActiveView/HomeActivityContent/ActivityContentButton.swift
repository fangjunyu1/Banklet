//
//  ActivityContentButtonView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/18.
//

import SwiftUI

struct ActivityContentButtonView: View {
    @EnvironmentObject var activityVM: ActiveViewModel
    @FocusState.Binding var isFocused: Bool
    var body: some View {
        VStack(spacing: 10) {
            // 确定按钮
            ContentDisplayButtonView(isFocused: $isFocused)
            // 取消按钮
            ContentCancelButtonView()
        }
    }
}

// 取消按钮
private struct ContentCancelButtonView: View {
    @EnvironmentObject var homeActivityVM: HomeActivityViewModel
    @EnvironmentObject var activityVM: ActiveViewModel
    var body: some View {
        Button(action: {
            activityVM.cancelButton(for:homeActivityVM.tab)
        }, label: {
            Text("Cancel")
                .foregroundColor(AppColor.appGrayColor)
                .font(.footnote)
        })
        .opacity(activityVM.step == .create ? 1 : 0)
        .disabled(activityVM.step != .create)
    }
}

private struct ContentDisplayButtonView: View {
    @EnvironmentObject var homeActivityVM: HomeActivityViewModel
    @EnvironmentObject var activityVM: ActiveViewModel
    @FocusState.Binding var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        // 显示按钮
        Button(action: {
            // 计算阶段 - 显示计算
            if activityVM.step == .calculate {
                isFocused = false
                activityVM.calculateButton(for: homeActivityVM.tab)
            } else if activityVM.step == .create {
                // 创建阶段 - 创建存钱罐
                activityVM.createButton(for: homeActivityVM.tab)
            } else if activityVM.step == .complete {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    activityVM.completeButton()
                }
            }
        }, label: {
            Group {
                switch activityVM.step {
                case .calculate:
                    Text("Calculate")
                case .create:
                    Text("Create")
                case .complete:
                    Text("Completed")
                default:
                    ProgressView("")
                        .tint(.white)
                        .padding(.top,10)
                }
            }
            .modifier(ButtonModifier())
        })
        .disabled(activityVM.step == .calculating || activityVM.step == .creating)
    }
}
