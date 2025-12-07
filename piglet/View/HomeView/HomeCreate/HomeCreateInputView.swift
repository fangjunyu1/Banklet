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
                            HomeCreateInputRegularAmountView(isFocus: $isFocus)
                                .modifier(HomeCreateInputModifier())
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            FixedDepositFootNoteView()
                        }
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

// 定期存款金额提示
struct FixedDepositFootNoteView: View {
    var body: some View {
        VStack {
            Text("Set a fixed deposit amount for the piggy bank.")
                .font(.footnote)
                .foregroundColor(Color.gray)
                .fixedSize(horizontal: false, vertical: true)
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
