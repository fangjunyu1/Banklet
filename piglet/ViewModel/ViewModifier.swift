//
//  ViewModifier.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/8.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
    }
}

struct FootNoteModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption2)
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
    }
}

struct LottieModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .frame(maxHeight: 200)
            .frame(maxWidth: 500)
    }
}

struct BackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal,20)
            .background {
                AppColor.appBgGrayColor
                    .ignoresSafeArea()
            }
    }
}
