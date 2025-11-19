//
//  GIFView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/9.
//

import SwiftUI
import WebKit

struct GIFView: UIViewRepresentable {
    let gifName: String  // 文件名或 URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .clear
        webView.isOpaque = false

        if let path = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let url = URL(fileURLWithPath: path)
            let data = try? Data(contentsOf: url)
            webView.load(data!, mimeType: "image/gif", characterEncodingName: "utf-8", baseURL: url.deletingLastPathComponent())
        } else if let url = URL(string: gifName) {
            webView.load(URLRequest(url: url))
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
