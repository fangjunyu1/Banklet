//
//  Thanks2View.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/10.
//

import SwiftUI

struct Thanks2View: View {
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    // 鸣谢页面
    @AppStorage("isShowThanks") var isShowThanks = true
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                
                ScrollView(showsIndicators: false ) {
                    
                        if !isCompactScreen {
                            Spacer().frame(height: 30)
                        }
                    VStack {
                        // 感谢freepik和lottieFiles
                        Text("Thanks to freepik and lottieFiles")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top,10)
                            .padding(.bottom,10)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        Text("for providing free images or animations.")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                        Spacer().frame(height: 10)
                        SpacedContainer(isCompactScreen: isCompactScreen) {
                            Image("freepik")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isCompactScreen ? nil : width * 0.8)
                                .opacity(colorScheme == .light ? 1 : 0.8)
                            Spacer().frame(width: isLandscape ? 10 : nil, height : isLandscape ? nil : 10)
                            Image("lottiefiles")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isCompactScreen ? nil : width * 0.8)
                                .opacity(colorScheme == .light ? 1 : 0.8)
                        }
                        
                        // 感谢以下用户的赞助
                        Text("Thanks to the following users for their support")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top,5)
                            .padding(.bottom,5)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                        Text("  ") + Text("Thanks to users from China, Thailand, Angola, Finland and Italy for their support.")
                            .font(.footnote)
                        Text("UserSponsorshipDeadline")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                            .padding(.top, 10)
                        
                        Spacer()
                    }
                    .frame(width: width)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .navigationTitle("Thanks")
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
}

#Preview {
    Thanks2View()
//        .environment(\.locale, .init(identifier: "de"))
}
