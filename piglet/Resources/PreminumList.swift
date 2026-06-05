//
//  PreminumList.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/10.
//
// 会员视图信息

import SwiftUI

struct PreminumModel: Hashable {
    var imgName: String
    var imgModel: PreminumImgModel
    var color: Color
    var text: String
    var info: String
}

enum PreminumImgModel {
    case img
    case sf
}

let PreminumList: [PreminumModel] = [
    // 桌面图标
    PreminumModel(imgName: "icon", imgModel: .img,color: AppColor.appColor, text: "Desktop Icons", info: "Unlock 30+ personalized icons, switch them as you like, and define your app's unique look."),
    // 会员动画
    PreminumModel(imgName: "Animation", imgModel: .img,color: AppColor.appColor, text: "Member Animations", info: "Enjoy exclusive animation effects to make the savings process smoother and more engaging."),
    // 背景图片
    PreminumModel(imgName: "Background", imgModel: .img,color: AppColor.appColor, text: "Background Images", info: "A variety of solid color backgrounds ensure a fresh experience every time you open the app."),
    // 小组件扩展
    PreminumModel(imgName: "Widget", imgModel: .img,color: AppColor.appColor, text: "Widget Extensions", info: "Desktop widgets have been fully upgraded, supporting transparent and dynamic styles, and updating in sync with the app."),
    // 持续更新
    PreminumModel(imgName: "square.stack.3d.up.fill", imgModel: .sf,color: AppColor.appColor, text: "Continuously updated", info: "The premium version continues to expand its features, unlocking more experiences such as music and events in the future.")
]
