//
//  MusicPlayerHelper.swift
//  EpubReader
//
//  Created by mac on 19/11/2022.
//

import Foundation
import AVFoundation
import MediaPlayer

class MusicPlayerHelper {
    
    private let commandCenter = MPRemoteCommandCenter.shared()
    private let mpNowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    private var targets = [Any]()
    static let shared = MusicPlayerHelper()

    func addListener(_ target: Any,
                     playHandler: Selector,
                     pauseHandler: Selector,
                     positionHandler: Selector,
                     forwardHandler: Selector,
                     backwardHandler: Selector) {
        targets.append(target)
        removeAllTargets()
        commandCenter.playCommand.addTarget(target, action: playHandler)
        commandCenter.pauseCommand.addTarget(target, action: pauseHandler)
        commandCenter.changePlaybackPositionCommand.addTarget(target, action: positionHandler)
        commandCenter.skipForwardCommand.addTarget(target, action: forwardHandler)
        commandCenter.skipBackwardCommand.addTarget(target, action: backwardHandler)
    }
    
    func removeListener(_ target: Any) {
        mpNowPlayingInfoCenter.nowPlayingInfo?.removeAll()
        commandCenter.playCommand.removeTarget(target)
        commandCenter.pauseCommand.removeTarget(target)
        commandCenter.changePlaybackPositionCommand.removeTarget(target)
        commandCenter.skipForwardCommand.removeTarget(target)
        commandCenter.skipBackwardCommand.removeTarget(target)
    }
    
    private func removeAllTargets() {
        targets.forEach { target in
            removeListener(target)
        }
    }

    static func setupAppAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: AVAudioSession.Category.playback.rawValue))
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    static func setupInterruptSpokenAudioAndMixWithOthers() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print(error)
        }
    }

    static func setupMixWitOthers() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    static func setupAVAudioSession(avPlayer: AVPlayer) {
        if allowAudioFromOtherApps {
            setupMixWitOthers()
        } else {
            setupAppAudioSession()
            //setupInterruptSpokenAudioAndMixWithOthers()
        }
    }
    
    static var allowAudioFromOtherApps: Bool {
        return UserDefs.allowBackgroundAudio
    }
}
