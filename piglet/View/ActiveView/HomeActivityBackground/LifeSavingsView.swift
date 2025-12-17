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
                        Text("\(age)")
                            .modifier(ActivityLittleTextModifier())
                        Text("\(salary)")
                            .modifier(ActivityLittleTextModifier())
                    }
                case .gap:
                    Text("...")
                        .modifier(ActivityLittleTextModifier())
                case .total(let amount):
                    Text("\(amount)")
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




