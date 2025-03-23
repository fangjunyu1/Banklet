//
//  ActivityView.swift
//  piglet
//
//  Created by 方君宇 on 2025/3/23.
//

import SwiftUI

struct ActivityView: View {
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                ZStack {
                    // 背景
                    Color(hex: colorScheme == .light ?  "f0f0f0" : "0E0E0E")
                        .ignoresSafeArea()
                    ScrollView(showsIndicators: false) {
                        Spacer().frame(height: 20)
                        ZStack {
                            Image("life")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                            // 长期、限时标识
                            VStack {
                                HStack {
                                    Spacer()
                                    HStack {
                                        Image(systemName: "hourglass")
                                        Text("long-term")
                                    }
                                    .padding(.vertical,5)
                                    .padding(.horizontal,10)
                                    .foregroundColor(.white)
                                    .background(Color(hex: "FF4B00"))
                                    .cornerRadius(5)
                                }
                                .padding(10)
                                Spacer()
                            }
                            // 底部文字标识
                            VStack {
                                Spacer()
                                HStack {
                                    Text("Life savings jar")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                    Spacer()
                                    Text("lifetime wealth planning")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                }
                                .frame(height: 40)
                                .padding(.horizontal,20)
                                .foregroundColor(.black)
                                .background(Color.white.opacity(0.95))
                                .cornerRadius(5)
                            }
                        }
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                    }
                    .frame(width: width)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .navigationTitle("Activity")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement:.topBarLeading) {
                            Button(action: {
                                dismiss()
                            }, label: {
                                Text("Activity")
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
    ActivityView()
        .environment(AppStorageManager.shared)
}
