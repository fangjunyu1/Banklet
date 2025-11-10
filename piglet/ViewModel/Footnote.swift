//
//  Footnote.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/9.
//

import SwiftUI

struct Footnote: View {
    var text: String
    var body: some View {
        Text(LocalizedStringKey(text))
            .font(.footnote)
            .foregroundColor(.gray)
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
