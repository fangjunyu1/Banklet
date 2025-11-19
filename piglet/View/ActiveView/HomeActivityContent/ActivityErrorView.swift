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
                .modifier(ToastTipsModifier())
                .offset(y:50)
        }
    }
}
