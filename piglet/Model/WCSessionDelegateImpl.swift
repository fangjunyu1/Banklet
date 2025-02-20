//
//  WCSessionDelegateImpl.swift
//  piglet
//
//  Created by 方君宇 on 2025/2/20.
//

import WatchConnectivity

// 定义 WCSessionDelegateImpl 来处理 WatchConnectivity 的代理方法
@Observable
class WCSessionDelegateImpl: NSObject, WCSessionDelegate {
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("进入 WCSessionDelegateImpl 的 session 方法")
        // 处理从 WatchOS 接收到的消息
        if let piggyBanks = message["piggyBanks"] as? [[String: Any]] {
            print("接收到 \(piggyBanks.count) 个存钱罐数据")
            for bank in piggyBanks {
                if let name = bank["name"] as? String {
                    print("Received piggy bank: \(name)")
                }
            }
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
