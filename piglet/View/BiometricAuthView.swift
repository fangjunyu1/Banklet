//
//  BiometricAuthView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/15.
//

import SwiftUI

struct BiometricAuthView: View {
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Binding var isAuthenticated: Bool
    @Binding var isErrorMessage: Bool
    var onAuthenticate: () -> Void
    // 安全校验页面
    var body: some View {
        
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
        VStack {
            Spacer().frame(height: 30)
            Text("Security Verification")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(10)
                .multilineTextAlignment(.center)
            Text("You have enabled password protection, please click the button below to verify.")
                .foregroundColor(.gray)
                .font(.footnote)
                .multilineTextAlignment(.center)
                Image("lock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width)
                    .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                Text("Image by freepik")
                    .font(.footnote)
                    .foregroundColor(.gray)
            Spacer().frame(height: 20)
            Button(action: {
                onAuthenticate() // 调用闭包执行认证
            }, label: {
                HStack {
                    Image(systemName: "faceid")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24) // 设置具体大小
                    Text("Unlock")
                }
                .foregroundColor(Color.white)
                .frame(width: 320,height: 60)
                .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                .cornerRadius(10)
            })
            if isErrorMessage {
                
                Text("Unlock failed, please try again.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(10)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .frame(width: width)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
    }
    }
}

#Preview {
    BiometricAuthView(isAuthenticated: .constant(true),isErrorMessage:.constant(true),onAuthenticate: {})
}
