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
        "wrench.and.screwdriver": "repairtools",
        // 画笔 -> 绘画
        "paintbrush.pointed": "art",
        // 毕业帽，书籍 -> 课程
        "graduationcap" : "book",  // 毕业帽
        "books.vertical": "book",  // 书籍
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
        // T恤衫、铅笔，建筑，玩具，鱼，鸟，兔子，乌龟，爬虫 -> 存钱罐
        // 树，包，鞋子，床，煎锅，刀叉，礼花，键盘，火车 -> 存钱罐
        // 游戏手柄，人生存钱罐（旧图标），Apple 图标 -> 存钱罐
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
        "fish": "piggybank", // 鱼
        "bird": "piggybank", // 鸟
        "hare": "piggybank", // 兔子
        "tortoise": "piggybank", // 乌龟
        "ant": "piggybank",  // 蚂蚁
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
//        let result = mappingMattingName[name]
//        return result ?? name
    }
    
    // 未来考虑增加商铺、电车、工厂
    static let list: [String] = [
        "piggybank",   // 存钱罐
        "guitar",   // 吉他
        "piano",    // 钢琴
        "tv",   // 电视
        "watch",    // 手表
        "macbook",  // MacBook（笔记本）
        "pc",   // 电脑（主机）
        "macmini",  // Mac Mini
        "ipad", // 平板
        "iphone",  // iPhone
        "iphoneduo",    // iPhone Duo
        "applewatch",   // Watch
        "camera",   // 照相机
        "lens", // 镜头
        "drones",   // 无人机
        "pocketcamera", // 口袋云台相机
        "actioncamera", // 运动相机
        "vrheadset", // VR 头显
        "headphones",   // 耳机（头戴式）
        "airpodspro",   // AirPods Pro（入耳式）
        "ps5",  // PS5（游戏机）
        "switch2",   // Switch2（游戏机）
        "graphicscard", // 显卡
        "animefigurines",   // 手办（二次元）
        "speakers", // 音箱
        "projector",    // 投影仪
        "robotvacuumcleaner",  // 扫地机器人
        "refrigerator", // 冰箱
        "washingmachine",   // 洗衣机
        "airconditioner",   // 空调
        "glasses",  // 眼镜
        "airplane", // 飞机
        "boat",    // 游艇
        // MARK: 车辆
        "sportscar",    // 跑车
        "rv",    // 房车
        "car",  // 汽车
        "motorcycle",   // 摩托车
        "electricMoped",  // 电瓶车
        "electricKickScooter",  // 电动滑板车
        "bicycle",  // 自行车
        "sofa", // 沙发
        "villa",    // 别墅
        "apartment",    // 楼房
        "stroller", // 婴儿车
        "suitcase", // 旅行/旅游箱
        "goldjewelry",     // 黄金首饰
        "ring",   // 戒指
        "mountain",   // 登山
        "dog",  // 狗
        "cat",  // 猫
        "makeup",   // 化妆品
        "handbag",  // 手提包
        "camping",  // 野营
        "repairtools",   // 维修工具
        "art",   // 绘画
        "book",    // 书籍
        "birthday",    // 生日
    ]
}
