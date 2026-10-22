//
//  triggerNetworkRequest.swift
//  piglet
//
//  Created by 方君宇 on 2024/6/5.
//

import Foundation

func triggerNetworkRequest() {
    guard let url = URL(string: "https://www.apple.com") else { return }
    
    let task = URLSession.shared.dataTask(with: url) { _, _, error in
        if let error = error {
            print("网络请求失败：\(error.localizedDescription)")
        } else {
            print("网络请求成功")
        }
    }
    task.resume()
}
