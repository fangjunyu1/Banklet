//
//  OpenSourceView.swift
//  piglet
//
//  Created by 方君宇 on 2025/2/1.
//

import SwiftUI

struct OpenSourceView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showGitHub = false
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 50)
            LottieView(filename: "Sun", isPlaying: true, playCount: 0, isReversed: false)
                .modifier(LottieModifier())
                .scaleEffect(1.3)
            VStack(spacing: 10) {
                // 让代码展现在阳光下
                Text("Let the code show in the sun")
                    .modifier(TitleModifier())
                Text("In order to further demonstrate our protection of user privacy, we decided to host the application code as an open source project on GitHub.")
                    .modifier(FootNoteModifier())
            }
            Spacer().frame(height: 50)
            
            // GitHub 按钮
            Button(action: {
                // 振动
                HapticManager.shared.selectionChanged()
                showGitHub = true
            }, label: {
                Image("GitHub")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 66)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 5)
                            .foregroundColor(colorScheme == .light ? .black : AppColor.appGrayColor)
                    }
                    .cornerRadius(10)
                    .opacity(colorScheme == .light ? 1 : 0.8)
            })
            .sheet(isPresented: $showGitHub) {
                SafariView(url: URL(string: "https://github.com/fangjunyu1/Banklet")!)
                    .ignoresSafeArea()
            }
            
            Spacer().frame(height: 10)
            
            Text("https://github.com/fangjunyu1/Banklet")
                .tint(.gray)
                .font(.caption2)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .navigationTitle("Open source")
        .frame(maxWidth: .infinity)
        .modifier(BackgroundModifier())
    }
}

#Preview {
    NavigationStack {
        OpenSourceView()
    }
}
