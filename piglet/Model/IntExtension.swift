//
//  IntExtension.swift
//  piglet
//
//  Created by 方君宇 on 2025/3/24.
//

import Foundation
extension Int {
    func formattedWithTwoDecimalPlaces() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
//        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
