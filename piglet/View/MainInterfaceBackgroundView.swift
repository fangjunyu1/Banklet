//
//  MainInterfaceBackgroundView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/15.
//

import SwiftUI

struct MainInterfaceBackgroundView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("20240523") var isInAppPurchase = false // 内购完成后，设置为true
    @AppStorage("BackgroundImage") var BackgroundImage = "" // 背景照片
    let columns = [
        GridItem(.adaptive(minimum: 130, maximum: 200)), // 自动根据屏幕宽度生成尽可能多的单元格，宽度最小为 80 点
        GridItem(.adaptive(minimum: 130, maximum: 200))
    ]
    
    let columnsIpad = [
        GridItem(.adaptive(minimum: 280, maximum: 300)), // 自动根据屏幕宽度生成尽可能多的单元格，宽度最小为 80 点
        GridItem(.adaptive(minimum: 280, maximum: 300))
    ]
    
        var backgroundRange: [Int] {
            Array(isInAppPurchase ? 0..<39 : 0..<7)
        }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                ZStack {
                    // 背景
                    Color(hex: colorScheme == .light ?  "f0f0f0" : "0E0E0E")
                        .ignoresSafeArea()
                    // 设置列表
                    ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: isPadScreen ? columnsIpad : columns,spacing: 20) {
                                Button(action: {
                                    BackgroundImage = ""
                                }, label: {
                                    Rectangle()
                                        .strokeBorder(BackgroundImage.isEmpty ?  Color(hex:"FF4B00") : .clear, lineWidth: 5)
                                        .overlay {
                                            Rectangle()
                                                .cornerRadius(10)
                                                .frame(width: isPadScreen ? 270 : 136,height: isPadScreen ? 170 : 96)
                                                .foregroundColor(colorScheme == .light ? .white : Color(hex:"2C2B2D") )
                                        }
                                        .foregroundColor(.white)
                                        .frame(width: isPadScreen ? 280 : 140,height: isPadScreen ? 180 : 100)
                                        .cornerRadius(10)
                                        .clipped()
                                })
                                ForEach(backgroundRange, id: \.self) { index in
                                    Button(action: {
                                        BackgroundImage = "bg\(index)"
                                    }, label: {
                                        Rectangle()
                                            .strokeBorder(BackgroundImage == "bg\(index)" ? Color(hex:"FF4B00") : .clear, lineWidth: 5)
                                            .foregroundColor(.white)
                                            .frame(width: isPadScreen ? 280 : 140,height: isPadScreen ? 180 : 100)
                                            .cornerRadius(10)
                                            .clipped()
                                            .overlay {
                                                Image("bg\(index)")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: isPadScreen ? 270 : 136, height: isPadScreen ? 170 : 96)
                                                    .cornerRadius(10)
                                                    .clipped()
                                            }
                                    })
                                }
                            }
                        .padding(.vertical,20)
                        Text("Image by freepik")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .frame(width: width)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .navigationTitle("Main interface background")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

#Preview {
    MainInterfaceBackgroundView()
}
