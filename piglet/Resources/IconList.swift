//
//  IconList.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/19.
//
//  图标列表
//

enum IconList {
    // 适配图片名称
    static let mappingMattingName: [String: String] = [
        // 帐篷 -> 野营
        "tent": "camping",
        // 钢琴键 -> 钢琴
        "pianokeys": "piano",
        // 维修工具 -> 工具箱
        "wrench.and.screwdriver": "toolbox",
        // 画笔 -> 绘画
        "paintbrush.pointed": "painting",
        // 毕业帽，书籍 -> 课程
        "graduationcap" : "course",  // 毕业帽
        "books.vertical": "course",  // 书籍
        // 生日蛋糕 -> 生日
        "birthday.cake": "birthday",
        // 照片 -> 相机
        "photo": "camera",
        // iPhone
        "iphone.gen2": "iphone",
        // 电车 -> 火车
        "tram": "train", // 火车
        // 轮船 -> 船
        "ferry": "boat",    // 轮船
        // 旅行箱，地图 -> 旅行箱
        "suitcase.rolling": "suitcase",
        "map": "suitcase",
        // 王冠 -> 黄金
        "crown": "gold",
        // 双人 -> 戒指
        "figure.2.arms.open": "ring",
        // 山
        "mountain.2": "mountain",
        // 太阳，地球，邮件，方向箭头，列表，美元，苹果 -> 存钱罐
        // 灯泡，帆船，眼睛，礼物，爆米花，树叶，信用卡，奖杯 -> 存钱罐
        // 电影，工作，工作包，茶杯，马克杯，哑铃，骰子 -> 存钱罐
        // 足球，网球，听诊器，医疗包，背包，座椅，药丸  -> 存钱罐
        // T恤衫、铅笔，建筑，玩具，狗，猫，鱼，鸟，兔子，乌龟，爬虫 -> 存钱罐
        // 树，包，鞋子，床，煎锅，刀叉，礼花，键盘，火车 -> 存钱罐
        // 游戏手柄，人生存钱罐（旧图标） -> 存钱罐
        "sun.min": "piggybank",
        "globe": "piggybank",
        "envelope": "piggybank",
        "location": "piggybank",
        "list.bullet": "piggybank",
        "dollarsign": "piggybank",
        "apple.logo": "piggybank",
        "lightbulb.max": "piggybank",
        "heart": "piggybank",
        "sailboat": "piggybank",
        "eye": "piggybank",
        "gift": "piggybank",
        "popcorn": "piggybank",
        "leaf": "piggybank",
        "creditcard": "piggybank",
        "trophy": "piggybank",
        "film": "piggybank",
        "briefcase": "piggybank",
        "cup.and.saucer": "piggybank",
        "mug": "piggybank",
        "dumbbell": "piggybank",
        "die.face.3": "piggybank",
        "soccerball": "piggybank",
        "tennisball": "piggybank",
        "stethoscope": "piggybank",  // 听诊器
        "cross.case": "piggybank",    // 医疗包
        "backpack": "piggybank",
        "chair": "piggybank",
        "pills": "piggybank",
        "tshirt": "piggybank",   // T恤衫
        "pencil.tip": "piggybank", // 铅笔
        "building.2": "piggybank",   // 建筑，高楼大厦
        "teddybear": "piggybank",    // 泰迪熊
        "dog": "pet",  // 狗
        "cat": "pet",  // 猫
        "fish": "pet", // 鱼
        "bird": "pet", // 鸟
        "hare": "pet", // 兔子
        "tortoise": "pet", // 乌龟
        "ant": "pet",  // 蚂蚁
        "tree": "piggybank",
        "shoe": "piggybank", // 鞋子
        "bag": "piggybank",  // 包
        "bed.double": "piggybank",    // 床
        "frying.pan": "piggybank",
        "fork.knife": "piggybank",
        "party.popper": "piggybank",    // 礼花
        "keyboard": "piggybank", // 键盘
        "train": "piggybank", // 火车
        "gamecontroller": "piggybank",   // 游戏手柄
        "person.fill": "piggybank", // 人生存钱罐（旧图标）
    ]
    
    // 适配旧版本的图标，将旧的图标映射为新的贴图
    static func getTextureName(name: String) -> String {
        // 如果可以在匹配列表中找到贴图，返回对应的贴图名称
        return mappingMattingName[name] ?? name
    }
    
    static let list: [String] = [
        "camping",  // 野营
        "guitar",   // 吉他
        "piano",    // 钢琴
        "toolbox",   // 工具箱
        "painting",   // 绘画
        "course",    // 课程
        "birthday",    // 生日
        "tv",   // 电视
        "watch",    // 手表
        "macbook",  // MacBook（笔记本）
        "pc",   // 电脑（主机）
        "ipad", // 平板
        "iphone",  // iPhone
        "applewatch",   // Watch
        "camera",   // 照相机
        "lens", // 镜头
        "drones",   // 无人机
        "vrheadset", // VR 头显
        "headphones",   // 耳机（头戴式）
        "airpodspro",   // AirPods Pro（入耳式）
        "ps4",  // PS4（游戏机）
        "switch",   // Switch（游戏机）
        "graphicscard", // 显卡
        "animefigurines",   // 手办（二次元）
        "speakers", // 音箱
        "projector",    // 投影仪
        "robotvacuum",  // 扫地机器人
        "refrigerator", // 冰箱
        "washingmachine",   // 洗衣机
        "airconditioner",   // 空调
        "glasses",  // 眼镜
        "airplane", // 飞机
        "boat",    // 游艇
        "car",  // 汽车
        "motorcycle",   // 摩托车
        "rv",    // 房车
        "electricvehicles",  // 电动车
        "bicycle",  // 自行车
        "sofa", // 沙发
        "house",    // 房子
        "stroller", // 婴儿车
        "suitcase", // 旅行/旅游箱
        "gold",     // 黄金
        "ring",   // 戒指
        "mountain",   // 登山
        "piggybank",   // 存钱罐
        "pet",  // 宠物（猫和狗）
    ]
}
