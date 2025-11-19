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
    var body: some View {
        VStack {
            // 创建存钱罐 - 标题
            HomeCreateTitleView()
            // 图标
            HomeCreatePreviewImage()
            Spacer()
        }
        .navigationTitle("Create")
        .frame(maxWidth: .infinity)
        .modifier(HomeCreateViewdModifier())
        .environment(piggyBank)
        .environment(step)
    }
}

// 创建存钱罐 - 名称
struct HomeCreateTitleView: View {
    var body: some View {
        VStack(alignment: .leading,spacing: 10) {
            Text("Create a piggy bank")
                .font(.title2)
                .fontWeight(.medium)
            Text("Please fill in your savings plan information completely, and set the name, goal and starting amount step by step.")
                .font(.footnote)
                .foregroundColor(AppColor.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct HomeCreatePreviewImage: View {
    @EnvironmentObject var piggyBank: PiggyBankData
    @EnvironmentObject var step: CreateStepViewModel
    var body: some View {
        Image(systemName: piggyBank.icon)
            .opacity(1)
    }
}

struct HomeCreateViewdModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal,20)
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
