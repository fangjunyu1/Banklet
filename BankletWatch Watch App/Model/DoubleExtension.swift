//
//  DoubleExtension.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/8.
//

import Foundation
extension Double {
    func formattedWithTwoDecimalPlaces() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}

func parseInput(_ input: String) -> Double {
    let sanitizedInput = input.replacingOccurrences(of: ",", with: "") // 移除分隔符
    return Double(sanitizedInput) ?? 0
}
