//
//  HomeActivityTitleView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/16.
//

import SwiftUI

struct HomeActivityTitleView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var homeActivityVM: HomeActivityViewModel
    @EnvironmentObject var activityVM: ActiveViewModel
    var body: some View {
        ZStack {
            // 存钱罐活动标题
            VStack {
                HStack {
                    Text(LocalizedStringKey(homeActivityVM.tab.title))
                        .modifier(ActivityTextModifier())
                }
                .padding(20)
                Spacer()
            }
            // 返回按钮
            VStack {
                HStack {
                    Button(action: {
                        // 振动
                        HapticManager.shared.selectionChanged()
                        dismiss()
                    }, label: {
                        Image(systemName:"chevron.down")
                            .font(.title3)
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    })
                    Spacer()
                }
                .padding(35)
                Spacer()
            }
        }
    }
}
