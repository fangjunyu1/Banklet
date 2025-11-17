//
//  HomeprimaryBankView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI

struct HomePrimaryBankView: View {
    var primaryBank: PiggyBank
    var progress: Double {
        primaryBank.progress
    }
    let buttonHeight = 50.0
    
    var body: some View {
        // 主存钱罐信息
        VStack(spacing: 10) {
            // 1、主存钱罐图标、名称、截止日期和进度
            HStack {
                // 存钱罐图标
                ZStack {
                    Rectangle().foregroundStyle(AppColor.appColor)
                    Image(systemName:primaryBank.icon)
                        .foregroundColor(.white)
                }
                .frame(width: 50, height: 50)
                .cornerRadius(10)
                Spacer().frame(width: 10)
                VStack(alignment: .leading,spacing: 10) {
                    // 存钱罐名称
                    Text(LocalizedStringKey(primaryBank.name))
                        .fontWeight(.semibold)
                    // 如果设置了截止日期，则显示截止日期
                    if primaryBank.isExpirationDateEnabled {
                        HStack {
                            Text("Expiration date")
                            Text(primaryBank.expirationDate,format: .dateTime.year().month().day())
                        }
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    }
                }
                Spacer()
                // 右上角的百分比进度
                VStack {
                    Text(primaryBank.progressText)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
            }
            .frame(height:50)
            // 2、主存钱罐进度条
            VStack {
                // 金额对比
                HStack(spacing: 5) {
                    // 当前金额
                    Text(primaryBank.amountText)
                    .font(.headline)
                    // 目标金额
                    Group {
                        Text("/")
                        Text(primaryBank.targetAmountText)
                    }
                    .font(.caption2)
                    .foregroundColor(AppColor.appGrayColor)
                    .offset(y:2)
                    Spacer()
                }
                // 2、进度条
                ProgressView(value: progress)
                    .progressViewStyle(CustomProgressViewStyle())
                    .cornerRadius(10)
            }
            // 3、进度占比-方格
            HStack {
                GridProgressView(rows: 5, columns: 7,progress: progress,filledColor: .blue)
            }
            Spacer().frame(height: 5)
            // 4、信息、存入、取出、删除按钮
            GeometryReader { geo in
                let width = geo.size.width
                let spacerSpacing = 5.0
                
                HStack(spacing: 0) {
                    // 1) 信息按钮
                    Button(action: {
                        print("width:\(width)")
                        // 振动
                        HapticManager.shared.selectionChanged()
                    }, label: {
                        VStack(spacing: spacerSpacing) {
                            Image(systemName:"info")
                            Text("Info")
                        }
                        .font(.caption2)
                        .foregroundColor(Color(hex: "376EE2"))
                    })
                    .frame(width: width * 0.23, height: buttonHeight)
                    .contentShape(Rectangle())
                    .background(Color(hex: "F1F6FE"))
                    .cornerRadius(5)
                    
                    Spacer()
                    
                    // 2) 存入按钮
                    Button(action: {
                        
                        // 振动
                        HapticManager.shared.selectionChanged()
                    }, label: {
                        VStack(spacing: spacerSpacing) {
                            Image(systemName:"square.and.arrow.down")
                            Text("Deposit")
                        }
                        .font(.caption2)
                        .foregroundColor(Color(hex: "4CA154"))
                    })
                    .frame(width: width * 0.23, height: buttonHeight)
                    .contentShape(Rectangle())
                    .background(Color(hex: "F3FDF5"))
                    .cornerRadius(5)
                    
                    Spacer()
                    
                    // 3) 取出按钮
                    Button(action: {
                        
                        // 振动
                        HapticManager.shared.selectionChanged()
                    }, label: {
                        VStack(spacing: spacerSpacing) {
                            Image(systemName:"square.and.arrow.up")
                            Text("Withdraw")
                        }
                        .font(.caption2)
                        .foregroundColor(Color(hex: "D9622B"))
                    })
                    .frame(width: width * 0.23, height: buttonHeight)
                    .contentShape(Rectangle())
                    .background(Color(hex: "FEF7EE"))
                    .cornerRadius(5)
                    
                    Spacer()
                    
                    // 4) 删除按钮
                    Button(action: {
                        
                        // 振动
                        HapticManager.shared.selectionChanged()
                    }, label: {
                        VStack(spacing: spacerSpacing) {
                            Image(systemName:"trash")
                            Text("Delete")
                        }
                        .font(.caption2)
                        .foregroundColor(Color(hex: "CA3A32"))
                    })
                    .frame(width: width * 0.23, height: buttonHeight)
                    .contentShape(Rectangle())
                    .background(Color(hex: "FCF3F2"))
                    .cornerRadius(5)
                }
            }
            .frame(height:buttonHeight)
            
        }
        .padding(.vertical,16)
        .padding(.horizontal,16)
        .background(.white)
        .cornerRadius(10)
        .padding(.vertical,5)
        .padding(.horizontal,16)
    }
}
