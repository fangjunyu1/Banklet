//
//  ProBg.swift
//  piglet
//
//  Created by 方君宇 on 2026/6/4.
//

import SwiftUI

struct ProBg: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color("AppColor"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct Pro2Bg: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
            .background(Color("AppColor"))
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

