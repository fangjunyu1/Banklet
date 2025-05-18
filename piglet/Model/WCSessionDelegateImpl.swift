//
//  WCSessionDelegateImpl.swift
//  piglet
//
//  Created by 方君宇 on 2025/5/17.
//
import Foundation
import WatchConnectivity

// 定义 WCSessionDelegateImpl 来处理 WatchConnectivity 的代理方法
@Observable
class WCSessionDelegateImpl: NSObject, WCSessionDelegate {
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            print("当前设备支持 WCSession 。")
            WCSession.default.delegate = self // 设置 WCSessionDelegate
            WCSession.default.activate()
        } else {
            print("当前设备不支持 WCSession.")
        }
    }
    // 激活完成后的处理
    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
        if state == .activated {
            print("Watch端 WCSession 激活成功")
        } else {
            print("Watch端 WCSession 激活失败: \(String(describing: error))")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        // 会话变为非活跃时的处理
        print("WCSession 会话变为非活跃.")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // 会话被停用时的处理
        print("WCSession 会话被停用.")
    }
}
