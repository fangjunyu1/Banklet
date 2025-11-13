//
//  AppStorageManager.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/13.
//

import SwiftUI

// MARK: - 监听iCloud变化
extension AppStorageManager {
    
    /// 监听 iCloud 变化，同步到本地
    func observeiCloudChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(iCloudDidUpdate),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: NSUbiquitousKeyValueStore.default
        )
    }
    
    /// iCloud 数据变化时，更新本地数据
    @objc private func iCloudDidUpdate(notification: Notification) {
        print("iCloud数据发生变化，更新本地数据")
        DispatchQueue.main.async {
            self.loadFromiCloud()
        }
    }
}

// MARK: - 迁移旧的数值
extension AppStorageManager {
    func migrateOldKeysIfNeeded() {
        let defaults = UserDefaults.standard

        // 迁移永久会员
        // 检查旧 key
        if let oldValue = defaults.object(forKey: "20240523") as? Bool {
            defaults.set(oldValue, forKey: "isLifetime")
            defaults.removeObject(forKey: "20240523") // 可选：迁移后清理旧键
            print("已迁移旧永久会员键 20240523 -> isLifetime")
        }

        // 同步到 iCloud（如果你支持）
        let iCloud = NSUbiquitousKeyValueStore.default
        if let oldValue = iCloud.object(forKey: "20240523") as? Bool {
            iCloud.set(oldValue, forKey: "isLifetime")
            iCloud.removeObject(forKey: "20240523")
            iCloud.synchronize()
        }
        
        // 迁移存取备注
        // 检查旧 key
        if let oldValue = defaults.object(forKey: "accessNotes") as? Bool {
            defaults.set(oldValue, forKey: "isAccessNotes")
            defaults.removeObject(forKey: "accessNotes") // 可选：迁移后清理旧键
            print("已迁移旧永久会员键 accessNotes -> isAccessNotes")
        }

        // 同步到 iCloud（如果你支持）
        if let oldValue = iCloud.object(forKey: "accessNotes") as? Bool {
            iCloud.set(oldValue, forKey: "isAccessNotes")
            iCloud.removeObject(forKey: "accessNotes")
            iCloud.synchronize()
        }
    }
}

