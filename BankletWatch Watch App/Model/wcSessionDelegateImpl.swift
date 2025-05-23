//
//  wcSessionDelegateImpl.swift
//  piglet
//
//  Created by 方君宇 on 2025/5/23.
//

import WatchConnectivity
import UserNotifications

// 定义 WatchSessionDelegate 来接收 iOS主应用传递的数据
@Observable
class WatchSessionDelegate: NSObject, WCSessionDelegate {
    
    func scheduleNotification() {
        // 清理就通知
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Watch提示"
        content.body = "提示添加成功"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("添加通知失败: \(error)")
            } else {
                print("通知已成功添加")
            }
        }
    }
    
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
    
    // 处理从 iOS 应用发送过来的消息
    func session(_ session: WCSession, didReceiveUserInfo wcSessionInfos: [String : Any]) {
        if wcSessionInfos["type"] as? String == "dataUpdated" {
            scheduleNotification()
        }
        // 接收到的 userInfo 字典
        print("Received user info: \(wcSessionInfos)")
        // 将传入的数字存储到UserDefault。
        UserDefaults.standard.set(wcSessionInfos["clickCount"], forKey: "clickCount")
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
