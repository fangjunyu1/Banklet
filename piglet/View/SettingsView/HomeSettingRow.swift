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
                        .font(.caption2)
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
            Toggle("", isOn: isOn)
                .onChange(of: isOn.wrappedValue) { _, newValue in
                    manager.cloudKitMode = newValue ? .privateDatabase : .none
                }
        case .binding(let isOn):
            Toggle("", isOn: isOn)
            Image(systemName:"chevron.right")
                .foregroundColor(.black)
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
