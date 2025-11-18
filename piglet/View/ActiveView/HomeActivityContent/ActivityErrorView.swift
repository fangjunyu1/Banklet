//
//  HomeActivitySheetContentErrorView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/18.
//

import SwiftUI

// 错误吐司
struct ActivityErrorView: View {
    @EnvironmentObject var activityVM: ActiveViewModel
    var body: some View {
        if activityVM.isErrorMsg {
            Text("Incorrect input information")
                .font(.footnote)
                .foregroundColor(.white)
                .padding(.vertical,8)
                .padding(.horizontal,16)
                .background(AppColor.appGrayColor.opacity(0.5))
                .cornerRadius(10)
                .offset(y:50)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            activityVM.isErrorMsg = false
                        }
                        print("修改提示为false")
                    }
                }
        }
    }
}
