//
//  HomeActivitySheetView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/16.
//

import SwiftUI

struct HomeActivitySheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var activityTab: ActivityTab
    @State private var activityInput = ActivityInput()
    @State private var activityStep: ActivityStep = .calculate
    @FocusState private var isFocused: Bool
    var body: some View {
        ZStack(alignment: .bottom) {
            // 活动视图
            VStack(alignment: .center,spacing: 0) {
                // 背景图片区域
                HomeActivitySheetBackground(activityTab: $activityTab,activityInput: $activityInput,activityStep: $activityStep)
                // 内容显示
                HomeActivitySheetContentView(activityTab: $activityTab,activityInput: $activityInput,activityStep: $activityStep,isFocused: $isFocused)
            }
            // 顶部返回按钮和标题
            HomeActivityTitleView(activityTab: $activityTab)
        }
        .ignoresSafeArea()
        .onTapGesture {
            withAnimation {
                isFocused = false
            }
        }
    }
}

struct HomeActivityTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.semibold)
            .fixedSize(horizontal: false, vertical: true)
    }
}
struct HomeActivityFootNoteModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundColor(AppColor.gray)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// 管理活动输入内容
struct ActivityInput {
    // 人生存钱罐
    var age: Int? = nil
    var annualSalary: Int? = nil
    // 生活保障金
    var livingExpenses: Int? = nil
    var guaranteeMonth: Int? = nil
}

enum ActivityStep {
    case calculate
    case create
    case loading
    case complete
}

#Preview {
    NavigationStack {
        VStack{}
            .sheet(isPresented: .constant(true)) {
                HomeActivitySheetView(activityTab: .constant(.LifeSavingsBank))
            }
    }
}
