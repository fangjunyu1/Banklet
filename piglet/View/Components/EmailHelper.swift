//
//  EmailHelper.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/3.
//

import SwiftUI
import DeviceKit

/// 邮件发送工具
struct EmailHelper {
    
    /// 打开发送邮件窗口（预填收件人、主题、设备信息等）
    static func sendFeedbackEmail() {
        let email = "fangjunyu.com@gmail.com"
        let subject = "Banklet Feedback"
        
        // 收集设备和 App 信息
        let systemVersion = UIDevice.current.systemVersion
        let deviceModel = Device.current
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        
        let body = """
                ---
                systemVersion: \(deviceModel)
                iOS Version: \(systemVersion)
                App Version: \(appVersion) (\(buildNumber))
                ---
                
                
                """
        
        // URL 编码参数
        let urlString = "mailto:\(email)?subject=\(subject)&body=\(body)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: urlString ?? ""),UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            // 处理无法打开邮件应用的情况
            print("Cannot open Mail app.")
        }
    }
}
