//
//  BankletWatchApp.swift
//  BankletWatch Watch App
//
//  Created by 方君宇 on 2025/2/18.
//

import SwiftUI
import WatchConnectivity

@main
struct BankletWatch_Watch_AppApp: App {
    @State private var wcSessionDelegateImpl = WatchSessionDelegate()
    
    init() {
        // 激活 WCSession
        if WCSession.isSupported() {
            print("激活 WCSession")
            WCSession.default.delegate = wcSessionDelegateImpl  // 设置 WCSession 的代理
            WCSession.default.activate()  // 激活 WCSession
            if WCSession.default.isReachable {
                print("Watch与iOS连接成功")
            } else {
                print("Watch与iOS未连接")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(wcSessionDelegateImpl)
    }
}

// 定义 WatchSessionDelegate 来接收 iOS主应用传递的数据
@Observable
class WatchSessionDelegate: NSObject, WCSessionDelegate {
    
    // 存储接收到的数据
    var piggyBanks: [PiggyBank] = []
    // 处理从 iOS 应用发送过来的消息
    func session(_ session: WCSession, didReceiveUserInfo wcSessionPiggyBanks: [String : Any]) {
        // 接收到的 userInfo 字典
        print("Received user info: \(wcSessionPiggyBanks)")
        if let piggyBank = wcSessionPiggyBanks["piggyBanks"] as? [[String: Any]] {
            print("piggyBank:\(piggyBank)")
            piggyBanks = piggyBank.compactMap {
                if let name = $0["name"] as? String,
                       let icon = $0["icon"] as? String,
                       let amount = $0["amount"] as? Double,
                       let targetAmount = $0["targetAmount"] as? Double,
                       let isPrimary = $0["isPrimary"] as? Bool {
                        return PiggyBank(name: name, icon: icon, amount: amount, targetAmount: targetAmount, isPrimary: isPrimary)
                    }
                    return nil  // 如果解包失败，则返回 nil
            }
        }
        print("piggyBanks:\(piggyBanks)")
    }
    
    // 激活完成后的处理
    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Watch端 WCSession 激活失败: \(error)")
        } else {
            print("Watch端 WCSession 激活成功，状态: \(state.rawValue)")  // 输出状态
        }
    }
}

struct PiggyBank: Codable {
    var name: String
    var icon: String
    var amount: Double
    var targetAmount: Double
    var isPrimary: Bool
}
