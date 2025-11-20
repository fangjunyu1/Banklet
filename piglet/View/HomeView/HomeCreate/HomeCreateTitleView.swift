//
//  HomeCreateTitleView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/20.
//

import SwiftUI

// 创建存钱罐 - 名称
struct HomeCreateTitleView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading,spacing: 10) {
                Text("Create a piggy bank")
                    .font(.title2)
                    .fontWeight(.medium)
                Text("Please fill in your savings plan information completely, and set the name, goal and starting amount step by step.")
                    .font(.footnote)
                    .foregroundColor(AppColor.gray)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
