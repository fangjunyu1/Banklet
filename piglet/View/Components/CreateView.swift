//
//  CreateView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/19.
//

import SwiftUI

struct CreateView: View {
    // 临时创建存钱罐保存的数据
    @State private var piggyBank = PiggyBankData()
    // 创建步骤
    @State private var isCreated = false
    // 焦点
    @FocusState private var isFocus: Bool // 使用枚举管理焦点
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                // 创建存钱罐 - 标题
                CreateTitleView(isCreated: isCreated)
                
                // 存钱罐图标
                CreateIconView(isCreated: isCreated)
                
//                if step.tab.isLast {
//                    HomeCreateLottieView()
//                } else {
//                    // 图标
//                    HomeCreatePreviewImage(piggyBank: $piggyBank)
//                    // 输入框
//                    HomeCreateInputView(piggyBank: $piggyBank, isFocus: $isFocus)
//                }
//                Spacer().frame(height:20)
//                // 按钮
//                HomeCreateButtonView( piggyBank: $piggyBank)
                Spacer()
            }
            .padding(.horizontal,40)
            .padding(.top,30)
        }
        .navigationTitle("Create")
        .navigationBarTitleDisplayMode(.inline)
        .background {
            Background()
                .onTapGesture {
                    isFocus = false
                }
        }
        .onDisappear {
            print("退出视图时，重置信息状态")
            piggyBank = PiggyBankData()
            isCreated = false
        }
    }
}

// MARK: 创建存钱罐 - 标题和副标题
struct CreateTitleView: View {
    var isCreated: Bool
    var body: some View {
        HStack {
            VStack(alignment: .leading,spacing: 10) {
                Text(isCreated ? "Creation completed" : "Create Piggy")
                    .font(.title2)
                    .fontWeight(.medium)
                Text(isCreated ? "Your piggy bank has been created. You can now start adding savings and tracking your goal progress." : "Please fill in your savings plan information completely, and set the name, goal and starting amount step by step.")
                    .font(.footnote)
                    .foregroundColor(AppColor.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: 存钱罐图标视图
struct CreateIconView: View {
    var isCreated: Bool
    var body: some View {
        Text("")
    }
}

#Preview {
    NavigationStack {
        CreateView()
    }
}
