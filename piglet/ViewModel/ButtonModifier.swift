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
            .background(colorScheme == .light ? AppColor.appColor : AppColor.appGrayColor)
            .cornerRadius(10)
    }
}
