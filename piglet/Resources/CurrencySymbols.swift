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
    
    // 当前货币符号
    // 针对特殊的 ALL 等货币符号，返回对应的货币文本
    static func currencySymbolText(currency: Currency) -> String {
        if currency.currencyAbbreviation == "ALLCurrency" {
            "ALL"
        } else {
            currency.currencyAbbreviation
        }
    }
    
    // 当前货币
    static var currencySymbol:String {
        currencySymbolList.first{ Currency.currencySymbolText(currency: $0) == AppStorageManager.shared.CurrencySymbol}?.currencySymbol ?? "$"
    }

    // 货币符号列表
    static let currencySymbolList: [Currency] = [
        // 阿联酋-迪拉姆
        Currency(currencyAbbreviation: "AED", currencySymbol: "د.إ"),
        // 澳大利亚-澳元
        Currency(currencyAbbreviation: "AUD", currencySymbol: "A$"),
        // 加拿大-加元
        Currency(currencyAbbreviation: "CAD", currencySymbol: "C$"),
        // 瑞士-瑞士法郎
        Currency(currencyAbbreviation: "CHF", currencySymbol: "Fr"),
        // 中国-人民币
        Currency(currencyAbbreviation: "CNY", currencySymbol: "¥"),
        // 丹麦-丹麦克朗
        Currency(currencyAbbreviation: "DKK", currencySymbol: "kr"),
        // 欧洲-欧元
        Currency(currencyAbbreviation: "EUR", currencySymbol: "€"),
        // 英国-英镑
        Currency(currencyAbbreviation: "GBP", currencySymbol: "£"),
        // 香港-港元
        Currency(currencyAbbreviation: "HKD", currencySymbol: "HK$"),
        // 匈牙利-匈牙利福林
        Currency(currencyAbbreviation: "HUF", currencySymbol: "Ft"),
        // 日本-日元
        Currency(currencyAbbreviation: "JPY", currencySymbol: "¥"),
        // 韩国-韩元
        Currency(currencyAbbreviation: "KRW", currencySymbol: "₩"),
        // 澳门-澳门元
        Currency(currencyAbbreviation: "MOP", currencySymbol: "MOP$"),
        // 墨西哥-墨西哥比索
        Currency(currencyAbbreviation: "MXN", currencySymbol: "MX$"),
        // 马来西亚-马来西亚林吉特
        Currency(currencyAbbreviation: "MYR", currencySymbol: "RM"),
        // 挪威-挪威克朗
        Currency(currencyAbbreviation: "NOK", currencySymbol: "kr"),
        // 新西兰-新西兰元
        Currency(currencyAbbreviation: "NZD", currencySymbol: "NZ$"),
        // 波兰-波兰兹罗提
        Currency(currencyAbbreviation: "PLN", currencySymbol: "zł"),
        // 俄罗斯-俄罗斯卢布
        Currency(currencyAbbreviation: "RUB", currencySymbol: "₽"),
        // 沙特-沙特里亚尔
        Currency(currencyAbbreviation: "SAR", currencySymbol: "SAR"),
        // 瑞典-瑞典克朗
        Currency(currencyAbbreviation: "SEK", currencySymbol: "kr"),
        // 新加坡-新加坡元
        Currency(currencyAbbreviation: "SGD", currencySymbol: "S$"),
        // 泰国-泰铢
        Currency(currencyAbbreviation: "THB", currencySymbol: "฿"),
        // 土耳其-土耳其里拉
        Currency(currencyAbbreviation: "TRY", currencySymbol: "₺"),
        // 美国-美元
        Currency(currencyAbbreviation: "USD", currencySymbol: "$"),
        // 南非-南非兰特
        Currency(currencyAbbreviation: "ZAR", currencySymbol: "R"),
        // 捷克-捷克克朗
        Currency(currencyAbbreviation: "CZK", currencySymbol: "Kč"),
        // 阿根廷-阿根廷比索
        Currency(currencyAbbreviation: "ARS", currencySymbol: "$"),
        // 印度-印度卢比
        Currency(currencyAbbreviation: "INR", currencySymbol: "₹"),
        // 以色列-以色列新谢克尔
        Currency(currencyAbbreviation: "ILS", currencySymbol: "₪"),
        // 乌克兰-乌克兰格里夫纳
        Currency(currencyAbbreviation: "UAH", currencySymbol: "₴"),
        // 罗马尼亚-罗马尼亚列伊
        Currency(currencyAbbreviation: "RON", currencySymbol: "lei"),
        // 巴西-巴西里亚尔
        Currency(currencyAbbreviation: "BRL", currencySymbol: "R$"),
        // 印尼-印尼盾
        Currency(currencyAbbreviation: "IDR", currencySymbol: "Rp"),
        // 越南-越南盾
        Currency(currencyAbbreviation: "VND", currencySymbol: "₫"),
        // 阿尔巴尼亚-阿尔巴尼亚列克
        Currency(currencyAbbreviation: "ALLCurrency", currencySymbol: "L"),
        // 阿塞拜疆-阿塞拜疆马纳特
        Currency(currencyAbbreviation: "AZN", currencySymbol: "₼"),
        // 孟加拉-孟加拉塔卡
        Currency(currencyAbbreviation: "BDT", currencySymbol: "৳"),
        // 保加利亚-保加利亚列弗
        Currency(currencyAbbreviation: "BGN", currencySymbol: "лв"),
        // 缅甸-缅元
        Currency(currencyAbbreviation: "MMK", currencySymbol: "Ks"),
        // 菲律宾-菲律宾比索
        Currency(currencyAbbreviation: "PHP", currencySymbol: "₱"),
        // 冰岛-冰岛克朗
        Currency(currencyAbbreviation: "ISK", currencySymbol: "kr"),
        // 哈萨克斯坦-哈萨克斯坦坚戈
        Currency(currencyAbbreviation: "KZT", currencySymbol: "₸"),
        // 柬埔寨-柬埔寨瑞尔
        Currency(currencyAbbreviation: "KHR", currencySymbol: "៛"),
        // 伊朗-伊朗里亚尔
        Currency(currencyAbbreviation: "IRR", currencySymbol: "﷼"),
        // 坦桑尼亚-坦桑尼亚先令
        Currency(currencyAbbreviation: "TZS", currencySymbol: "TSh"),
        // 巴基斯坦-巴基斯坦卢比
        Currency(currencyAbbreviation: "PKR", currencySymbol: "Rs"),
        // 乌兹别克斯坦-乌兹别克斯坦索姆
        Currency(currencyAbbreviation: "UZS", currencySymbol: "soʻm"),
    ]
}
