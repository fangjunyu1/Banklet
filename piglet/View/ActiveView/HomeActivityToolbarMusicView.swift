//
//  HomeActivityToolbarMusicView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/16.
//

import SwiftUI

struct HomeActivityToolbarMusicView: View {
    @Environment(AppStorageManager.self) var appStorage
    @Environment(SoundManager.self) var soundManager
    @Environment(\.colorScheme) var colorScheme
    @Binding var activityTab: ActivityTab
    
    private func playMusicForCurrentTab() {
        switch activityTab {
        case .LifeSavingsBank:
            soundManager.playBackgroundMusic(named: "life0")
        case .EmergencyFund:
            soundManager.playBackgroundMusic(named: "life1")
        }
    }
    
    var body: some View {
        Button(action: {
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
                        Image(systemName: "xmark")
                    }
                }
                .foregroundColor(Color.black)
        })
    }
}
