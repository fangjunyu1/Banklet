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

struct LargeTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
}

struct FootNoteModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
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

struct LottieModifier2: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxHeight: 180)
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


struct SettingVStackRowModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .background(colorScheme == .dark ? AppColor.appGrayColor : .white)
            .cornerRadius(10)
    }
}
