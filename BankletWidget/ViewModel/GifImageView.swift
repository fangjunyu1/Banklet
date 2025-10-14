//
//  GifImageView.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/13.
//

import SwiftUI
import ClockHandRotationKit

struct GifImageView: View {
    var gifName: String // Bundle中 gif图片的名称
    
    func getGif(_ name: String) -> UIImage.GifResult? {
        print("name:\(name)")
        
        guard let path = Bundle.main.path(forResource: "gif_\(name)", ofType: "gif"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("未找到该数据")
            return nil
        }
        return UIImage.decodeGIF(data)
    }
    
    var body: some View {
        if let gif = getGif(gifName) {
            GeometryReader { proxy in
                let width = proxy.size.width
                let height = proxy.size.height
                
                let arcWidth = max(width, height)
                let arcRadius = arcWidth * arcWidth
                let angle = 360.0 / Double(gif.images.count)
                
                ZStack {
                    ForEach(1...gif.images.count, id: \.self) { index in
                        Image(uiImage: gif.images[(gif.images.count - 1) - (index - 1)])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, minHeight: 0)
                            .mask(
                                ArcView(arcStartAngle: angle * Double(index - 1),
                                        arcEndAngle: angle * Double(index),
                                        arcRadius: arcRadius)
                                .stroke(style: .init(lineWidth: arcWidth * 1.1, lineCap: .square, lineJoin: .miter))
                                .frame(width: width, height: height)
                                .clockHandRotationEffect(period: .custom(gif.duration))
                                .offset(y: arcRadius) // ⚠️ 需要先进行旋转，再设置offset
                            )
                    }
                }
                .frame(width: width, height: height)
            }
        } else {
            // 如果没有图片，显示空白占位符
            Image("png_Home0")
                .resizable()
        }
    }
}
