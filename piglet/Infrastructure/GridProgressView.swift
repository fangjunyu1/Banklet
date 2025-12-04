//
//  GridProgressView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI

struct GridProgressView: View {
    var rows: Int
    var columns: Int
    var progress: Double
    var filledColor: Color
    var emptyColor: Color = .gray.opacity(0.2)
    let spacings = 5.0
    
    var body: some View {
        let total: Int = rows * columns
        let filled: Int = Int(Double(total) * progress)
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(10),spacing: spacings), count: columns), alignment: .trailing, spacing: spacings) {
            ForEach(0..<total,id: \.self) { index in
                Rectangle().foregroundColor( index < filled ? filledColor : emptyColor)
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(2)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
    }
}
