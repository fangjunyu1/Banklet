//
//  AnimatedImageView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/9.
//

import SwiftUI
import UIKit
import ImageIO

struct AnimatedImageView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        if let path = Bundle.main.path(forResource: gifName, ofType: "gif"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let source = CGImageSourceCreateWithData(data as CFData, nil) {
            var images: [UIImage] = []
            let count = CGImageSourceGetCount(source)
            for i in 0..<count {
                if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    images.append(UIImage(cgImage: cgImage))
                }
            }
            imageView.animationImages = images
            imageView.animationDuration = Double(count) / 20.0
            imageView.startAnimating()
        }
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}
}
