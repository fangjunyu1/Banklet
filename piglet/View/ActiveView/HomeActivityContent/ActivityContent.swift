//
//  HomeActivitySheetContentView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/16.
//

import SwiftUI

struct ActivityContentView: View {
    @EnvironmentObject var activityVM: ActiveViewModel
    @FocusState.Binding var isFocused: Bool
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                // 内容视图的标题
                ActivityContentTitleView()
                // 内容视图的输入视图
                ActivityContentInputView(isFocused: $isFocused)
                // 确认按钮
                ActivityContentButtonView()
            }
            .modifier(HomeActivitySheetContentModifier())
            .modifier(KeyboardAdaptive())
            // 错误吐司信息
            ActivityErrorView()
        }
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


private struct HomeActivitySheetContentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical,30)
            .padding(.horizontal,20)
            .frame(idealHeight: 300)
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(20)
    }
}
