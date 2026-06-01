//
//  LifeSavingsView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/18.
//

import SwiftUI

struct LifeSavingsView: View {
    @EnvironmentObject var activityVM: ActiveViewModel
    var body: some View {
        VStack(spacing: 5) {
            ForEach(activityVM.lifeSavingRows) { row in
                switch row {
                case .year(let age, let salary):
                    HStack(spacing: 20) {
                        Text(verbatim: "\(age)")
                            .modifier(ActivityLittleTextModifier())
                        Text(verbatim: "\(salary)")
                            .modifier(ActivityLittleTextModifier())
                    }
                case .gap:
                    Text(verbatim: "...")
                        .modifier(ActivityLittleTextModifier())
                case .total(let amount):
                    Text(verbatim: "\(amount)")
                        .modifier(ActivityLittleTextModifier())
                }
            }
        }
        .padding(.top, 40)
    }
}

#Preview {
    NavigationStack {
        VStack{}
            .sheet(isPresented: .constant(true)) {
                let hvm = HomeActivityViewModel()
                let vm = ActiveViewModel()
                HomeActivitySheetView()
                    .environment(vm)
                    .environment(hvm)
                    .environment(IdleTimerManager.shared)
                    .onAppear {
                        hvm.tab = .LifePiggy
                    }
            }
    }
}




