//
//  PrivacyPage.swift
//  piglet
//
//  Created by 方君宇 on 2024/12/30.
//

import SwiftUI

struct PrivacyPage: View {
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(AppStorageManager.self) var appStorage
    @Environment(\.colorScheme) var colorScheme
    @Binding var pageSteps: Int
    
    let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                let height = geometry.size.height
                VStack {
                    // 顶部空白为 height * 0.05
                    Spacer().frame(height: height * 0.05)
                    Image("privacypage")
                        .resizable()
                        .scaledToFit()
                        .frame(width:  width * 0.8)
                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                    Text("Image by freepik")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Spacer().frame(height: height * 0.05)
                    // 隐私在您掌控之中
                    Text("Privacy is in your control")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    Link("Privacy Policy (Chinese)", destination: URL(string: "https://fangjunyu.com/2024/05/23/%e5%ad%98%e9%92%b1%e7%8c%aa%e7%8c%aa-%e9%9a%90%e7%a7%81%e6%94%bf%e7%ad%96/")!)
                        .font(.footnote)
                        .foregroundColor(colorScheme == .light ? Color(hex:"FF4B00") : .gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer().frame(height: height * 0.05)
                    Button(action: {
                        pageSteps = 3
                    }, label: {
                        Text("Continue")
                            .frame(width: 320,height: 60)
                            .foregroundColor(Color.white)
                            .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                            .cornerRadius(10)
                    })
                    Spacer().frame(height: height * 0.05)
                }
                .frame(width: width)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    PrivacyPage(pageSteps: .constant(2))
        .environment(\.locale, .init(identifier: "de"))   // 设置语言为阿拉伯语
        .modelContainer(PiggyBank.preview)
                .environment(AppStorageManager.shared)
                .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
                .environmentObject(IAPManager.shared)
                .environmentObject(SoundManager.shared)
}
