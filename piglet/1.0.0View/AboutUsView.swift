//
//  AboutUsView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/10.
//

import SwiftUI
import Lottie

struct AboutUsView: View {
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                ScrollView(showsIndicators: false) {
                    // 关于我们动画
                    LottieView(filename: "AboutUs",isPlaying: true, playCount: 0, isReversed: false)
                        .scaleEffect(1.5)
                        .frame(width: 200,height: 200)
                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                    // 关于我们的文字描述
                    Group {
                        Text("An independent developer from China.")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        VStack(alignment:.leading, spacing: 0) {
                            ForEach(0..<7) { item in
                                let thanksName = "thanks\(item)"
                                Text("\t") + Text(LocalizedStringKey(thanksName))
                            }
                        }
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.top,5)
                        .padding(.bottom,20)
                    }
                    Spacer()
                }
                .frame(width: width)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .navigationTitle("About Us")
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
    AboutUsView()
}
