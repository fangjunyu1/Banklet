//
//  AboutUsView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/10.
//

import SwiftUI
import Lottie

struct AboutUsView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ScrollView(showsIndicators: false) {
            LottieView(filename: "WorkingCat",isPlaying: true, playCount: 0, isReversed: false)
                .scaleEffect(1.3)
                .modifier(LottieModifier())
            VStack(spacing: 10) {
                Text("Who are we?")
                    .modifier(TitleModifier())
                Text("An independent developer from China")
                    .modifier(FootNoteModifier())
            }
            Spacer().frame(height: 20)
            VStack(spacing: 10) {
                ForEach(aboutUsList, id:\.self) { item in
                    Text(LocalizedStringKey(item))
                        .font(.footnote)
                        .padding(10)
                        .background(.white)
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                    
                }
                Text("We hope this app will bring you a relaxed and enjoyable user experience.")
                    .font(.footnote)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(AppColor.appColor)
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
            }
            Spacer().frame(height: 50)
        }
        .navigationTitle("About Us")
        .frame(maxWidth: .infinity)
        .modifier(BackgroundModifier())
    }
    
    
    let aboutUsList:[String] = [
        "Hello, I am Fang Junyu, an independent developer from China.",
        "I am a novice independent developer. Before becoming a developer, I worked in sales, on-site project work, and the catering industry.",
        "In 2024, after leaving my previous company, I began to think about what I really wanted to do.",
        "At the time, I was working towards my goals of owning a house and a car, which gave me the idea to develop a money-saving app.",
        "So I started learning iOS development and completed and released the first version of \"Savings Piggy\" that month.",
        "As of June 2025, this little pig has evolved through 9 versions.",
        "I hope it can help more people achieve their goals, and I will continue to update it to make the app even better."
    ]
}

#Preview {
    NavigationStack {
        AboutUsView()
    }
}
