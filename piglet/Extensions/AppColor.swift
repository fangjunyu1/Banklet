//
//  Color.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/18.
//

import SwiftUI

enum AppColor {
    // 默认背景颜色
    static let defaultBackground = Color("defaultBackground")
    // 反向背景颜色
    static let inverseBackground = Color("inverseBackground")
    
    // 绿色
    static let green = Color("green")
    
    // 灰色
    static let gray = Color("gray")
    static let lightGray = Color("lightGray")
    static let darkGray = Color("darkGray")
    
    // 历史应用颜色
    static let appColor = Color(hex: "216DFA")  // 系统颜色，参考图标
    static let appBgGrayColor = Color(hex: "EEEEEE")    // 适用于背景的灰色，浅灰
    static let appGrayColor = Color(hex: "2F2F2F")  // 适用于深色模式按钮的浅灰，深灰
    static let red = Color(hex: "E64E5A")  // 深红
    
    static let bankList: [Color] = [
        .blue,.orange,.red,.green,.mint,.purple
    ]
}
