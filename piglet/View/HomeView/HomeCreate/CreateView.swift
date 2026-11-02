//
//  CreateView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/19.
//

import SwiftUI

struct CreateView: View {
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
        .frame(maxWidth: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal,40)
        .padding(.top,30)
        .background {
            Background()
                .onTapGesture {
                    isFocus = false
                }
        }
        .environment(piggyBank)
        .environment(step)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 3) {
                    Text(verbatim: "\(step.tab.index)")
                        .animation(.default, value: step.tab)
                    Text(verbatim: "/")
                        .foregroundColor(AppColor.gray)
                    Text(verbatim: "\(step.tab.count)")
                        .foregroundColor(AppColor.gray)
                }
            }
        }
        .onDisappear {
            print("退出视图时，重置信息状态")
            piggyBank = PiggyBankData()
            step.tab = .name
        }
    }
}

// MARK: 创建存钱罐 - 名称
struct HomeCreateTitleView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading,spacing: 10) {
                Text("Create Piggy")
                    .font(.title2)
                    .fontWeight(.medium)
                Text("Please fill in your savings plan information completely, and set the name, goal and starting amount step by step.")
                    .font(.footnote)
                    .foregroundColor(AppColor.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
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
                // 振动
                HapticManager.shared.selectionChanged()
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

struct CreateViewdModifier: ViewModifier {
    @FocusState.Binding var isFocus: Bool?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal,40)
            .padding(.top,30)
            .background {
                AppColor.appBgGrayColor
                    .ignoresSafeArea()
                    .onTapGesture {
                        isFocus = false
                    }
            }
    }
}

#Preview {
    NavigationStack {
        CreateView()
    }
}
