//
//  EmptyBankView.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/30.
//

import SwiftUI

struct HomeEmptyView: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 50)
            LottieView(filename: "EmptyBanklet", isPlaying: true, playCount: 0, isReversed: false)
                .frame(maxHeight: 180)
                .frame(maxWidth: 500)
            Spacer().frame(height: 30)
            // 文字内容
            VStack(spacing: 20) {
                // 标题
                Text("No piggy bank?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                // 副标题
                Text("Let the piggy bank record your every growth and expectation.")
                    .font(.footnote)
                    .padding(.horizontal,30)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            Spacer().frame(height: 50)
            Button(action:{
                
            },label: {
                Text("Create")
                    .modifier(ButtonModifier())
            })
            Spacer()
        }
    }
}
