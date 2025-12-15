//
//  ActivityContentTitleView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/18.
//

import SwiftUI

struct ActivityContentTitleView: View {
    @EnvironmentObject var homeActivityVM: HomeActivityViewModel
    @EnvironmentObject var activityVM: ActiveViewModel
    var body: some View {
        VStack(spacing: 10) {
            if homeActivityVM.tab == .LifePiggy {
                // 人生存钱罐
                // 标题和副标题
                Text("Calculate your lifetime wealth")
                    .modifier(HomeActivityTitleModifier())
                Text("Based on your current age and salary, it automatically calculates your career starting point, retirement age, and salary growth rate, and calculates your lifetime wealth.")
                    .modifier(HomeActivityFootNoteModifier())
            } else if homeActivityVM.tab == .LifeFund {
                // 生活保障金或紧急备用金
                // 标题和副标题
                Text("Addressing future risks")
                    .modifier(HomeActivityTitleModifier())
                Text("It is recommended to prepare 3-6 months' worth of living expenses to cope with temporary unemployment, medical expenses, or other emergencies.")
                    .modifier(HomeActivityFootNoteModifier())
            }
        }
        .multilineTextAlignment(.center)
    }
}
