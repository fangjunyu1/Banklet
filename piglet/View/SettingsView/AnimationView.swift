//
//  MainInterfaceAnimationView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/29.
//

import SwiftUI
import StoreKit

struct AnimationView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appStorage: AppStorageManager
    
    let generator = UISelectionFeedbackGenerator()
    let columns = Array(repeating: GridItem(.adaptive(minimum: 130, maximum: 200)), count: 2)
    
    var backgroundRange: [Int] {
        Array(0..<54)
    }
    
    var backgroundRangeLimit: Int = 8   // 免费Lottie动画数量
    
    var body: some View {
        VStack {
            Spacer().frame(height: 10)  // 顶部留白
            // 循环开关
            HomeSettingNoIconRow(title: "Loop animation", footnote: "When enabled, the animation will play in a loop.", accessory: .binding($appStorage.isLoopAnimation))
            Spacer().frame(height: 20)
            
            // 当前动画
            Footnote(text: "Current Animation")
            HStack(alignment: .center) {
                LottieView(filename: appStorage.LoopAnimation, isPlaying: appStorage.isLoopAnimation ? true : false, playCount: 0, isReversed: false)
                    .id(appStorage.LoopAnimation) // 关键：确保当 LoopAnimation 变化时，LottieView 重新加载
                    .frame(width: 140,height: 100)
                    .cornerRadius(10)
            }
            Spacer().frame(height: 20)
            // 所有动画
            HStack {
                Footnote(text: "All Animations")
                Spacer()
            }
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns,spacing: 20) {
                    ForEach(backgroundRange, id: \.self) { index in
                        
                        // 当前选中动画
                        let selectedItem: Bool = appStorage.LoopAnimation == "Home\(index)"
                        Button(action: {
                            handleTap(index: index)
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(selectedItem ? .blue : .clear, lineWidth: 6)
                                    .frame(width: 140,height: 100)
                                    .foregroundColor(.white)
                                LottieView(filename: "Home\(index)", isPlaying: appStorage.isLoopAnimation ? true : false, playCount: 0, isReversed: false)
                                    .id(appStorage.isLoopAnimation) // 关键：确保当 LoopAnimation 变化时，LottieView 重新加载
                                    .frame(width: 140,height: 100)
                                    .background(colorScheme == .light ? .white : Color(hex: "2C2B2D"))
                                    .cornerRadius(10)
                                    .scaleEffect(selectedItem ? 0.8 : 1)
                            }
                        })
                        .overlay {
                            if !appStorage.isValidMember && index >= backgroundRangeLimit {
                                LockApp()   // 未解锁的状态
                            }
                        }
                    }
                }
                FootnoteSource(text: "by Lottiefiles")
            }
        }
        .navigationTitle("Animation")
        .modifier(BackgroundModifier())
    }
    
    // 点击动画，触发振动
    private func handleTap(index: Int) {
        // 振动
        HapticManager.shared.selectionChanged()
        withAnimation {
            appStorage.LoopAnimation = "Home\(index)"
        }
        // 评分弹窗
        if !appStorage.isRatingWindow {
            SKStoreReviewController.requestReview()
            appStorage.isRatingWindow = true
        }
        
        print("LoopAnimation:\(appStorage.LoopAnimation)")
    }
}

#Preview {
    NavigationStack {
        AnimationView()
            .environment(AppStorageManager.shared)
        //        .environment(\.locale, .init(identifier: "ar"))
    }
}
