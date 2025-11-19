//
//  HomeCreateView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/19.
//

import SwiftUI

struct HomeCreateView: View {
    @State private var piggyBank = PiggyBankData()
    var body: some View {
        VStack {
            // 创建存钱罐 - 标题
            HomeCreateTitleView()
            Spacer()
        }
        .navigationTitle("Create")
        .frame(maxWidth: .infinity)
        .modifier(HomeCreateViewdModifier())
    }
}

// 创建存钱罐 - 名称
struct HomeCreateTitleView: View {
    var body: some View {
        Text("Create a piggy bank")
            .modifier(HomeCreateTitleModifier())
    }
}

// 标题 - 修饰符
struct HomeCreateTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.bold)
    }
}

struct HomeCreateViewdModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal,20)
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
