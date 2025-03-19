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
        observeAppLifecycle()
    }
    
    // 视图步骤
    var pageSteps: Int = 1 {
        didSet {
            if pageSteps != oldValue {
                UserDefaults.standard.set(pageSteps, forKey: "pageSteps")
                syncToiCloud()
            }
        }
    }

    // 密码保护
    var isBiometricEnabled: Bool = false  {
        didSet {
            if isBiometricEnabled != oldValue {
                UserDefaults.standard.set(isBiometricEnabled, forKey: "isBiometricEnabled")
                syncToiCloud()
            }
        }
    }
    
    // 背景照片
    var BackgroundImage = "" {
        didSet {
            if BackgroundImage != oldValue {
                UserDefaults.standard.set(BackgroundImage, forKey: "BackgroundImage")
                syncToiCloud()
            }
        }
    }
    
    // Lottie动画
    var LoopAnimation = "Home0" {
        didSet {
            if LoopAnimation != oldValue {
                UserDefaults.standard.set(LoopAnimation, forKey: "LoopAnimation")
                syncToiCloud()
            }
        }
    }
    
    // 循环动画
    var isLoopAnimation = false {
        didSet {
            if isLoopAnimation != oldValue {
                UserDefaults.standard.set(isLoopAnimation, forKey: "isLoopAnimation")
                syncToiCloud()
            }
        }
    }
    
    // 静默模式
    var isSilentMode = false  {
        didSet {
            if isSilentMode != oldValue {
                UserDefaults.standard.set(isSilentMode, forKey: "isSilentMode")
                syncToiCloud()
            }
        }
    }
    
    // 货币符号
    var CurrencySymbol = "USD" {
        didSet {
            if CurrencySymbol != oldValue {
                UserDefaults.standard.set(CurrencySymbol, forKey: "CurrencySymbol")
                syncToiCloud()
            }
        }
    }
    
    // 存钱罐首页显示样式，为true则显示已存入的金额
    var SwitchTopStyle: Bool = false  {
        didSet {
            if SwitchTopStyle != oldValue {
                UserDefaults.standard.set(SwitchTopStyle, forKey: "SwitchTopStyle")
                syncToiCloud()
            }
        }
    }
    
    // 请求评分
    var RatingClicks: Int = 0  {
        didSet {
            if RatingClicks != oldValue {
                UserDefaults.standard.set(RatingClicks, forKey: "RatingClicks")
                syncToiCloud()
            }
        }
    }
    
    /// 内购完成后，设置为true，@AppStorage("20240523")
    var isInAppPurchase = false {
        didSet {
            if isInAppPurchase != oldValue {
                UserDefaults.standard.set(isInAppPurchase, forKey: "20240523")
                syncToiCloud()
            }
        }
    }
    
    // false表示隐藏
    var isShowAboutUs = true  {
        didSet {
            if isShowAboutUs != oldValue {
                UserDefaults.standard.set(isShowAboutUs, forKey: "isShowAboutUs")
                syncToiCloud()
            }
        }
    }
    
    // 控制内购按钮，false表示隐藏
    var isShowInAppPurchase = true  {
        didSet {
            if isShowInAppPurchase != oldValue {
                UserDefaults.standard.set(isShowInAppPurchase, forKey: "isShowInAppPurchase")
                syncToiCloud()
            }
        }
    }
    
    // 控制鸣谢页面，false表示隐藏
    var isShowThanks = true {
        didSet {
            if isShowThanks != oldValue {
                UserDefaults.standard.set(isShowThanks, forKey: "isShowThanks")
                syncToiCloud()
            }
        }
    }
    
    // ModelConfig配置
    var isModelConfigManager = true {
        didSet {
            if isModelConfigManager != oldValue {
                UserDefaults.standard.set(isModelConfigManager, forKey: "isModelConfigManager")
                syncToiCloud()
            }
        }
    }
    
    // 提醒时间，设置提醒时间为true，否则为false
    var isReminderTime = false {
        didSet {
            if isReminderTime != oldValue {
                UserDefaults.standard.set(isReminderTime, forKey: "isReminderTime")
                syncToiCloud()
            }
        }
    }
    
    // 存储用户设定的提醒时间
    var reminderTime: Double = Date().timeIntervalSince1970 {
        didSet {
            if reminderTime != oldValue {
                UserDefaults.standard.set(reminderTime, forKey: "reminderTime")
                syncToiCloud()
            }
        }
    }
    
    // 存取信息的存取备注
    var accessNotes = false {
        didSet {
            if accessNotes != oldValue {
                UserDefaults.standard.set(accessNotes, forKey: "accessNotes")
                syncToiCloud()
            }
        }
    }
    
    // 从UserDefaults加载数据
    private func loadUserDefault() {
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
        isModelConfigManager = UserDefaults.standard.bool(forKey: "isModelConfigManager")  // ModelConfig配置
        isReminderTime = UserDefaults.standard.bool(forKey: "isReminderTime")  // 提醒时间，设置提醒时间为true，否则为false
        reminderTime = UserDefaults.standard.double(forKey: "reminderTime") // 存储用户设定的提醒时间
        accessNotes = UserDefaults.standard.bool(forKey: "accessNotes")  // 存取备注
    }
    
    /// 从 iCloud 读取数据
    private func loadFromiCloud() {
        let store = NSUbiquitousKeyValueStore.default
        print("从iCloud读取数据")

        // 读取整数值
        if let storedPageSteps = store.object(forKey: "pageSteps") as? Int {
            pageSteps = storedPageSteps
        } else {
            store.set(pageSteps, forKey: "pageSteps")
        }
        
        if let storedRatingClicks = store.object(forKey: "RatingClicks") as? Int {
            RatingClicks = storedRatingClicks
        } else {
            store.set(RatingClicks, forKey: "RatingClicks")
        }

        // 读取双精度值
        if store.object(forKey: "reminderTime") != nil {
            reminderTime = store.double(forKey: "reminderTime")
        } else {
            store.set(reminderTime, forKey: "reminderTime")
        }
        
        // 读取布尔值
        if store.object(forKey: "isBiometricEnabled") != nil {
            isBiometricEnabled = store.bool(forKey: "isBiometricEnabled")
        } else {
            store.set(isBiometricEnabled, forKey: "isBiometricEnabled")
        }
        
        if store.object(forKey: "isLoopAnimation") != nil {
            isLoopAnimation = store.bool(forKey: "isLoopAnimation")
        } else {
            store.set(isLoopAnimation, forKey: "isLoopAnimation")
        }
        
        if store.object(forKey: "isSilentMode") != nil {
            isSilentMode = store.bool(forKey: "isSilentMode")
        } else {
            store.set(isSilentMode, forKey: "isSilentMode")
        }
        
        if store.object(forKey: "SwitchTopStyle") != nil {
            SwitchTopStyle = store.bool(forKey: "SwitchTopStyle")
        } else {
            store.set(SwitchTopStyle, forKey: "SwitchTopStyle")
        }
        
        if store.object(forKey: "20240523") != nil {
            isInAppPurchase = store.bool(forKey: "20240523")
        } else {
            store.set(isInAppPurchase, forKey: "20240523")
        }
        
        if store.object(forKey: "isShowAboutUs") != nil {
            isShowAboutUs = store.bool(forKey: "isShowAboutUs")
        } else {
            store.set(isShowAboutUs, forKey: "isShowAboutUs")
        }
        if store.object(forKey: "isShowInAppPurchase") != nil {
            isShowInAppPurchase = store.bool(forKey: "isShowInAppPurchase")
        } else {
            store.set(isShowInAppPurchase, forKey: "isShowInAppPurchase")
        }
        
        if store.object(forKey: "isShowThanks") != nil {
            isShowThanks = store.bool(forKey: "isShowThanks")
        } else {
            store.set(isShowThanks, forKey: "isShowThanks")
        }
        
        if store.object(forKey: "isModelConfigManager") != nil {
            isModelConfigManager = store.bool(forKey: "isModelConfigManager")
        } else {
            store.set(isModelConfigManager, forKey: "isModelConfigManager")
        }
        
        if store.object(forKey: "isReminderTime") != nil {
            isReminderTime = store.bool(forKey: "isReminderTime")
        } else {
            store.set(isReminderTime, forKey: "isReminderTime")
        }
        
        if store.object(forKey: "accessNotes") != nil {
            accessNotes = store.bool(forKey: "accessNotes")
        } else {
            store.set(accessNotes, forKey: "accessNotes")
        }

        // 读取字符串值
        if let storedBackgroundImage = store.string(forKey: "BackgroundImage") {
            BackgroundImage = storedBackgroundImage
        } else {
            store.set(BackgroundImage, forKey: "BackgroundImage")
        }
        
        if let storedLoopAnimation = store.string(forKey: "LoopAnimation") {
            LoopAnimation = storedLoopAnimation
        } else {
            store.set(LoopAnimation, forKey: "LoopAnimation")
        }
        
        if let storedCurrencySymbol = store.string(forKey: "CurrencySymbol") {
            CurrencySymbol = storedCurrencySymbol
        } else {
            store.set(CurrencySymbol, forKey: "CurrencySymbol")
        }

        print("完成 loadFromiCloud 方法的读取")
        print("pageSteps: \(pageSteps)")
        print("isBiometricEnabled: \(isBiometricEnabled)")
        print("BackgroundImage: \(BackgroundImage)")
        print("LoopAnimation: \(LoopAnimation)")
        print("isLoopAnimation: \(isLoopAnimation)")
        print("isSilentMode: \(isSilentMode)")
        print("CurrencySymbol: \(CurrencySymbol)")
        print("SwitchTopStyle: \(SwitchTopStyle)")
        print("RatingClicks: \(RatingClicks)")
        print("isInAppPurchase: \(isInAppPurchase)")
        print("isShowAboutUs: \(isShowAboutUs)")
        print("isShowInAppPurchase: \(isShowInAppPurchase)")
        print("isShowThanks: \(isShowThanks)")
        print("isModelConfigManager: \(isModelConfigManager)")
        print("isReminderTime:\(isReminderTime)")
        print("accessNotes:\(accessNotes)")
        store.synchronize() // 强制触发数据同步

    }
    
    /// 数据变化时，**同步到 iCloud**
    private func syncToiCloud() {
        let store = NSUbiquitousKeyValueStore.default
        store.set(pageSteps, forKey: "pageSteps")
        store.set(isBiometricEnabled, forKey: "isBiometricEnabled")
        store.set(BackgroundImage, forKey: "BackgroundImage")
        store.set(LoopAnimation, forKey: "LoopAnimation")
        store.set(isLoopAnimation, forKey: "isLoopAnimation")
        store.set(isSilentMode, forKey: "isSilentMode")
        store.set(CurrencySymbol, forKey: "CurrencySymbol")
        store.set(SwitchTopStyle, forKey: "SwitchTopStyle")
        store.set(RatingClicks, forKey: "RatingClicks")
        store.set(isInAppPurchase, forKey: "20240523")
        store.set(isShowAboutUs, forKey: "isShowAboutUs")
        store.set(isShowInAppPurchase, forKey: "isShowInAppPurchase")
        store.set(isShowThanks, forKey: "isShowThanks")
        store.set(isModelConfigManager, forKey: "isModelConfigManager")
        store.set(isReminderTime, forKey: "isReminderTime")
        store.set(reminderTime, forKey: "reminderTime")
        store.set(accessNotes, forKey: "accessNotes")
        store.synchronize() // 强制触发数据同步
    }
    
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
    
    /// 监听应用生命周期事件
    private func observeAppLifecycle() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    /// 当应用进入后台时，将数据同步到 iCloud
    @objc private func appWillResignActive() {
        print("应用进入后台，将本地数据同步到iCloud")
        syncToiCloud()
    }
    
    /// 防止内存泄漏
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
}
