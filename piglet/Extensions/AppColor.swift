//
//  Color.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/18.
//

import SwiftUI

enum AppColor {
    static let appColor = Color(hex: "216DFA")  // 系统颜色，参考图标
    static let appBgGrayColor = Color(hex: "EEEEEE")    // 适用于背景的灰色，浅灰
    static let gray = Color(hex: "888888")  // 中灰
    static let appGrayColor = Color(hex: "2F2F2F")  // 适用于深色模式按钮的浅灰，深灰
    static let red = Color(hex: "E64E5A")  // 深红
    static let green = Color(hex: "1CB02E")   // 深绿
    
    static let bankList: [Color] = [
        .blue,.orange,.red,.green,.mint,.purple
    ]
}
