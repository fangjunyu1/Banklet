//
//  IdleTimerManager.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/28.
//

import SwiftUI

@Observable
class IdleTimerManager: ObservableObject {
    static let shared = IdleTimerManager()
    var isIdle = false
    var isShowingIdleView = false
    private var timer: Timer?
    private let timeout: TimeInterval = 10
    
    private init() {
        print("IdleTimerManager 初始化")
        resetTimer()
    }
    
    func resetTimer() {
        guard !isShowingIdleView else {
            print("正在显示静默视图，阻止重置计时器")
            return
        }
        print("触发 resetTimer")
        timer?.invalidate()
        isIdle = false
        guard AppStorageManager.shared.isSilentMode else {
            print("当前不是静默模式，退出")
            timer?.invalidate()
            return
        }
        print("重新计时")
        self.timer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { _ in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.isIdle = true
                }
            }
        }
    }
    
    func stopTimer() {
        print("关闭计时器")
        timer?.invalidate()
        timer = nil
        isIdle = false
    }
}
