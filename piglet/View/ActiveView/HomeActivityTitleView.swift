//
//  HomeActivityTitleView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/16.
//

import SwiftUI

struct HomeActivityTitleView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var activityTab: ActivityTab
    var body: some View {
        ZStack {
            // 存钱罐活动标题
            VStack {
                HStack {
                    Text(LocalizedStringKey(activityTab.title))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical,10)
                        .padding(.horizontal,20)
                        .background(.black.opacity(0.3))
                        .cornerRadius(10)
                }
                .padding(20)
                Spacer()
            }
            // 返回按钮
            VStack {
                HStack {
                    Button(action: {
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
