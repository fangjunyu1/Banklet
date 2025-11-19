//
//  SheetEmergencyFundView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/18.
//

import SwiftUI

// 生活保障金 - 月份选择视图
struct EmergencyFundView: View {
    @EnvironmentObject var activityVM: ActiveViewModel
    let monthList: [Int] = [1,3,6,9,12,24]
    var body: some View {
        VStack {
            // 保障月份
            Spacer()
            VStack(spacing: 10) {
                Text("Guaranteed Month")
                    .fontWeight(.bold)
                HStack(spacing: 15) {
                    ForEach(monthList, id:\.self) { item in
                        Button(action: {
                            // 振动
                            HapticManager.shared.selectionChanged()
                            activityVM.input.guaranteeMonth = item
                        }, label: {
                            VStack {
                                Text("\(item)")
                                    .font(.footnote)
                                    .foregroundColor(AppColor.appGrayColor)
                                Image(systemName: activityVM.input.guaranteeMonth == item ? "checkmark.circle.fill" : "circle.fill")
                                    .font(.title)
                                    .foregroundColor(activityVM.input.guaranteeMonth == item ? Color(hex: "FA9803") : AppColor.appBgGrayColor)
                            }
                        })
                    }
                }
            }
            .padding(.vertical,10)
            .padding(.horizontal,20)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.bottom,20)
        }
    }
}
