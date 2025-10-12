//
//  ExtensionDouble.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/12.
//

import SwiftUI

extension Double {
    func formattedWithTwoDecimalPlaces() -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return Double(truncating: NSNumber(value: self))
    }
}
