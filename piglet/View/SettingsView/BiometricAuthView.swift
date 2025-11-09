//
//  BiometricAuthView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/15.
//

import SwiftUI

struct BiometricAuthView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isAuthenticated: Bool
    @Binding var isErrorMessage: Bool
    var onAuthenticate: () -> Void
    // 安全校验页面
    var body: some View {
        Spacer()
            .frame(height: 20)
        VStack(spacing: 10) {
            // 安全校验
            Text("Security Verification")
                .modifier(LargeTitleModifier())
            Text("You have enabled password protection, please click the button below to verify.")
                .modifier(FootNoteModifier())
        }
        Spacer().frame(height: 50)
        LottieView(filename: "lock", isPlaying: true, playCount: 0, isReversed: false)
            .modifier(LottieModifier())
            .scaleEffect(1.2)
        Spacer().frame(height: 150)
        VStack(spacing: 16) {
            Button(action: {
                onAuthenticate() // 调用闭包执行认证
            }, label: {
                HStack {
                    Text("Unlock")
                }
                .modifier(ButtonModifier())
            })
            if isErrorMessage {
                Footnote(text: "Unlock failed, please try again.")
            }
        }
        Spacer()
    }
}

#Preview {
    BiometricAuthView(isAuthenticated: .constant(true),isErrorMessage:.constant(true),onAuthenticate: {})
}
