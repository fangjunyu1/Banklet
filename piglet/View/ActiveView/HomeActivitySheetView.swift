//
//  HomeActivitySheetView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/16.
//

import SwiftUI

struct HomeActivitySheetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var activityVM: ActiveViewModel
    @FocusState private var isFocused: Bool
    var body: some View {
        ZStack(alignment: .bottom) {
            // 活动视图
            VStack(alignment: .center,spacing: 0) {
                // 背景图片区域
                ActivitySheetBgView()
                // 内容显示
                ActivityContentView(isFocused: $isFocused)
            }
            // 顶部返回按钮和标题
            HomeActivityTitleView()
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

#Preview {
    NavigationStack {
        VStack{}
            .sheet(isPresented: .constant(true)) {
                HomeActivitySheetView()
                    .environment(ActiveViewModel())
            }
    }
}
