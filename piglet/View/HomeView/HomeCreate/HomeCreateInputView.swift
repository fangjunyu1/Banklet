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
                    HomeCreateInputNameView(isFocus: $isFocus)
                        .transition(.move(edge: .top).combined(with: .opacity))

                case .targetAmount:
                    HomeCreateInputTargetAmountView(isFocus: $isFocus)
                        .transition(.move(edge: .bottom).combined(with: .opacity))

                case .icon:
                    HomeCreateInputIconView(isFocus: $isFocus)
                        .transition(.move(edge: .bottom).combined(with: .opacity))

                case .amount:
                    HomeCreateInputAmountView(isFocus: $isFocus)
                        .transition(.move(edge: .bottom).combined(with: .opacity))

                case .regular:
                    HomeCreateInputRegularView(isFocus: $isFocus)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                case .expirationDate:
                    HomeCreateInputExpirationDateView(isFocus: $isFocus)
                        .transition(.move(edge: .bottom).combined(with: .opacity))

                case .complete:
                    EmptyView()
                }
            }
            .animation(.easeInOut, value: step.tab)
            .padding(20)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColor.gray.opacity(0.3), lineWidth: 10)
                    .background(.white)
                    .cornerRadius(10)
            }
            HomeCreateInputFootNoteView()
        }
    }
}

#Preview {
    NavigationStack {
        HomeCreateView()
    }
}
