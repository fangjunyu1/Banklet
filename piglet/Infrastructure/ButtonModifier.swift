//
//  ButtonText.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/30.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .frame(height: 60)
            .frame(minWidth: 200)
            .foregroundColor(Color.white)
            .contentShape(Rectangle())
            .background(colorScheme == .light ? AppColor.appColor : AppColor.appGrayColor)
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
