//
//  HomeActivitySheetBackground.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/16.
//

import SwiftUI

struct HomeActivitySheetBackground: View {
    @Binding var activityTab: ActivityTab
    @Binding var activityInput: ActivityInput
    @Binding var activityStep: ActivityStep
    var body: some View {
        ZStack {
            // 背景图片
            Rectangle()
                .overlay {
                    // 背景图片
                    Image(activityTab.image)
                        .resizable()
                        .scaledToFill()
                }
                .frame(minHeight: 400)
                .padding(.bottom, -20)
            SheetView(activityTab: $activityTab, activityInput: $activityInput, activityStep: $activityStep)
        }
    }
}

private struct SheetView: View {
    @Binding var activityTab: ActivityTab
    @Binding var activityInput: ActivityInput
    @Binding var activityStep: ActivityStep
    var body: some View {
        VStack {
            Spacer()
            if activityTab == .EmergencyFund {
                SheetEmergencyFundView(activityTab: $activityTab, activityInput: $activityInput, activityStep: $activityStep)
                    .padding(.bottom,20)
            }
        }
    }
}

private struct SheetEmergencyFundView: View {
    @Binding var activityTab: ActivityTab
    @Binding var activityInput: ActivityInput
    @Binding var activityStep: ActivityStep
    let monthList: [Int] = [1,3,6,9,12,24]
    var body: some View {
        // 保障月份
        VStack(spacing: 10) {
            Text("Guaranteed Month")
                .fontWeight(.bold)
            HStack(spacing: 15) {
                ForEach(monthList, id:\.self) { item in
                    Button(action: {
                        // 振动
                        HapticManager.shared.selectionChanged()
                        activityInput.guaranteeMonth = item
                    }, label: {
                        VStack {
                            Text("\(item)")
                                .font(.footnote)
                                .foregroundColor(AppColor.appGrayColor)
                            Image(systemName: activityInput.guaranteeMonth == item ? "checkmark.circle.fill" : "circle.fill")
                                .font(.title)
                                .foregroundColor(activityInput.guaranteeMonth == item ? Color(hex: "FA9803") : AppColor.appBgGrayColor)
                        }
                    })
                }
            }
        }
        .padding(.vertical,10)
        .padding(.horizontal,20)
        .background(Color.white)
        .cornerRadius(20)
    }
}
#Preview {
    NavigationStack {
        VStack{}
            .sheet(isPresented: .constant(true)) {
                HomeActivitySheetView(activityTab: .constant(.EmergencyFund))
            }
    }
}

