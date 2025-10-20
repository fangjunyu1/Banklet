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
    @Environment(AppStorageManager.self) var appStorage
//    @AppStorage("20240523") var isInAppPurchase = false // 内购完成后，设置为true
//    @AppStorage("BackgroundImage") var BackgroundImage = "" // 背景照片
    
    let generator = UISelectionFeedbackGenerator()
    
    let columns = [
        GridItem(.adaptive(minimum: 130, maximum: 200)), // 自动根据屏幕宽度生成尽可能多的单元格，宽度最小为 80 点
        GridItem(.adaptive(minimum: 130, maximum: 200))
    ]
    
    let columnsIpad = [
        GridItem(.adaptive(minimum: 280, maximum: 300)), // 自动根据屏幕宽度生成尽可能多的单元格，宽度最小为 80 点
        GridItem(.adaptive(minimum: 280, maximum: 300))
    ]
    
        var backgroundRange: [Int] {
//            Array(appStorage.isInAppPurchase ? 0..<39 : 0..<7)
            Array(0..<39)
        }
    var backgroundLimit: Int = 7
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
                            LazyVGrid(columns: columns,spacing: 20) {
                                Button(action: {
                                    if appStorage.isVibration {
                                        // 发生振动
                                        generator.prepare()
                                        generator.selectionChanged()
                                    }
                                    appStorage.BackgroundImage = ""
                                }, label: {
                                    Rectangle()
                                        .strokeBorder(appStorage.BackgroundImage.isEmpty ?  .blue : .clear, lineWidth: 5)
                                        .overlay {
                                            Rectangle()
                                                .cornerRadius(10)
                                                .frame(width:  136,height: 96)
                                                .foregroundColor(colorScheme == .light ? .white : Color(hex:"2C2B2D") )
                                                .overlay {
                                                    if appStorage.BackgroundImage.isEmpty {
                                                        VStack {
                                                            Spacer()
                                                            HStack {
                                                                Spacer()
                                                                Image(systemName: "checkmark.circle.fill")
                                                                    .foregroundColor(colorScheme == .light ? .blue : .white)
                                                                    .font(.title)
                                                                    .padding(10)
                                                            }
                                                        }
                                                    }
                                                }
                                        }
                                        .foregroundColor(.white)
                                        .frame(width: 140,height: 100)
                                        .cornerRadius(10)
                                        .clipped()
                                })
                                ForEach(backgroundRange, id: \.self) { index in
                                    Button(action: {
                                        if appStorage.isVibration {
                                            // 发生振动
                                            generator.prepare()
                                            generator.selectionChanged()
                                        }
                                        appStorage.BackgroundImage = "bg\(index)"
                                    }, label: {
                                        Rectangle()
                                            .strokeBorder(appStorage.BackgroundImage == "bg\(index)" ? .blue : .clear, lineWidth: 5)
                                            .foregroundColor(.white)
                                            .frame(width: 140,height:  100)
                                            .cornerRadius(10)
                                            .clipped()
                                            .overlay {
                                                Image("bg\(index)")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width:  136, height: 96)
                                                    .cornerRadius(10)
                                                    .clipped()
                                                    .overlay {
                                                        if appStorage.BackgroundImage == "bg\(index)" {
                                                            VStack {
                                                                Spacer()
                                                                HStack {
                                                                    Spacer()
                                                                    Image(systemName: "checkmark.circle.fill")
                                                                        .foregroundColor(colorScheme == .light ? .blue : .white)
                                                                        .font(.title)
                                                                        .padding(10)
                                                                }
                                                            }
                                                        }
                                                    }
                                            }
                                    })
                                    .overlay {
                                        if !appStorage.isInAppPurchase && index >= backgroundLimit {
                                            ZStack {
                                                Color.black.opacity(0.3)
                                                    .cornerRadius(10)
                                                VStack {
                                                    Spacer()
                                                    HStack {
                                                        Spacer()
                                                        Image(systemName: "lock.fill")
                                                            .imageScale(.large)
                                                            .padding(10)
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        .padding(.vertical,20)
                        Text("Image by freepik")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .frame(width: width)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .navigationTitle("Background")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

#Preview {
    MainInterfaceBackgroundView()
        .environment(AppStorageManager.shared)
        .modelContainer(PiggyBank.preview)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
}
