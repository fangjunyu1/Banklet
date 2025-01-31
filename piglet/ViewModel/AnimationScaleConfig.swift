//
//  AnimationScaleConfig .swift
//  piglet
//
//  Created by 方君宇 on 2025/1/29.
//

import SwiftUI

struct AnimationScaleConfig {
    static let animationScaleMap: [String: CGFloat] = [
        "Home0": 2.0,    // 存钱罐
        "Home1": 1.0,   // 宝箱
        "Home2": 1.0,   // 紫色花
        "Home3": 1.0,   // 绿色花
        "Home4": 1.0,   // 绿色盆栽
        "Home5": 1.0,   // 幸运草
        "Home6": 1.0,   // 奶牛
        "Home7": 1.0,   // 恶霸狗
        "Home8": 1.0,   // 蓝色恐龙
        "Home9": 1.0,   // 粉色猫咪
        "Home10": 1.5,  // 花狗
        "Home11": 1.0,  // 深绿色猫咪
        "Home12": 1.0,  // 花猫
        "Home13": 1.0,  // 橘色狐狸
        "Home14": 1.0,  // 红色猫咪
        "Home15": 1.5,  // 卡通狗
        "Home16": 1.0,  // 摇头鸽子
        "Home17": 1.0,  // 蝴蝶
        "Home18": 1.0,  // 卡通狐狸
        "Home19": 1.0,  // 青色恐龙
        "Home20": 1.0,  // 卡通鹦鹉
        "Home21": 1.2,  // 灰色猫咪
        "Home22": 1.0,  // 骑驴的行人
        "Home23": 1.0,  // 上下蜜蜂
        "Home24": 1.0,  // 哈巴狗
        "Home25": 1.0,  // 卡通猫头鹰
        "Home26": 1.0,  // 三只猫头鹰
        "Home27": 1.0,  // 卡通老虎
        "Home28": 1.0,  // 锅和多个动物
        "Home29": 1.0,  // 卡通UFO
        "Home30": 1.2,  // 睡觉的熊猫
        "Home31": 1.0,  // 老鼠
        "Home32": 1.3,  // 摇尾巴的狗
        "Home33": 1.0,  // 圣诞树
        "Home34": 1.0,  // 翻滚的猫咪
        "Home35": 1.5,  // 跑车
        "Home36": 1.0,  // 火鸡
        "Home37": 1.0,  // 两个南瓜
        "Home38": 1.0,// 看球的猫咪
        "Home39": 1.0,  // 跳跃的南瓜
        "Home40": 1.0,  // 轿车
        "Home41": 1.5,  // 像素猫咪
        "Home42": 1.0,  // 唱歌的小鸟
        "Home43": 1.2,  // 旅行车
        "Home44": 1.0,  // 眨眼睛的鸟
        "Home45": 1.0,  // 戴帽子的云
        "Home46": 1.0,  // 骑行和飞行的女巫
        "Home47": 1.0,  // 面包机
        "Home48": 1.0,  // 跌倒的卡通熊
        "Home49": 1.0,  // 卡通飞机
        "Home50": 1.0,  // 黄色小人
        "Home51": 1.0,  // 灰色小人
        "Home52": 1.0,  // 女生
        "Home53": 1.0,  // 男生
    ]
    
    // 获取动画对应的缩放值，默认返回 1.0
    static func scale(for animationName: String) -> CGFloat {
        return animationScaleMap[animationName] ?? 1.0
    }
}
