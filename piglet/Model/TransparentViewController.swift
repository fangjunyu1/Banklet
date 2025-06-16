//
//  TransparentViewController.swift
//  piglet
//
//  Created by 方君宇 on 2025/6/16.
//
// 重写 UIView 的提示框代码

import SwiftUI

class TransparentViewController: UIViewController {
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent is UIAlertController {
            print("拦截了系统弹窗")
             dismiss(animated: false)
//            completion?()
        } else {
            super.present(viewControllerToPresent, animated: flag,completion: completion)
        }
    }
}
