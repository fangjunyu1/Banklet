//
//  AppStorageManager.swift
//  piglet
//
//  Created by 方君宇 on 2025/3/1.
//

import SwiftUI
import Observation

@Observable
class AppStorageManager {
    static let shared = AppStorageManager()  // 全局单例
    private init() {
        // 初始化时同步本地存储
        loadUserDefault()
        
        // 从iCloud读取数据
        loadFromiCloud()
        
        // 监听 iCloud 变化，同步到本地
        observeiCloudChanges()
        
        // 监听应用进入后台事件
//        observeAppLifecycle()
    }
    
    private var isLoading = false
    
    // 视图步骤
    var pageSteps: Int = 1 {
        // 1:欢迎界面，2:隐私视图，其他:主视图
        didSet {
            if pageSteps != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(pageSteps, forKey: "pageSteps")
                store.synchronize() // 强制触发数据同步
            }
        }
    }

    // 密码保护
    var isBiometricEnabled: Bool = false  {
        didSet {
            if isBiometricEnabled != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(isBiometricEnabled, forKey: "isBiometricEnabled")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // 背景照片
    var BackgroundImage = "" {
        didSet {
            if BackgroundImage != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(BackgroundImage, forKey: "BackgroundImage")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // Lottie动画
    var LoopAnimation = "Home0" {
        didSet {
            if LoopAnimation != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(LoopAnimation, forKey: "LoopAnimation")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // 循环动画
    var isLoopAnimation = false {
        didSet {
            if isLoopAnimation != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(isLoopAnimation, forKey: "isLoopAnimation")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // 静默模式
    var isSilentMode = false  {
        didSet {
            if isSilentMode != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(isSilentMode, forKey: "isSilentMode")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // 货币符号
    var CurrencySymbol = "USD" {
        didSet {
            if CurrencySymbol != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(CurrencySymbol, forKey: "CurrencySymbol")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // 存钱罐首页显示样式，为true则显示已存入的金额
    var SwitchTopStyle: Bool = false  {
        didSet {
            if SwitchTopStyle != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(SwitchTopStyle, forKey: "SwitchTopStyle")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // 请求评分
    var RatingClicks: Int = 0  {
        didSet {
            if RatingClicks != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(RatingClicks, forKey: "RatingClicks")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    /// 内购完成后，设置为true，@AppStorage("20240523")
    var isInAppPurchase = false {
        didSet {
            if isInAppPurchase != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(isInAppPurchase, forKey: "20240523")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // false表示隐藏
    var isShowAboutUs = true  {
        didSet {
            if isShowAboutUs != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(isShowAboutUs, forKey: "isShowAboutUs")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // 控制内购按钮，false表示隐藏
    var isShowInAppPurchase = true  {
        didSet {
            if isShowInAppPurchase != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(isShowInAppPurchase, forKey: "isShowInAppPurchase")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // 控制鸣谢页面，false表示隐藏
    var isShowThanks = true {
        didSet {
            if isShowThanks != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(isShowThanks, forKey: "isShowThanks")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // ModelConfig配置
    var isModelConfigManager = true {
        didSet {
            if isModelConfigManager != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(isModelConfigManager, forKey: "isModelConfigManager")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // 提醒时间，设置提醒时间为true，否则为false
    var isReminderTime = false {
        didSet {
            if isReminderTime != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(isReminderTime, forKey: "isReminderTime")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // 存储用户设定的提醒时间
    var reminderTime: Double = Date().timeIntervalSince1970 {
        didSet {
            if reminderTime != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(reminderTime, forKey: "reminderTime")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // 存取信息的存取备注
    var accessNotes = false {
        didSet {
            if accessNotes != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(accessNotes, forKey: "accessNotes")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // 活动入口
    var isShowActivity = true {
        didSet {
            if isShowActivity != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(isShowActivity, forKey: "isShowActivity")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // 应用图标
    var appIcon = "AppIcon 2"
    
    // 音效
    var isSoundEffects = true {
        didSet {
            if isSoundEffects != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(isSoundEffects, forKey: "isSoundEffects")
                store.synchronize() // 强制触发数据同步
            }
        }
    }
    
    // 振动
    var isVibration = true {
        didSet {
            if isVibration != oldValue && !isLoading {
                let store = NSUbiquitousKeyValueStore.default
                store.set(isVibration, forKey: "isVibration")
                store.synchronize() // 强制触发数据同步
            }
        }
    }

    // 从UserDefaults加载数据
    private func loadUserDefault() {
        print("进入loadUserDefault方法，从 UserDefaults 中加载数据")
        isLoading = true
        defer {
            isLoading = false
            print("从 UserDefault 中加载完成数据")
        }  // 无论中间发生什么都能复原标志
        pageSteps = UserDefaults.standard.integer(forKey: "pageSteps")  // 视图步骤
        isBiometricEnabled = UserDefaults.standard.bool(forKey: "isBiometricEnabled")  // 密码保护
        BackgroundImage = UserDefaults.standard.string(forKey: "BackgroundImage") ?? ""  // 背景照片
        LoopAnimation = UserDefaults.standard.string(forKey: "LoopAnimation") ?? "Home0"  // Lottie动画
        isLoopAnimation = UserDefaults.standard.bool(forKey: "isLoopAnimation")  // 循环动画
        isSilentMode = UserDefaults.standard.bool(forKey: "isSilentMode")  // 静默模式
        CurrencySymbol = UserDefaults.standard.string(forKey: "CurrencySymbol")  ?? "USD"  // 密码保护
        SwitchTopStyle = UserDefaults.standard.bool(forKey: "SwitchTopStyle")  // 存钱罐首页显示样式，为true则显示已存入的金额
        RatingClicks = UserDefaults.standard.integer(forKey: "RatingClicks")  // 请求评分
        isInAppPurchase = UserDefaults.standard.bool(forKey: "20240523")  /// 内购完成后，设置为true，@AppStorage("20240523")
        isShowAboutUs = UserDefaults.standard.bool(forKey: "isShowAboutUs")  // false表示隐藏
        isShowInAppPurchase = UserDefaults.standard.bool(forKey: "isShowInAppPurchase")  // 控制内购按钮，false表示隐藏
        isShowThanks = UserDefaults.standard.bool(forKey: "isShowThanks")  // 控制鸣谢页面，false表示隐藏
        if UserDefaults.standard.object(forKey: "isModelConfigManager") == nil {
            // 设置默认值为 true
            UserDefaults.standard.set(true, forKey: "isModelConfigManager")
        }
        isModelConfigManager = UserDefaults.standard.bool(forKey: "isModelConfigManager")  // ModelConfig配置
        isReminderTime = UserDefaults.standard.bool(forKey: "isReminderTime")  // 提醒时间，设置提醒时间为true，否则为false
        reminderTime = UserDefaults.standard.double(forKey: "reminderTime") // 存储用户设定的提醒时间
        accessNotes = UserDefaults.standard.bool(forKey: "accessNotes")  // 存取备注
        if UserDefaults.standard.object(forKey: "isShowActivity") == nil {
            // 设置默认值为 true
            UserDefaults.standard.set(true, forKey: "isShowActivity")
        }
        isShowActivity = UserDefaults.standard.bool(forKey: "isShowActivity")  // 活动入口
        appIcon = UserDefaults.standard.string(forKey: "appIcon") ?? "AppIcon 2"  // 应用图标
        // 音效，默认配置为 true
        if UserDefaults.standard.object(forKey: "isSoundEffects") == nil {
            // 设置默认值为 true
            UserDefaults.standard.set(true, forKey: "isSoundEffects")
        }
        // 振动，默认配置为 true
        if UserDefaults.standard.object(forKey: "isVibration") == nil {
            // 设置默认值为 true
            UserDefaults.standard.set(true, forKey: "isVibration")
        }
        
    }
    
    /// 从 iCloud 读取数据
    private func loadFromiCloud() {
        let store = NSUbiquitousKeyValueStore.default
        print("从iCloud读取数据")

        // 读取整数值
        if let storedPageSteps = store.object(forKey: "pageSteps") as? Int {
            pageSteps = storedPageSteps
            print("pageSteps:\(pageSteps)")
        } else {
            store.set(pageSteps, forKey: "pageSteps")
            print("无法从iCloud加载 pageSteps 内容，将当前变量同步到iCloud")
        }
        
        if let storedRatingClicks = store.object(forKey: "RatingClicks") as? Int {
            RatingClicks = storedRatingClicks
            print("RatingClicks:\(RatingClicks)")
        } else {
            store.set(RatingClicks, forKey: "RatingClicks")
            print("无法从iCloud加载 RatingClicks 内容，将当前变量同步到iCloud")
        }

        // 读取双精度值
        if store.object(forKey: "reminderTime") != nil {
            reminderTime = store.double(forKey: "reminderTime")
            print("reminderTime:\(reminderTime)")
        } else {
            store.set(reminderTime, forKey: "reminderTime")
            print("无法从iCloud加载 reminderTime 内容，将当前变量同步到iCloud")
        }
        
        // 读取布尔值
        if store.object(forKey: "isBiometricEnabled") != nil {
            isBiometricEnabled = store.bool(forKey: "isBiometricEnabled")
            print("isBiometricEnabled:\(isBiometricEnabled)")
        } else {
            store.set(isBiometricEnabled, forKey: "isBiometricEnabled")
            print("无法从iCloud加载 isBiometricEnabled 内容，将当前变量同步到iCloud")
        }
        
        if store.object(forKey: "isLoopAnimation") != nil {
            isLoopAnimation = store.bool(forKey: "isLoopAnimation")
            print("isLoopAnimation:\(isLoopAnimation)")
        } else {
            store.set(isLoopAnimation, forKey: "isLoopAnimation")
            print("无法从iCloud加载 isLoopAnimation 内容，将当前变量同步到iCloud")
        }
        
        if store.object(forKey: "isSilentMode") != nil {
            isSilentMode = store.bool(forKey: "isSilentMode")
            print("isSilentMode:\(isSilentMode)")
        } else {
            store.set(isSilentMode, forKey: "isSilentMode")
            print("无法从iCloud加载 isSilentMode 内容，将当前变量同步到iCloud")
        }
        
        if store.object(forKey: "SwitchTopStyle") != nil {
            SwitchTopStyle = store.bool(forKey: "SwitchTopStyle")
            print("SwitchTopStyle:\(SwitchTopStyle)")
        } else {
            store.set(SwitchTopStyle, forKey: "SwitchTopStyle")
            print("无法从iCloud加载 SwitchTopStyle 内容，将当前变量同步到iCloud")
        }
        
        if store.object(forKey: "20240523") != nil {
            isInAppPurchase = store.bool(forKey: "20240523")
            print("isInAppPurchase:\(isInAppPurchase)")
        } else {
            store.set(isInAppPurchase, forKey: "20240523")
            print("无法从iCloud加载 20240523 内容，将当前变量同步到iCloud")
        }
        
        if store.object(forKey: "isShowAboutUs") != nil {
            isShowAboutUs = store.bool(forKey: "isShowAboutUs")
            print("isShowAboutUs:\(isShowAboutUs)")
        } else {
            store.set(isShowAboutUs, forKey: "isShowAboutUs")
            print("无法从iCloud加载 isShowAboutUs 内容，将当前变量同步到iCloud")
        }
        
        if store.object(forKey: "isShowInAppPurchase") != nil {
            isShowInAppPurchase = store.bool(forKey: "isShowInAppPurchase")
            print("isShowInAppPurchase:\(isShowInAppPurchase)")
        } else {
            store.set(isShowInAppPurchase, forKey: "isShowInAppPurchase")
            print("无法从iCloud加载 isShowInAppPurchase 内容，将当前变量同步到iCloud")
        }
        
        if store.object(forKey: "isShowThanks") != nil {
            isShowThanks = store.bool(forKey: "isShowThanks")
            print("isShowThanks:\(isShowThanks)")
        } else {
            store.set(isShowThanks, forKey: "isShowThanks")
            print("无法从iCloud加载 isShowThanks 内容，将当前变量同步到iCloud")
        }
        
        if store.object(forKey: "isModelConfigManager") != nil {
            isModelConfigManager = store.bool(forKey: "isModelConfigManager")
            print("isModelConfigManager:\(isModelConfigManager)")
        } else {
            store.set(isModelConfigManager, forKey: "isModelConfigManager")
            print("无法从iCloud加载 isModelConfigManager 内容，将当前变量同步到iCloud")
        }
        
        if store.object(forKey: "isReminderTime") != nil {
            isReminderTime = store.bool(forKey: "isReminderTime")
            print("isReminderTime:\(isReminderTime)")
        } else {
            store.set(isReminderTime, forKey: "isReminderTime")
            print("无法从iCloud加载 isReminderTime 内容，将当前变量同步到iCloud")
        }
        
        if store.object(forKey: "accessNotes") != nil {
            accessNotes = store.bool(forKey: "accessNotes")
            print("accessNotes:\(accessNotes)")
        } else {
            store.set(accessNotes, forKey: "accessNotes")
            print("无法从iCloud加载 accessNotes 内容，将当前变量同步到iCloud")
        }
        
        if store.object(forKey: "isShowActivity") != nil {
            isShowActivity = store.bool(forKey: "isShowActivity")
            print("isShowActivity:\(isShowActivity)")
        } else {
            store.set(isShowActivity, forKey: "isShowActivity")
            print("无法从iCloud加载 isShowActivity 内容，将当前变量同步到iCloud")
        }

        // 读取字符串值
        if let storedBackgroundImage = store.string(forKey: "BackgroundImage") {
            BackgroundImage = storedBackgroundImage
            print("BackgroundImage:\(BackgroundImage)")
        } else {
            store.set(BackgroundImage, forKey: "BackgroundImage")
            print("无法从iCloud加载 BackgroundImage 内容，将当前变量同步到iCloud")
        }
        
        if let storedLoopAnimation = store.string(forKey: "LoopAnimation") {
            LoopAnimation = storedLoopAnimation
            print("LoopAnimation:\(LoopAnimation)")
        } else {
            store.set(LoopAnimation, forKey: "LoopAnimation")
            print("无法从iCloud加载 LoopAnimation 内容，将当前变量同步到iCloud")
        }
        
        if let storedCurrencySymbol = store.string(forKey: "CurrencySymbol") {
            CurrencySymbol = storedCurrencySymbol
            print("CurrencySymbol:\(CurrencySymbol)")
        } else {
            store.set(CurrencySymbol, forKey: "CurrencySymbol")
            print("无法从iCloud加载 CurrencySymbol 内容，将当前变量同步到iCloud")
        }
        
        // 音效
        if store.object(forKey: "isSoundEffects") != nil {
            isSoundEffects = store.bool(forKey: "isSoundEffects")
            print("isSoundEffects:\(isSoundEffects)")
        } else {
            store.set(isSoundEffects, forKey: "isSoundEffects")
            print("无法从iCloud加载 isSoundEffects 内容，将当前变量同步到iCloud")
        }
        
        // 振动
        if store.object(forKey: "isVibration") != nil {
            accessNotes = store.bool(forKey: "isVibration")
            print("isVibration:\(isVibration)")
        } else {
            store.set(isVibration, forKey: "isVibration")
            print("无法从iCloud加载 isVibration 内容，将当前变量同步到iCloud")
        }
        
        print("完成 loadFromiCloud 方法的读取")
        store.synchronize() // 强制触发数据同步
        
//        getAllData()

    }
    
    /// 数据变化时，**同步到 iCloud**
//    private func syncToiCloud() {
//        print("进入到syncToiCloud方法")
//        let store = NSUbiquitousKeyValueStore.default
//        store.set(pageSteps, forKey: "pageSteps")
//        store.set(isBiometricEnabled, forKey: "isBiometricEnabled")
//        store.set(BackgroundImage, forKey: "BackgroundImage")
//        store.set(LoopAnimation, forKey: "LoopAnimation")
//        store.set(isLoopAnimation, forKey: "isLoopAnimation")
//        store.set(isSilentMode, forKey: "isSilentMode")
//        store.set(CurrencySymbol, forKey: "CurrencySymbol")
//        store.set(SwitchTopStyle, forKey: "SwitchTopStyle")
//        store.set(RatingClicks, forKey: "RatingClicks")
//        store.set(isInAppPurchase, forKey: "20240523")
//        store.set(isShowAboutUs, forKey: "isShowAboutUs")
//        store.set(isShowInAppPurchase, forKey: "isShowInAppPurchase")
//        store.set(isShowThanks, forKey: "isShowThanks")
//        store.set(isModelConfigManager, forKey: "isModelConfigManager")
//        store.set(isReminderTime, forKey: "isReminderTime")
//        store.set(reminderTime, forKey: "reminderTime")
//        store.set(accessNotes, forKey: "accessNotes")
//        store.set(isShowActivity, forKey: "isShowActivity")
//        store.synchronize() // 强制触发数据同步
//        print("完成 syncToiCloud 方法，显示 iCloud 上的数据")
//        getAllData()
//    }
    
    /// 监听 iCloud 变化，同步到本地
    private func observeiCloudChanges() {
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
    
    /// 防止内存泄漏
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
}
