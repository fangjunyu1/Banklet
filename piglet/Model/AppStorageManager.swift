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
    
    var pageSteps: Int = 1  // 视图步骤
    var isBiometricEnabled: Bool = false    // 密码保护
    var BackgroundImage = "" // 背景照片
    var LoopAnimation = "Home0" // Lottie动画
    var isLoopAnimation = false // 循环动画
    var isSilentMode = false    // 静默模式
    var CurrencySymbol = "USD"  // 货币符号
    var SwitchTopStyle: Bool = false    // 存钱罐首页显示样式，为true则显示已存入的金额
    var RatingClicks: Int = 0   // 请求评分
    var isInAppPurchase = false /// 内购完成后，设置为true，@AppStorage("20240523")
    var isShowAboutUs = true   // false表示隐藏
    var isShowInAppPurchase = true   // 控制内购按钮，false表示隐藏
    var isShowThanks = true // 控制鸣谢页面，false表示隐藏
    var isModelConfigManager = true // ModelConfig配置
    var isReminderTime = false  // 提醒时间，设置提醒时间为true，否则为false
    var reminderTime: Double = Date().timeIntervalSince1970 // 存储用户设定的提醒时间
    
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
    }
    
    /// 从 iCloud 读取数据
    private func loadFromiCloud() {
        let store = NSUbiquitousKeyValueStore.default
        print("从iCloud读取数据")

        // 读取整数值
        if let storedPageSteps = store.object(forKey: "pageSteps") as? Int {
            pageSteps = storedPageSteps
        }
        if let storedRatingClicks = store.object(forKey: "RatingClicks") as? Int {
            RatingClicks = storedRatingClicks
        }

        // 读取双精度值
        if store.object(forKey: "reminderTime") != nil {
            reminderTime = store.double(forKey: "reminderTime")
        }
        
        // 读取布尔值
        if store.object(forKey: "isBiometricEnabled") != nil {
            isBiometricEnabled = store.bool(forKey: "isBiometricEnabled")
        }
        if store.object(forKey: "isLoopAnimation") != nil {
            isLoopAnimation = store.bool(forKey: "isLoopAnimation")
        }
        if store.object(forKey: "isSilentMode") != nil {
            isSilentMode = store.bool(forKey: "isSilentMode")
        }
        if store.object(forKey: "SwitchTopStyle") != nil {
            SwitchTopStyle = store.bool(forKey: "SwitchTopStyle")
        }
        if store.object(forKey: "20240523") != nil {
            isInAppPurchase = store.bool(forKey: "20240523")
        }
        if store.object(forKey: "isShowAboutUs") != nil {
            isShowAboutUs = store.bool(forKey: "isShowAboutUs")
        }
        if store.object(forKey: "isShowInAppPurchase") != nil {
            isShowInAppPurchase = store.bool(forKey: "isShowInAppPurchase")
        }
        if store.object(forKey: "isShowThanks") != nil {
            isShowThanks = store.bool(forKey: "isShowThanks")
        }
        if store.object(forKey: "isModelConfigManager") != nil {
            isModelConfigManager = store.bool(forKey: "isModelConfigManager")
        }
        if store.object(forKey: "isReminderTime") != nil {
            isReminderTime = store.bool(forKey: "isReminderTime")
        }

        // 读取字符串值
        if let storedBackgroundImage = store.string(forKey: "BackgroundImage") {
            BackgroundImage = storedBackgroundImage
        }
        if let storedLoopAnimation = store.string(forKey: "LoopAnimation") {
            LoopAnimation = storedLoopAnimation
        }
        if let storedCurrencySymbol = store.string(forKey: "CurrencySymbol") {
            CurrencySymbol = storedCurrencySymbol
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
