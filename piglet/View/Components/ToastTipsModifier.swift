//
//  ToastTipsModifier.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/19.
//

import SwiftUI

struct ToastTipsModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundColor(.white)
            .padding(.vertical,8)
            .padding(.horizontal,16)
            .background(AppColor.appGrayColor.opacity(0.5))
            .cornerRadius(10)
    }
}
