//
//  MainInterfaceAnimationView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/29.
//

import SwiftUI

struct AnimationView: View {
    
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
//    @AppStorage("20240523") var isInAppPurchase = false // 内购完成后，设置为true
//    @AppStorage("LoopAnimation") var LoopAnimation = "Home0" // Lottie动画
//    @AppStorage("isLoopAnimation") var isLoopAnimation = false  // 循环动画
    
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
//        Array(appStorage.isInAppPurchase ? 0..<54 : 0..<8)
        Array(0..<54)
    }
    
    var backgroundRangeLimit: Int = 8

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
                    VStack {
                        // 循环开关
                        VStack {
                            Text("When enabled, the animation will play in a loop.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                            
                            SettingView(content: {
                                Text("Loop animation")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                Spacer()
                                Toggle("",isOn: Binding(get: {
                                    appStorage.isLoopAnimation
                                }, set: {
                                    appStorage.isLoopAnimation = $0
                                }))  // 循环开关
                                    .frame(height:0)
                            })
                        }
                        .padding(10)
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: columns,spacing: 20) {
                                ForEach(backgroundRange, id: \.self) { index in
                                    Button(action: {
                                        if appStorage.isVibration {
                                            // 发生振动
                                            generator.prepare()
                                            generator.selectionChanged()
                                        }
                                        appStorage.LoopAnimation = "Home\(index)"
                                        print("LoopAnimation:\(appStorage.LoopAnimation)")
                                    }, label: {
                                        LottieView(filename: "Home\(index)", isPlaying: appStorage.isLoopAnimation ? true : false, playCount: 0, isReversed: false)
                                            .id(appStorage.LoopAnimation) // 关键：确保当 LoopAnimation 变化时，LottieView 重新加载
                                            .scaleEffect(x: layoutDirection == .leftToRight ? AnimationScaleConfig.scale(for: "Home\(index)") : -AnimationScaleConfig.scale(for: "Home\(index)"),
                                                y:  AnimationScaleConfig.scale(for: "Home\(index)"))// 水平翻转视图
                                            .frame(width: 140,height: 100)
                                            .background(colorScheme == .light ? .white : Color(hex: "2C2B2D"))
                                            .cornerRadius(10)
                                            .overlay {
                                                if appStorage.LoopAnimation == "Home\(index)" {
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
                                    })
                                    .overlay {
                                        if !appStorage.isInAppPurchase && index >= backgroundRangeLimit {
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
                            Text("by Lottiefiles")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.vertical,20)
                        }
                    }
                    .frame(width: width)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .navigationTitle("Animation")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

#Preview {
    AnimationView()
            .environment(\.locale, .init(identifier: "ar"))
            .environment(AppStorageManager.shared)
            .modelContainer(PiggyBank.preview)
            .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
            .environmentObject(IAPManager.shared)
            .environmentObject(SoundManager.shared)
}
