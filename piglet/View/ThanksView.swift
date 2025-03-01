//
//  ThanksView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/10.
//

import SwiftUI

struct ThanksView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    // isShowInAppPurchase：true表示显示，false表示隐藏
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                VStack {
                    Spacer().frame(height: 20)
                    Text("Thank you for your support of our app.")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(10)
                        .multilineTextAlignment(.center)
                    Text("We will continue to work hard to develop better works for more people to use for free.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    // 感谢图片
                    Group {
                        Image("thanks")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.8)
                        Text("Image by freepik")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .offset(x:width * 0.15)
                    }
                    Spacer()
                }
                .frame(width: width)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .navigationTitle("Thanks for your support")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement:.topBarLeading) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Completed")
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    ThanksView()
}
