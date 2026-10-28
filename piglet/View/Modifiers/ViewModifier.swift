//
//  ViewModifier.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/8.
//

import SwiftUI

// ======================
// MARK: Lottie 动画修饰符
// ======================

struct LottieModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .frame(maxHeight: 240)
            .frame(maxWidth: 500)
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

struct DrakGrayTextModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .light ?  AppColor.appGrayColor : Color.white)
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
struct BlueHintTextModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .light ? AppColor.appColor : Color.gray)
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
struct WhiteBg2Modifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .background(colorScheme == .light ? Color.white : Color.black)
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

struct ProBg: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color("defaultBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct Pro2Bg: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
            .background(Color("defaultBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}


struct Pro3Bg: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Color("WhiteAndBlack"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
