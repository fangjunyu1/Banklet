//
//  SafariView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/7.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    var entersReaderIfAvailable: Bool = false
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        // 创建 Configuration
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = entersReaderIfAvailable
        // 创建 Safari 控制器
        let safariVC = SFSafariViewController(url: url, configuration: config)
        return safariVC
    }
    
    func updateUIViewController(_ vc: SFSafariViewController, context: Context) {}
}
