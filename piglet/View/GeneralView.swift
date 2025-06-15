//
//  GeneralView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/15.
//

import SwiftUI
import UserNotifications

struct GeneralView: View {
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
//    @AppStorage("isBiometricEnabled") var isBiometricEnabled = false
//    // 测试详细信息
//    //    @AppStorage("isTestDetails") var isTestDetails = false
//    @AppStorage("20240523") var isInAppPurchase = false // 内购完成后，设置为true
//    // 静默模式
//    @AppStorage("isSilentMode") var isSilentMode = false
//    // 提醒时间，设置提醒时间为true，否则为false
//    @AppStorage("isReminderTime") var isReminderTime = false
//    // 存储用户设定的提醒时间
//    @AppStorage("reminderTime") private var reminderTime: Double = Date().timeIntervalSince1970 // 以时间戳存储
    
    @State private var Notification = false
    // 授权通知
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("授权失败：\(error.localizedDescription)")
                // 如果授权失败，系统运行提醒权限设置为false
                // 授权失败场景可能不常见，更多的是根据granted判断授权成功/失败
            } else {
                print("授权结果：\(granted ? "允许" : "拒绝")")
                appStorage.isReminderTime = granted
                // 如果当前提示时间为false并且授权结构为false，弹出吐司提示，告知用户可能是通知未授权导致的问题
                if !appStorage.isReminderTime && !granted {
                    print("当前应用未授权通知功能")
                    withAnimation(.easeInOut(duration: 1)){
                        Notification = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation(.easeInOut(duration: 1)){
                            Notification = false
                        }
                    }
                    
                }
                if granted {
                    // 清除所有通知
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    print("所有未触发的通知已清除")
                    
                    // 如果授权成功，执行调度本地通知的命令
                    scheduleLocalNotification()
                }
            }
        }
    }
    
    // 设置调度本地通知
    func scheduleLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Savings reminder", comment: "Title of the savings reminder notification")
        content.body = NSLocalizedString("Accumulate today and reap tomorrow.", comment: "Body text of the savings reminder notification")
        content.sound = .default
        
        // 创建日期和时间组件
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: Date(timeIntervalSince1970: appStorage.reminderTime))

        // 创建日期触发器
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // 创建通知请求
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // 将通知添加到通知中心
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知调度失败：\(error.localizedDescription)")
            } else {
                print("通知调度成功")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.95
                ZStack {
                    // 背景
                    Color(hex: colorScheme == .light ?  "f0f0f0" : "0E0E0E")
                        .ignoresSafeArea()
                    
                    // 设置列表
                    VStack {
                        ScrollView(showsIndicators: false) {
                            // 背景、动画和图标
                            Group {
                                VStack(spacing: 0) {
                                    NavigationLink(destination: MainInterfaceBackgroundView()){
                                        SettingView(content: {
                                            Image(systemName: "photo.artframe")
                                                .padding(.horizontal,5)
                                            Text("Background")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .imageScale(.small)
                                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                        })
                                    }
                                    // 分割线
                                    Divider().padding(.leading,50)
                                    // 主界面动画
                                    NavigationLink(destination:MainInterfaceAnimationView()){
                                        SettingView(content: {
                                            Image(systemName: "film.stack")
                                                .padding(.horizontal,5)
                                            Text("Animation")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .imageScale(.small)
                                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                        })
                                    }
                                    // 分割线
                                    Divider().padding(.leading,50)
                                    NavigationLink(destination: AppIconView()){
                                        SettingView(content: {
                                            Image(systemName: "photo.fill")
                                                .padding(.horizontal,5)
                                            Text("icon")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .imageScale(.small)
                                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                        })
                                    }
                                }
                                .background(colorScheme == .light ? .white : Color(hex:"1f1f1f"))
                                .cornerRadius(10)
                                .padding(10)
                            }
                            
                            // 静默模式
                            VStack {
                                HStack {
                                    Text("After waiting for 10 seconds, hide the main view buttons and only show the animation.")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                SilentModeView(content: {
                                    Image(systemName: "leaf")
                                        .padding(.horizontal,5)
                                    Text("Silent Mode")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Toggle("",isOn: Binding(get: {
                                        appStorage.isSilentMode
                                    }, set: {
                                        appStorage.isSilentMode = $0
                                    }))  // 测试功能，详细信息
                                        .frame(height:0)
                                })
                            }
                            .padding(10)
                            
                            // 货币符号
                            VStack {
                                NavigationLink(destination: CurrencySymbolView()){
                                    SettingView(content: {
                                        Image(systemName: "dollarsign")
                                            .padding(.horizontal,5)
                                        Text("Currency Symbol")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .imageScale(.small)
                                            .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                                    })
                                }
                            }
                            .padding(10)
                            
                            // 提醒时间、密码保护、存取备注和活动
                            VStack(spacing: 0) {
                                // 音效
                                SettingView(content: {
                                    Image(systemName: "music.quarternote.3")
                                        .padding(.horizontal,5)
                                    Text("Sound effects")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Toggle("",isOn: Binding(get: {
                                        appStorage.isSoundEffects
                                    }, set: {
                                        appStorage.isSoundEffects = $0
                                    }))  // iCloud开关
                                        .frame(height:0)
                                })
                                
                                // 分割线
                                Divider().padding(.leading,50)
                                
                                // 振动
                                SettingView(content: {
                                    Image(systemName: "bell.and.waves.left.and.right")
                                        .frame(width:24)
                                        .padding(.horizontal,5)
                                    Text("Vibration")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Toggle("",isOn: Binding(get: {
                                        appStorage.isVibration
                                    }, set: {
                                        appStorage.isVibration = $0
                                    }))  // iCloud开关
                                        .frame(height:0)
                                })
                                
                                // 分割线
                                Divider().padding(.leading,50)
                                
                                // 提醒时间
                                SettingView(content: {
                                    if appStorage.isReminderTime {
                                        Image(systemName: "bell.badge")
                                            .padding(.horizontal,5)
                                    } else {
                                        Image(systemName: "bell")
                                            .padding(.horizontal,5)
                                    }
                                    Text("Reminder time")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    if appStorage.isReminderTime {
                                        // 日期选择器
                                        DatePicker("",
                                                   selection: Binding(get: {
                                            Date(timeIntervalSince1970: appStorage.reminderTime)
                                        }, set: {
                                            appStorage.reminderTime = $0.timeIntervalSince1970
                                            // 选择日期后，更新调度通知
                                            scheduleLocalNotification()
                                        }),
                                                   displayedComponents: .hourAndMinute
                                        )
                                        .datePickerStyle(DefaultDatePickerStyle()) // 日期选择器样式
                                        .frame(width: 60,height: 0)
                                    }
                                    // 提示时间
                                    Toggle("",isOn: Binding (
                                        get: {
                                            appStorage.isReminderTime
                                        },
                                        set: { newValue in
                                            if newValue {
                                                // 检查权限，首次弹出消息提示
                                                requestNotificationPermission()
                                            } else {
                                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                                print("所有未触发的通知已清除")
                                                appStorage.isReminderTime = false
                                            }
                                        }
                                    ))  // 提醒时间
                                    .frame(width:70, height:0)
                                })
                                
                                // 分割线
                                Divider().padding(.leading,50)
                                // 人脸识别
                                SettingView(content: {
                                    Image(systemName: "faceid")
                                        .padding(.horizontal,5)
                                    Text("Password protection")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Toggle("",isOn: Binding(get: {
                                        appStorage.isBiometricEnabled
                                    }, set: {
                                        appStorage.isBiometricEnabled = $0
                                    }))  // iCloud开关
                                        .frame(height:0)
                                })
                                // 分割线
                                Divider().padding(.leading,50)
                                // 存取备注
                                SettingView(content: {
                                    Image(systemName: "list.clipboard")
                                        .padding(.horizontal,5)
                                    Text("Access Notes")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Toggle("",isOn: Binding(get: {
                                        appStorage.accessNotes
                                    }, set: {
                                        appStorage.accessNotes = $0
                                    })) 
                                        .frame(height:0)
                                })
                                // 分割线
                                Divider().padding(.leading,50)
                                // 活动
                                SettingView(content: {
                                    Image(systemName: "party.popper")
                                        .padding(.horizontal,5)
                                    Text("Activity")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Toggle("",isOn: Binding(get: {
                                        appStorage.isShowActivity
                                    }, set: {
                                        appStorage.isShowActivity = $0
                                    }))
                                        .frame(height:0)
                                })
                            }
                            .background(colorScheme == .light ? .white : Color(hex:"1f1f1f"))
                            .cornerRadius(10)
                            .padding(10)
                            
                            
                        }
                        
                    }
                    .frame(width: width)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .navigationTitle("General")
                    .navigationBarTitleDisplayMode(.inline)
                    // 无通知权限
                    VStack {
                        Spacer()
                        Text("No notification permission")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(.gray)
                            .cornerRadius(6)
                        Spacer().frame(height:40)
                    }
                    .opacity(Notification ? 1 : 0)
                }
            }
        }
        .onAppear {
            // 为了检查应用的权限是否在后台关闭
            // 调用消息授权方法重新校验，如果提醒时间字段为true
            if appStorage.isReminderTime {
                // 重新执行授权通知进行校验
                requestNotificationPermission()
            }
        }
    }
}


#Preview {
    GeneralView()
        .environment(AppStorageManager.shared)
    //        .environment(\.locale, .init(identifier: "de"))
}
