//
//  Footnote.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/9.
//

import SwiftUI

struct Footnote: View {
    @Environment(\.colorScheme) var colorScheme
    var text: String
    var body: some View {
        var color = colorScheme == .light ? Color.gray : Color.white
        Text(LocalizedStringKey(text))
            .font(.footnote)
            .foregroundColor(color)
    }
}

struct Caption: View {
    var text: String
    var body: some View {
        Text(LocalizedStringKey(text))
            .font(.caption)
            .foregroundColor(.gray)
    }
}

struct Caption2: View {
    var text: String
    var body: some View {
        Text(LocalizedStringKey(text))
            .font(.caption2)
            .foregroundColor(.gray)
    }
}

struct Caption2Black: View {
    @Environment(\.colorScheme) var colorScheme
    var text: String
    var body: some View {
        let color = colorScheme == .light ? AppColor.appGrayColor : AppColor.appBgGrayColor
        Text(LocalizedStringKey(text))
            .font(.caption2)
            .foregroundColor(color)
    }
}

struct FootnoteSource: View {
    var text: String
    var body: some View {
        HStack(alignment: .center) {
            Text(LocalizedStringKey(text))
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding(.top,20)
    }
}
