//
//  CurrencySymbols.swift
//  piglet
//
//  Created by 方君宇 on 2025/2/10.
//

import Foundation

// 货币符号数据模型
struct Currency: Hashable {
    var currencyAbbreviation: String
    var currencySymbol: String
}

// 货币符号列表
let currencySymbolList: [Currency] = [
    // 阿联酋-迪拉姆
    Currency(currencyAbbreviation:"AED", currencySymbol: "د.إ"),
    // 澳大利亚-澳元
    Currency(currencyAbbreviation:"AUD", currencySymbol: "A$"),
    // 加拿大-加元
    Currency(currencyAbbreviation:"CAD", currencySymbol: "C$"),
    // 瑞士-瑞士法郎
    Currency(currencyAbbreviation:"CHF", currencySymbol: "Fr"),
    // 中国-人民币
    Currency(currencyAbbreviation:"CNY", currencySymbol: "¥"),
    // 丹麦-丹麦克朗
    Currency(currencyAbbreviation:"DKK", currencySymbol: "kr"),
    // 欧洲-欧元
    Currency(currencyAbbreviation:"EUR", currencySymbol: "€"),
    // 英国-英镑
    Currency(currencyAbbreviation:"GBP", currencySymbol: "£"),
    // 香港-港元
    Currency(currencyAbbreviation:"HKD", currencySymbol: "HK$"),
    // 匈牙利-匈牙利福林
    Currency(currencyAbbreviation:"HUF", currencySymbol: "Ft"),
    // 日本-日元
    Currency(currencyAbbreviation:"JPY", currencySymbol: "¥"),
    // 韩国-韩元
    Currency(currencyAbbreviation:"KRW", currencySymbol: "₩"),
    // 澳门-澳门元
    Currency(currencyAbbreviation:"MOP", currencySymbol: "MOP$"),
    // 墨西哥-墨西哥比索
    Currency(currencyAbbreviation:"MXN", currencySymbol: "MX$"),
    // 马来西亚-马来西亚林吉特
    Currency(currencyAbbreviation:"MYR", currencySymbol: "RM"),
    // 挪威-挪威克朗
    Currency(currencyAbbreviation:"NOK", currencySymbol: "kr"),
    // 新西兰-新西兰元
    Currency(currencyAbbreviation:"NZD", currencySymbol: "NZ$"),
    // 波兰-波兰兹罗提
    Currency(currencyAbbreviation:"PLN", currencySymbol: "zł"),
    // 俄罗斯-俄罗斯卢布
    Currency(currencyAbbreviation:"RUB", currencySymbol: "₽"),
    // 沙特-沙特里亚尔
    Currency(currencyAbbreviation:"SAR", currencySymbol: "SAR"),
    // 瑞典-瑞典克朗
    Currency(currencyAbbreviation:"SEK", currencySymbol: "kr"),
    // 新加坡-新加坡元
    Currency(currencyAbbreviation:"SGD", currencySymbol: "S$"),
    // 泰国-泰铢
    Currency(currencyAbbreviation:"THB", currencySymbol: "฿"),
    // 土耳其-土耳其里拉
    Currency(currencyAbbreviation:"TRY", currencySymbol: "₺"),
    // 美国-美元
    Currency(currencyAbbreviation:"USD", currencySymbol: "$"),
    // 南非-南非兰特
    Currency(currencyAbbreviation:"ZAR", currencySymbol: "R"),
    // 捷克-捷克克朗
    Currency(currencyAbbreviation:"CZK", currencySymbol: "Kč"),
    // 阿根廷-阿根廷比索
    Currency(currencyAbbreviation:"ARS", currencySymbol: "$"),
    // 印度-印度卢比
    Currency(currencyAbbreviation:"INR", currencySymbol: "₹"),
    // 以色列-以色列新谢克尔
    Currency(currencyAbbreviation:"ILS", currencySymbol: "₪"),
    // 乌克兰-乌克兰格里夫纳
    Currency(currencyAbbreviation:"UAH", currencySymbol: "₴"),
    // 罗马尼亚-罗马尼亚列伊
    Currency(currencyAbbreviation:"RON", currencySymbol: "lei"),
    // 巴西-巴西里亚尔
    Currency(currencyAbbreviation:"BRL", currencySymbol: "R$"),
    // 印尼-印尼盾
    Currency(currencyAbbreviation:"IDR", currencySymbol: "Rp"),
    // 越南-越南盾
    Currency(currencyAbbreviation:"VND", currencySymbol: "₫")
]
