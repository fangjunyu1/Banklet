//
//  HomeSettingRow.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/5.
//

import SwiftUI

// 设置视图
struct HomeSettingRow: View {
    var color: HomeSettingsColorEnum
    var icon: HomeSettingsIconEnum
    var title: String
    var footnote: String?
    let accessory: HomeSettingsEnum
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    ColorView(color:color)
                    iconView(icon: icon)
                    
                }
                .padding(.trailing,10)
                Text(LocalizedStringKey(title))
                    .foregroundColor(.black)
                Spacer()
                accessoryView(accessory:accessory)
            }
            .padding(.vertical,10)
            .padding(.horizontal,14)
            .background(.white)
            .cornerRadius(10)
            if let footnote = footnote {
                HStack {
                    Text(LocalizedStringKey(footnote))
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
        }
    }
}

// 设置 - 高级会员视图
struct HomeSettingPremiumRow: View {
    var color: HomeSettingsColorEnum
    var icon: HomeSettingsIconEnum
    var title: String
    let date = Date(timeIntervalSince1970: AppStorageManager.shared.expirationDate)
    let isLifetime = AppStorageManager.shared.isLifetime
    let isValidMember = AppStorageManager.shared.isValidMember
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack {
            HStack {
                // 图标
                if isValidMember {
                        Image(systemName: "checkmark.seal.fill")
                        .imageScale(.large)
                            .foregroundColor(.white)
                            .frame(width: 40,height: 30)
                } else {
                    ZStack {
                        ColorView(color:color)
                        iconView(icon: icon)
                    }
                    .padding(.trailing,10)
                }
                Text(LocalizedStringKey(title))
                    .foregroundColor(isValidMember ? .white : .black)
                Spacer()
                if isLifetime {
                    Text("Permanently valid")
                        .font(.footnote)
                        .foregroundColor(.white)
                } else if isValidMember {
                    VStack(alignment:.trailing, spacing:3) {
                        // 到期时间
                        Text("Expiry date")
                        Text(formattedDate(date))
                    }
                    .font(.caption2)
                    .foregroundColor(.white)
                }
                Image(systemName:"chevron.right")
                    .foregroundColor(isValidMember ? .white : .black)
            }
            .padding(.vertical,10)
            .padding(.horizontal,14)
            .background(isValidMember ? AppColor.appColor : .white)
            .cornerRadius(10)
        }
    }
}

// 设置 - 无图标的视图，用于动画、背景
struct HomeSettingNoIconRow: View {
    var title: String
    var footnote: String?
    let accessory: HomeSettingsEnum
    
    var body: some View {
        VStack {
            HStack {
                Text(LocalizedStringKey(title))
                    .foregroundColor(.black)
                Spacer()
                accessoryView(accessory:accessory)
            }
            .padding(.vertical,10)
            .padding(.horizontal,14)
            .background(.white)
            .cornerRadius(10)
            if let footnote = footnote {
                HStack {
                    Text(LocalizedStringKey(footnote))
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
        }
        .padding(10)
    }
}

// 静默模式
struct GeneralSilentRow: View {
    var title: String
    var footnote: String?
    @Binding var mode: Bool
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 30,height: 30)
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    Image("Silent")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(mode ? .white : .black)
                }
                .padding(.trailing,10)
                Text(LocalizedStringKey(title))
                    .foregroundColor(mode ? .white : .black)
                Spacer()
                Toggle("", isOn: $mode)
            }
            .padding(.vertical,10)
            .padding(.horizontal,14)
            .background(mode ? Color(hex: "53ad43") : .white)
            .cornerRadius(10)
            if let footnote = footnote {
                HStack {
                    Text(LocalizedStringKey(footnote))
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
        }
    }
}

private struct accessoryView: View {
    let accessory: HomeSettingsEnum
    var body: some View {
        switch accessory {
        case .toggle(let isOn, let manager):
            Toggle("", isOn: isOn.animation(.easeInOut))
                .onChange(of: isOn.wrappedValue) { _, newValue in
                    manager.cloudKitMode = newValue ? .privateDatabase : .none
                    DataController.shared.updateContainer() // 更新容器
                }
        case .binding(let isOn):
            Toggle("", isOn: isOn.animation(.easeInOut))
        case .reminder(let notice):
            reminderTime(notice: notice)
        case .premium:
            Image(systemName:"chevron.right")
                .foregroundColor(.black)
        case .remark(let remark):
            Text(LocalizedStringKey(remark))
                .foregroundColor(AppColor.gray)
            Image(systemName:"chevron.right")
                .foregroundColor(.black)
        case .none:
            Image(systemName:"chevron.right")
                .foregroundColor(.black)
        }
    }
}


private struct iconView: View {
    var icon: HomeSettingsIconEnum
    var body: some View {
        switch icon {
        case .img(let icon):
            Image(icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 18)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.white)
        case .sficon(let icon):
            Image(systemName: icon)
                .imageScale(.small)
                .foregroundColor(.white)
        }
    }
}

private struct ColorView: View {
    var color: HomeSettingsColorEnum
    var body: some View {
        switch color {
        case .color(let col):
            Rectangle()
                .foregroundColor(Color(hex: col))
                .frame(width: 30,height: 30)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(10)
        case .line(let col1, let col2):
            Rectangle()
                .fill (
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: col1), Color(hex: col2)]), // 渐变的颜色
                        startPoint: .topLeading, // 渐变的起始点
                        endPoint: .bottomTrailing // 渐变的结束点
                    )
                )
                .frame(width: 30,height: 30)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(10)
        }
    }
}

// 提醒时间
private struct reminderTime: View {
    @EnvironmentObject var appStorage: AppStorageManager
    @Binding var notice: Bool
    var body: some View {
        HStack {
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
            Toggle("", isOn:$appStorage.isReminderTime)
                .onChange(of: appStorage.isReminderTime) { _, newValue in
                    if newValue {
                        // 检查权限，首次弹出消息提示
                        requestNotificationPermission()
                    } else {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        print("所有未触发的通知已清除")
                        appStorage.isReminderTime = false
                    }
                }
                .frame(width:70, height:0)
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
                        notice = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation(.easeInOut(duration: 1)){
                            notice = false
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
}
