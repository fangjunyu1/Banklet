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

struct LottieModifier3: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .frame(maxWidth: 160)
    }
}

struct BackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal,20)
            .background {
                Background()
            }
    }
}

struct BackgroundListModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .background {
                Background()
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

struct GrayTextModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .light ?  AppColor.gray : AppColor.appBgGrayColor)
    }
}
struct BlackTextModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .light ?  Color.black : Color.white)
    }
}
struct BlueTextModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .light ? AppColor.appColor : Color.white)
    }
}
struct WhiteTextModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .light ? Color.white : AppColor.appGrayColor)
    }
}
struct WhiteBgModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .background(colorScheme == .light ? Color.white : AppColor.appGrayColor)
    }
}
struct BlueBgModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .background(colorScheme == .light ? AppColor.appColor : AppColor.appGrayColor)
    }
}
struct LightBlueBgModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .background(colorScheme == .light ? AppColor.appColor.opacity(0.1) : Color.white.opacity(0.1))
    }
}
