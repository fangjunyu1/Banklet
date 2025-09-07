//
//  List.swift
//  BankletWatch Watch App
//
//  Created by 方君宇 on 2025/2/20.
//

import SwiftUI
import SwiftData

struct List: View {
    @Query var allPiggyBank: [PiggyBank]
    
    var body: some View {
        GeometryReader { geometry in
            // 通过 `geometry` 获取布局信息
            let width = geometry.size.width * 0.85
            ScrollView {
                if allPiggyBank.isEmpty {
                    Image("emptyList")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width)
                } else {
                    ForEach(allPiggyBank, id:\.self) { item in
                        HStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 40)
                                .overlay {
                                    Image(systemName: item.icon)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                }
                            Spacer()
                                .frame(width: width * 0.1)
                            VStack(alignment: .leading) {
                                Text("\(NSLocalizedString(item.name, comment: ""))")
                                    .font(.system(size: 10))
                                Spacer()
                                    .frame(height: 6)
                                // 计算进度并显示百分比
                                 let progress = item.amount / item.targetAmount
                                Text(progress, format: .percent.precision(.fractionLength(2)))
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment:.leading)
                        }
                        .frame(width: width)
                        .padding(.horizontal,10)
                        .padding(.vertical,14)
                        .background(Color(hex:"2C2B2D"))
                        .cornerRadius(10)
                        Spacer()
                            .frame(height: 20)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
    }
}

#Preview {
    List()
        .modelContainer(PiggyBank.preview)
}
