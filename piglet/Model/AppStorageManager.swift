//
//  AppStorageManager.swift
//  piglet
//
//  Created by 方君宇 on 2025/3/1.
//

import SwiftUI
import Observation

@Observable
class AppStorageManager: ObservableObject {
    static let shared = AppStorageManager()  // 全局单例
    private init() {
        migrateOldKeysIfNeeded() // 历史遗留数据处理
        loadUserDefault()   // 初始化时同步本地存储
        loadFromiCloud()    // 从iCloud读取数据
        observeiCloudChanges()  // 监听 iCloud 变化，同步到本地
    }
    // 防止循环写入标志
    private var isLoading = false
    
    // 判断会员是否有效，显示会员功能
    var isValidMember: Bool {
        isLifetime || Date(timeIntervalSince1970: expirationDate) > Date()
    }
    
    // 欢迎视图
    var isCompletedWelcome: Bool = false { willSet { UserDefaults.standard.set(newValue, forKey: "isCompletedWelcome")}}
    // 活动-音乐按钮
    var isActivityMusic = false { didSet { updateValue(key: "isActivityMusic",newValue: isActivityMusic,oldValue: oldValue)}}
    // iCloud 配置
    var isModelConfigManager = true { didSet { updateValue(key: "isModelConfigManager",newValue: isModelConfigManager,oldValue: oldValue)}}
    // 评分弹窗
    var isRatingWindow = false { didSet {updateValue(key: "isRatingWindow",newValue: isRatingWindow,oldValue: oldValue )}}
    // 永久会员标识，内购产品ID - 20240523
    var isLifetime = false { didSet {updateValue(key: "isLifetime",newValue: isLifetime,oldValue: oldValue )}}
    // 高级有效期
    var expirationDate: Double = Date.distantPast.timeIntervalSince1970 { didSet {updateValue(key: "expirationDate",newValue: expirationDate,oldValue: oldValue )}}
    // Lottie动画
    var LoopAnimation = "Home0" { didSet {updateValue(key: "LoopAnimation",newValue: LoopAnimation,oldValue: oldValue )}}
    // 循环动画
    var isLoopAnimation = false { didSet {updateValue(key: "isLoopAnimation",newValue: isLoopAnimation,oldValue: oldValue )}}
    // 背景照片
    var BackgroundImage = "" { didSet {updateValue(key: "BackgroundImage",newValue: BackgroundImage,oldValue: oldValue )}}
    // 模糊背景
    var isBlurBackground = false { didSet {updateValue(key: "isBlurBackground",newValue: isBlurBackground,oldValue: oldValue )}}
    // 静默模式
    var isSilentMode = false { didSet {updateValue(key: "isSilentMode",newValue: isSilentMode,oldValue: oldValue )}}
    // 货币符号
    var CurrencySymbol = "USD" { didSet {updateValue(key: "CurrencySymbol",newValue: CurrencySymbol,oldValue: oldValue )}}
    // 音效
    var isSoundEffects = true { didSet {updateValue(key: "isSoundEffects",newValue: isSoundEffects,oldValue: oldValue )}}
    // 振动
    var isVibration = true { didSet {updateValue(key: "isVibration",newValue: isVibration,oldValue: oldValue)}}
    // 显示-提醒时间
    var isReminderTime = false { didSet {updateValue(key: "isReminderTime",newValue: isReminderTime,oldValue: oldValue )}}
    // 提醒时间
    var reminderTime: Double = Date().timeIntervalSince1970 { didSet {updateValue(key: "reminderTime",newValue: reminderTime,oldValue: oldValue )}}
    // 密码保护
    var isBiometricEnabled: Bool = false { didSet {updateValue(key: "isBiometricEnabled",newValue: isBiometricEnabled,oldValue: oldValue )}}
    // 存取备注
    var isAccessNotes = false { didSet {updateValue(key: "isAccessNotes",newValue: isAccessNotes,oldValue: oldValue )}}
    
    /// 防止内存泄漏
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
}


// MARK: - 从本地UserDefaults读取数据
extension AppStorageManager {
    // 从本地UserDefaults加载数据
    func loadUserDefault() {
        isLoading = true    // 设置加载进度标志
        defer {
            isLoading = false
            print("退出UserDefaults同步")
        } // 还原加载进度标志
        let defaults = UserDefaults.standard
        // 注册默认值
        defaults.register(defaults: [
            "isModelConfigManager": true,   // 默认开启 iCloud 同步
            "isSoundEffects":true,  // 默认开启音效
            "isVibration": true // 默认开启振动
        ])
        
        isCompletedWelcome = defaults.bool(forKey: "isCompletedWelcome")  // 欢迎视图
        isActivityMusic = defaults.bool(forKey: "isActivityMusic")  // 活动音乐
        isModelConfigManager = defaults.bool(forKey: "isModelConfigManager")    // 是否启用 iCloud
        isRatingWindow = defaults.bool(forKey: "isRatingWindow")    // 评分弹窗
        isLifetime = defaults.bool(forKey: "isLifetime")  /// 内购标识
        expirationDate = defaults.double(forKey: "expirationDate") // 高级会员有效期
        LoopAnimation = defaults.string(forKey: "LoopAnimation") ?? "Home0"  // Lottie动画
        isLoopAnimation = defaults.bool(forKey: "isLoopAnimation")  // 循环动画
        BackgroundImage = defaults.string(forKey: "BackgroundImage") ?? ""  // 背景照片
        isBlurBackground = defaults.bool(forKey: "isBlurBackground") // 模糊背景
        isSilentMode = defaults.bool(forKey: "isSilentMode")  // 静默模式
        CurrencySymbol = defaults.string(forKey: "CurrencySymbol")  ?? "USD"  // 货币符号
        isSoundEffects = defaults.bool(forKey: "isSoundEffects")    // 音效
        isVibration = defaults.bool(forKey: "isVibration")  // 振动
        isReminderTime = defaults.bool(forKey: "isReminderTime")  // 显示-提醒时间
        reminderTime = defaults.double(forKey: "reminderTime") // 提醒时间
        isBiometricEnabled = defaults.bool(forKey: "isBiometricEnabled")  // 密码保护
        isAccessNotes = defaults.bool(forKey: "isAccessNotes")  // 存取备注
    }
}

// MARK: - 从iCloud读取数据
extension AppStorageManager {
    
    /// 从 iCloud 读取数据
    /// // 不从iCloud中加载欢迎视图: isCompletedWelcome - Bool，每次下载应用都会显示欢迎视图
    /// 
    func loadFromiCloud() {
        isLoading = true    // 设置加载进度标志
        defer {
            isLoading = false
            print("退出 iCloud 云同步")
        } // 还原加载进度标志
        let store = NSUbiquitousKeyValueStore.default
        
        loadValueFromiCloud(key: "isActivityMusic") // 活动音乐
        loadValueFromiCloud(key: "isModelConfigManager")    // 加载 iCloud
        loadValueFromiCloud(key: "isRatingWindow")    // 评分弹窗
        loadValueFromiCloud(key: "isLifetime")    // 内购标识
        loadValueFromiCloud(key: "expirationDate")    // 高级会员有效期
        loadValueFromiCloud(key: "LoopAnimation")    // Lottie动画
        loadValueFromiCloud(key: "isLoopAnimation")    // 循环动画
        loadValueFromiCloud(key: "BackgroundImage")    // 背景图片
        loadValueFromiCloud(key: "isBlurBackground")    // 模糊图片
        loadValueFromiCloud(key: "isSilentMode")    // 静默模式
        loadValueFromiCloud(key: "CurrencySymbol")    // 货币符号
        loadValueFromiCloud(key: "isSoundEffects")    // 音效
        loadValueFromiCloud(key: "isVibration")    // 振动
        loadValueFromiCloud(key: "isReminderTime")    // 显示-提醒时间
        loadValueFromiCloud(key: "reminderTime")    // 提醒时间
        loadValueFromiCloud(key: "isBiometricEnabled")    // 密码保护
        loadValueFromiCloud(key: "isAccessNotes")    // 存取备注
        
        store.synchronize() // 强制触发数据同步
    }
}


// MARK: - 更新字段，保存到 UserDefaults，并尝试同步 iCloud
extension AppStorageManager {
    private func loadValueFromiCloud(key: String) {
        let store = NSUbiquitousKeyValueStore.default
        guard store.object(forKey: key) != nil else {
            print("iCloud中无 \(key)，保持本地值，不同步。")
            return
        }
        print("iCloud中 \(key) 值为\(store.object(forKey: key) ?? "None")")
        switch key {
        case "isActivityMusic": isActivityMusic = store.bool(forKey: key)
        case "isModelConfigManager": isModelConfigManager = store.bool(forKey: key)
        case "isRatingWindow": isRatingWindow = store.bool(forKey: key)
        case "isLifetime": isLifetime = store.bool(forKey: key)
        case "expirationDate": expirationDate = store.double(forKey: key)
        case "LoopAnimation": LoopAnimation = store.string(forKey: key) ?? "Home0"
        case "isLoopAnimation": isLoopAnimation = store.bool(forKey: key)
        case "BackgroundImage": BackgroundImage = store.string(forKey: key) ?? ""
        case "isBlurBackground": isBlurBackground = store.bool(forKey: key)
        case "isSilentMode": isSilentMode = store.bool(forKey: key)
        case "CurrencySymbol": CurrencySymbol = store.string(forKey: key) ?? "USD"
        case "isSoundEffects": isSoundEffects = store.bool(forKey: key)
        case "isVibration": isVibration = store.bool(forKey: key)
        case "isReminderTime": isReminderTime = store.bool(forKey: key)
        case "reminderTime": reminderTime = store.double(forKey: key)
        case "isBiometricEnabled": isBiometricEnabled = store.bool(forKey: key)
        case "isAccessNotes": isAccessNotes = store.bool(forKey: key)
        default:
            print("未定义的 iCloud key：\(key)")
        }
    }
}

// MARK: - 更新字段，保存到 UserDefaults，并尝试同步 iCloud
extension AppStorageManager {
    private func updateValue<T:Equatable>(key: String, newValue: T, oldValue: T) {
        guard newValue != oldValue, !isLoading else { return }
        
        // 同步保存到本地
        let defaults = UserDefaults.standard
        defaults.set(newValue, forKey: key)
        
        // iCloud
        let store = NSUbiquitousKeyValueStore.default
        store.set(newValue, forKey: key)
        store.synchronize()
    }
}
