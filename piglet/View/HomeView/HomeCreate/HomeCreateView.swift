//
//  HomeCreateView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/19.
//

import SwiftUI

struct HomeCreateView: View {
    @State private var piggyBank = PiggyBankData()
    @State private var step = CreateStepViewModel()
    @FocusState private var isFocus: Bool // 使用枚举管理焦点
    var body: some View {
        VStack(spacing: 10) {
            // 创建存钱罐 - 标题
            HomeCreateTitleView()
            
            if step.tab.isLast {
                HomeCreateLottieView()
            } else {
                // 图标
                HomeCreatePreviewImage()
                // 输入框
                HomeCreateInputView(isFocus: $isFocus)
            }
            Spacer().frame(height:20)
            // 按钮
            HomeCreateButtonView()
            Spacer()
        }
        .navigationTitle("Create")
        .modifier(HomeCreateViewdModifier())
        .environment(piggyBank)
        .environment(step)
        .onTapGesture {
            isFocus = false
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 3) {
                    Text("\(step.tab.index)")
                        .animation(.default, value: step.tab)
                    Text("/")
                        .foregroundColor(AppColor.gray)
                    Text("\(step.tab.count)")
                        .foregroundColor(AppColor.gray)
                }
            }
        }
    }
}

struct HomeCreateLottieView: View {
    var body: some View {
        LottieView(filename: "CreateComplete", isPlaying: true, playCount: 1, isReversed: false)
            .scaledToFit()
            .frame(maxWidth: 130)
    }
}

struct HomeCreateButtonView: View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @EnvironmentObject var step: CreateStepViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 15) {
            Button(action: {
                // 如果是最后一个 tab
                if step.tab.isLast {
                    step.createPiggyBank(for: piggyBank)
                    dismiss()
                } else {
                    step.step()
                }
            }, label: {
                Text(step.tab == .complete ? "Completed" :  "Continue")
                    .modifier(ButtonModifier())
            })
            Button(action: {
                step.previousStep()
            }, label: {
                Footnote(text: "Previous")
            })
            .opacity(step.tab == .name ? 0 : 1)
        }
    }
}

struct HomeCreateViewdModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal,40)
            .padding(.top,30)
            .background {
                AppColor.appBgGrayColor
                    .ignoresSafeArea()
            }
    }
}

#Preview {
    NavigationStack {
        HomeCreateView()
    }
}
