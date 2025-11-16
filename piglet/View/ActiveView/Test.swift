//
//  Test.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/16.
//

import SwiftUI

struct HomeActivitySheetPreviewView: View {
    @State private var tab = HomeTab.activity
    @State private var sheet = true
    var body: some View {
        Button("Clicke me ") {
            sheet.toggle()
        }
            .sheet(isPresented: $sheet) {
                HomeActivitySheetView(activityTab: .constant(.EmergencyFund))
            }
    }
}
