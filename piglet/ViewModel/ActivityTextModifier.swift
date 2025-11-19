//
//  ActivityTextModifier.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/18.
//

import SwiftUI

struct ActivityTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.vertical,10)
            .padding(.horizontal,20)
            .background(.black.opacity(0.3))
            .cornerRadius(10)
    }
}
