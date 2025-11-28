//
//  LottieView.swift
//  piglet
//
//  Created by 方君宇 on 2024/6/2.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var filename: String
    var isPlaying: Bool // 控制是否播放
    var playCount: Int // 播放次数，0 表示无限循环
    var isReversed: Bool // 是否倒放

    class Coordinator {
        var parent: LottieView
        init(parent: LottieView) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        // 创建 Lottie 动画视图
        let animationView = LottieAnimationView(name: filename)
        animationView.contentMode = .scaleAspectFit // 确保动画等比例缩放
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = playCount == 0 ? .loop : .playOnce
        
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if isPlaying {
            playAnimation(animationView, playCount: playCount, isReversed: isReversed)
        }
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let animationView = uiView.subviews.first as? LottieAnimationView else { return }
        
        if isPlaying {
            playAnimation(animationView, playCount: playCount, isReversed: isReversed)
        } else {
            animationView.stop()
        }
    }

    // 播放动画的辅助方法
    private func playAnimation(_ animationView: LottieAnimationView, playCount: Int, isReversed: Bool) {
        animationView.animationSpeed = isReversed ? -1 : 1

        if isReversed {
            animationView.currentProgress = 1 // 从最后一帧开始倒放
        }

        if playCount == 0 {
            animationView.loopMode = .loop
            animationView.play()
        } else {
            animationView.loopMode = .playOnce
            animationView.play { _ in
                if playCount > 1 {
                    playAnimation(animationView, playCount: playCount - 1, isReversed: isReversed)
                }
            }
        }
    }
}
