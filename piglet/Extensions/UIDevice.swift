//
//  UIDevice.swift
//  piglet
//
//  Created by 方君宇 on 2026/6/2.
//

import UIKit

extension UIDevice {
    static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
