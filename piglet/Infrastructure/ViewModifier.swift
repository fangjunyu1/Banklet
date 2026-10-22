//
//  ViewModifier.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/8.
//

import SwiftUI

// MARK: 文字样式

struct LargeTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
}

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
    }
}

// 灰色注释文字
struct FootNoteModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
    }
}

// ======================
// MARK: 按钮修饰符
// ======================

struct ButtonModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    var disableStats: Bool = false
    
    func body(content: Content) -> some View {
        content
            .frame(height: 60)
            .frame(minWidth: 200)
            .foregroundColor(Color.white)
            .contentShape(Rectangle())
            .background(disableStats ? Color.gray : colorScheme == .light ? AppColor.appColor : AppColor.appGrayColor)
            .cornerRadius(10)
    }
}

struct ButtonModifier2: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .frame(height: 60)
            .frame(minWidth: 200)
            .foregroundColor(Color.white)
            .contentShape(Rectangle())
            .background(colorScheme == .light ? AppColor.appColor : AppColor.appGrayColor)
            .cornerRadius(20)
    }
}

struct ButtonModifier3: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(height: 60)
            .padding(.horizontal,20)
            .foregroundColor(Color.white)
            .contentShape(Rectangle())
            .background(colorScheme == .light ? AppColor.appColor : AppColor.appGrayColor)
            .cornerRadius(20)
    }
}


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
