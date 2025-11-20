//
//  HomeSettingsEnum.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/4.
//

import SwiftUI

enum HomeSettingsEnum {
    case toggle(Binding<Bool>, ModelConfigManager)
    case binding(Binding<Bool>)
    case reminder(Binding<Bool>)
    case premium
    case remark(String)
    case none
}

enum HomeSettingsIconEnum {
    case sficon(String)
    case img(String)
}

enum HomeSettingsColorEnum {
    case color(String)
    case line(String,String)
}
