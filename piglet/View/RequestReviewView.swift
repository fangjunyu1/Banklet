//
//  RequestReviewView.swift
//  piglet
//
//  Created by 方君宇 on 2025/2/27.
//

import SwiftUI
import StoreKit

struct RequestReviewView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        // 触发请求评论
        Text("")  // 不显示内容，只用于触发requestReview
            .onAppear {
                requestReview()  // 触发请求评论
            }
    }
}

#Preview {
    RequestReviewView()
}
