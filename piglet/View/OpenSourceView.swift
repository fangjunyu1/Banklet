//
//  OpenSourceView.swift
//  piglet
//
//  Created by 方君宇 on 2025/2/1.
//

import SwiftUI

struct OpenSourceView: View {
    @AppStorage("20240523") var isInAppPurchase = false // 内购完成后，设置为true
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                VStack {
                    if !isCompactScreen {
                        Spacer().frame(height: 30)
                    }
                    // 让代码展现在阳光下
                    Text("Let the code show in the sun")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top,10)
                        .padding(.bottom,10)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text("In order to further demonstrate our protection of user privacy, we decided to host the application code as an open source project on GitHub.")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                    Spacer().frame(height: 20)
                        Image("GitHub")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .opacity(colorScheme == .light ? 1 : 0.8)
                        Spacer().frame(height: 20)
                    
                    if !isCompactScreen {
                        Text("Project address")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                        Text("https://github.com/fangjunyu1/Banklet")
                            .tint(.gray)
                            .font(.footnote)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                        Spacer().frame(height: 30)
                    }
                    Link(destination: URL(string: "https://github.com/fangjunyu1/Banklet")!) {
                        VStack {
                            Text("GitHub")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(width: 200,height: 60)
                                .foregroundColor(.white)
                                .background(colorScheme == .light ?  Color.black : Color(hex:"2C2B2D"))
                                .cornerRadius(10)
                        }
                    }
                    Spacer()
                }
                .frame(width: width)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .navigationTitle("Open source")
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
    OpenSourceView()
}
