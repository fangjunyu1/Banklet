//
//  HomeActivityToolbarMusicView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/16.
//

import SwiftUI

struct ActivityMusicView: View {
    @Environment(AppStorageManager.self) var appStorage
    @Environment(SoundManager.self) var soundManager
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var homeActivityVM: HomeActivityViewModel
    @EnvironmentObject var activityVM: ActiveViewModel
    
    private func playMusicForCurrentTab() {
        switch homeActivityVM.tab {
        case .LifeSavingsBank:
            soundManager.playBackgroundMusic(named: "life0")
        case .EmergencyFund:
            soundManager.playBackgroundMusic(named: "life1")
        }
    }
    
    var body: some View {
        Button(action: {
            // 振动
            HapticManager.shared.selectionChanged()
            appStorage.isActivityMusic.toggle()
            if appStorage.isActivityMusic {
                playMusicForCurrentTab()    // 播放音乐
            } else {
                soundManager.stopAllSound()
            }
        }, label: {
            Image(systemName: "music.note")
                .overlay {
                    if !appStorage.isActivityMusic {
                        Image(systemName: "line.diagonal")
                            .rotationEffect(Angle(degrees: 90))
                    }
                }
                .modifier(BlackTextModifier())
        })
    }
}

#Preview {
    NavigationStack {
        HomeActivityView()
            .environment(AppStorageManager.shared)
            .environment(SoundManager.shared)
            .environment(HomeActivityViewModel())
    }
}
