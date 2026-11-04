//
//  OutlinedImage.swift
//  piglet
//
//  Created by 方君宇 on 2026/10/31.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

struct OutlinedImageView: View {
    @Environment(\.self) private var environment
    
    let name: String
    let color: Color
    let radius: CGFloat
    
    init(name: String, color: Color, radius: CGFloat) {
        self.name = name
        self.color = color
        self.radius = radius
    }
    
    init(name: String) {
        self.name = name
        self.color = AppColor.defaultBackground
        self.radius = 50
    }
    
    private var outlinedImage: UIImage? {
        
        guard let image = UIImage(named: name) else {
            print("图片加载失败：\(name)")
            return nil
        }
        
        guard let ciImage = CIImage(
            image: image,
            options: [.applyOrientationProperty: true]
        ) else {
            print("CIImage 转换失败：\(name)")
            return nil
        }
        
        // 扩大画布，为描边预留空间
        let padding = ceil(radius) + 2
        let outputExtent = ciImage.extent.insetBy(
            dx: -padding,
            dy: -padding
        )
        
        // 提取 Alpha 通道，转换为灰度蒙版
        let alphaFilter = CIFilter.colorMatrix()
        alphaFilter.inputImage = ciImage
        
        let alphaVector = CIVector(
            x: 0, y: 0, z: 0, w: 1
        )
        
        alphaFilter.rVector = alphaVector
        alphaFilter.gVector = alphaVector
        alphaFilter.bVector = alphaVector
        alphaFilter.aVector = alphaVector
        alphaFilter.biasVector = CIVector(
            x: 0, y: 0, z: 0, w: 0
        )
        
        guard let alphaImage = alphaFilter.outputImage?
            .cropped(to: outputExtent) else {
            return nil
        }
        
        // 扩展 Alpha 轮廓
        let morphology = CIFilter.morphologyMaximum()
        morphology.inputImage = alphaImage
        morphology.radius = Float(radius)
        
        guard let expandedImage = morphology.outputImage else {
            return nil
        }
        
        // 根据当前 SwiftUI 环境解析动态颜色
        let resolvedColor = color.resolve(in: environment)
        
        let ciColor = CIColor(
            red: CGFloat(resolvedColor.red),
            green: CGFloat(resolvedColor.green),
            blue: CGFloat(resolvedColor.blue),
            alpha: CGFloat(resolvedColor.opacity)
        )
        
        // 创建描边颜色
        let colorImage = CIImage(
            color: ciColor
        ).cropped(to: outputExtent)
        
        // 使用扩展后的 Alpha 蒙版填充颜色
        let mask = CIFilter.blendWithMask()
        mask.inputImage = colorImage
        mask.backgroundImage = CIImage(
            color: .clear
        ).cropped(to: outputExtent)
        mask.maskImage = expandedImage
        
        guard let outlineImage = mask.outputImage else {
            return nil
        }
        
        // 将原始图片覆盖在描边上
        let composite = CIFilter.sourceOverCompositing()
        composite.inputImage = ciImage
        composite.backgroundImage = outlineImage
        
        guard let output = composite.outputImage,
              let cgImage = CIContext().createCGImage(
                output,
                from: outputExtent
              ) else {
            return nil
        }
        
        return UIImage(
            cgImage: cgImage,
            scale: image.scale,
            orientation: .up
        )
    }
    
    var body: some View {
        Group {
            if let result = outlinedImage {
                Image(uiImage: result)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}
