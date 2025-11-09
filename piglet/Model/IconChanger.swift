//
//  IconChanger.swift
//  piglet
//
//  Created by 方君宇 on 2025/6/16.
//
// 用于屏蔽切换图标的提示框

import SwiftUI

class IconChanger {
    static func changeIconSilently(to name: String?,selected: Binding<String>? = nil) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let rootVC = windowScene.windows.first?.rootViewController else {
            // 安全地拿到当前活跃窗口的根控制器
            print("无法找到 rootVC，退出方法")
            return
        }
        
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }
        
        let transparentVC = TransparentViewController()
        transparentVC.modalPresentationStyle = .overFullScreen
        
        if !(topVC is TransparentViewController) && !(topVC is UIAlertController) {
            topVC.present(transparentVC, animated: false)
            if UIApplication.shared.supportsAlternateIcons {
                print("支持功能图标的功能")
                UIApplication.shared.setAlternateIconName(name)
                DispatchQueue.main.async {
                    // 修改存储的图标名称
                    withAnimation {
                        AppStorageManager.shared.appIcon = name ?? "AppIcon 2"
                        selected?.wrappedValue = AppStorageManager.shared.appIcon
                    }
                }
            } else {
                print("不支持更换图标功能")
            }
        } else {
            // 已有其他控制器，无法静默处理
            print("topVC 判断出错，设置 App Icon 出错")
        }
    }
}
