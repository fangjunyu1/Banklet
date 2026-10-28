//
//  OutlinedTextCanvas.swift
//  piglet
//
//  Created by 方君宇 on 2026/10/27.
//



import SwiftUI
import CoreText

struct OutlinedText: View {

    let text: String

    var fontSize: CGFloat = 17
    var fontWeight: Font.Weight = .bold
    var foregroundColor: Color = .white
    var strokeColor: Color = .black
    var strokeWidth: CGFloat = 2
    var maxWidth: CGFloat = .infinity

    var body: some View {
        Canvas { context, size in

            guard !text.isEmpty else { return }

            let attributedString = NSAttributedString(
                string: text,
                attributes: [
                    NSAttributedString.Key(
                        kCTFontAttributeName as String
                    ): ctFont
                ]
            )

            let line = CTLineCreateWithAttributedString(
                attributedString
            )

            let runs = CTLineGetGlyphRuns(line) as! [CTRun]
            let path = CGMutablePath()

            for run in runs {

                let attributes = CTRunGetAttributes(run) as NSDictionary

                let runFont = attributes[
                    kCTFontAttributeName as String
                ] as! CTFont

                let count = CTRunGetGlyphCount(run)

                guard count > 0 else { continue }

                var glyphs = [CGGlyph](
                    repeating: 0,
                    count: count
                )

                var positions = [CGPoint](
                    repeating: .zero,
                    count: count
                )

                CTRunGetGlyphs(
                    run,
                    CFRange(location: 0, length: count),
                    &glyphs
                )

                CTRunGetPositions(
                    run,
                    CFRange(location: 0, length: count),
                    &positions
                )

                for index in 0..<count {

                    guard let glyphPath = CTFontCreatePathForGlyph(
                        runFont,
                        glyphs[index],
                        nil
                    ) else {
                        continue
                    }

                    let transform = CGAffineTransform(
                        translationX: positions[index].x,
                        y: positions[index].y
                    )

                    path.addPath(
                        glyphPath,
                        transform: transform
                    )
                }
            }

            let bounds = path.boundingBox

            guard !bounds.isNull, !bounds.isEmpty else {
                return
            }

            // 根据最大宽度计算缩放比例
            let scale = scaleFactor

            context.withCGContext { cg in

                cg.saveGState()

                // 将文字居中，并转换为 Canvas 坐标系
                cg.translateBy(
                    x: size.width / 2 - bounds.midX * scale,
                    y: size.height / 2 + bounds.midY * scale
                )

                cg.scaleBy(
                    x: scale,
                    y: -scale
                )

                cg.setLineWidth(strokeWidth)
                cg.setLineJoin(.round)

                // 绘制文字描边
                cg.addPath(path)
                cg.setStrokeColor(strokeColor.cgColor ?? CGColor(
                    gray: 0,
                    alpha: 1
                ))
                cg.strokePath()

                // 填充文字
                cg.addPath(path)
                cg.setFillColor(foregroundColor.cgColor ?? CGColor(
                    gray: 1,
                    alpha: 1
                ))
                cg.fillPath()

                cg.restoreGState()
            }
        }
        .frame(
            width: measuredWidth,
            height: measuredHeight
        )
    }

    // MARK: - Font

    private var ctFont: CTFont {

        let weight: CGFloat

        switch fontWeight {
        case .ultraLight:
            weight = -0.8
        case .thin:
            weight = -0.6
        case .light:
            weight = -0.4
        case .regular:
            weight = 0
        case .medium:
            weight = 0.23
        case .semibold:
            weight = 0.3
        case .bold:
            weight = 0.4
        case .heavy:
            weight = 0.56
        case .black:
            weight = 0.62
        default:
            weight = 0
        }

        let descriptor = CTFontDescriptorCreateWithAttributes([
            kCTFontFamilyNameAttribute: "PingFang SC" as CFString,
            kCTFontSizeAttribute: fontSize,
            kCTFontTraitsAttribute: [
                kCTFontWeightTrait: weight
            ] as CFDictionary
        ] as CFDictionary)

        return CTFontCreateWithFontDescriptor(
            descriptor,
            fontSize,
            nil
        )
    }

    // MARK: - Layout

    /// 未缩放时的文字宽度，包含描边预留空间
    private var naturalWidth: CGFloat {

        let line = CTLineCreateWithAttributedString(
            NSAttributedString(
                string: text,
                attributes: [
                    NSAttributedString.Key(
                        kCTFontAttributeName as String
                    ): ctFont
                ]
            )
        )

        let textWidth = CGFloat(
            CTLineGetTypographicBounds(
                line,
                nil,
                nil,
                nil
            )
        )

        return max(
            1,
            textWidth + strokeWidth * 2 + 4
        )
    }

    /// 最终显示宽度
    private var measuredWidth: CGFloat {
        min(naturalWidth, max(1, maxWidth))
    }

    /// 长文字自动缩小，短文字保持原尺寸
    private var scaleFactor: CGFloat {
        min(1, measuredWidth / naturalWidth)
    }

    /// 高度随文字缩放，避免占用多余空间
    private var measuredHeight: CGFloat {
        (fontSize * 1.5 + strokeWidth * 2) * scaleFactor
    }
}
