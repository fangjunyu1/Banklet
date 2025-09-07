//
//  Home.swift
//  BankletWatch Watch App
//
//  Created by 方君宇 on 2025/2/20.
//

import SwiftUI
import SwiftData

struct Home: View {
    @Query(filter: #Predicate<PiggyBank> { $0.isPrimary == true },
           sort: [SortDescriptor(\.creationDate, order: .reverse)]) var piggyBank: [PiggyBank]
    var body: some View {
        GeometryReader { geometry in
            // 通过 `geometry` 获取布局信息
            let width = geometry.size.width * 0.8
            let height = geometry.size.height * 0.8
            VStack {
                if let firstPiggyBank = piggyBank.first {
                    let SavingPercentage: Double = firstPiggyBank.amount / firstPiggyBank.targetAmount
                    
                    CircularProgressBar(progress: SavingPercentage)
                        .overlay {
                            VStack {
                                Image(systemName: "\(firstPiggyBank.icon)")
                                    .font(.title3)
                                Spacer().frame(height: height * 0.1)
                                Text(SavingPercentage, format: .percent.precision(.fractionLength(2)))
                            }
                            .font(.footnote)
                        }
                        .frame(width: width * 0.7)
                    Spacer().frame(height: height * 0.2)
                    Text("\(NSLocalizedString(firstPiggyBank.name, comment: ""))")
                        .font(.footnote)
                } else {
                    Image("emptyBox")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    Home()
        .modelContainer(PiggyBank.preview)
}
