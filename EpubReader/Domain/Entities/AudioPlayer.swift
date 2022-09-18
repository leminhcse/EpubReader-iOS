//
//  AudioPlayer.swift
//  EpubReader
//
//  Created by mac on 17/08/2022.
//

import Foundation
import AVFoundation
import MediaPlayer

class AudioPlayer: NSObject {
    static let shared = AudioPlayer()
    
    public typealias ProgressViewUpdate = (_ to: Float) -> Void
    public var progressViewUpdate: ProgressViewUpdate?
    public var sound: AVPlayer?
    
    var isPlayingUpdate: ((Bool) -> ())?
    var periodicTimeObserver : Any?
    var image = UIImage()
    var pauseBf = false
    var upNextAudios = [Audio]()
    var audio: Audio?
    
    var isPlaying: Bool {
        guard let sound = sound else {
            return false
        }
        return sound.rate != 0 && sound.error == nil
    }
    
    var imgThumbnail: URL? {
        didSet{
            if let imgThumbnail = imgThumbnail, let data = try? Data(contentsOf: imgThumbnail) {
                image = UIImage(data: data) ?? UIImage()
            }
        }
    }
    
    var isPaused = false {
        didSet { isPlayingUpdate?(!isPaused) }
    }
    
    var volume: Float? {
        didSet {
            if let floatVolume = self.volume {
                self.sound?.volume = floatVolume
            }
        }
    }
    
    var rate: Float? {
        didSet {
            if let floatRate = self.rate {
                self.sound?.rate = floatRate
            }
        }
    }
    
    public override init() {
        super.init()
        setupMPTarget()
    }
    
    deinit {
        removeMPTarget()
    }
    
    private func setupMPTarget() {
    }

    private func removeMPTarget() {
    }
    
    //MARK: - Methods
    func initSession() {
    }
    
    func seekTo(time: Float64) {
        guard !time.isInfinite, !time.isNaN, let sound = self.sound else {
            return
        }
        let seconds = Int64(time)
        let targetTime = CMTimeMake(value: seconds, timescale: 1)
        sound.seek(to: targetTime)
        
        if sound.rate == 0 {
            sound.play()
        }
    }
    
    func seek(seconds: Int) {
        guard self.sound != nil else {
            return
        }
        
        var currentTime: Float64 = 0.0
        if let currentItem = self.sound?.currentItem {
            currentTime = Float64(CMTimeGetSeconds(currentItem.currentTime()))
        }
        let timeSeek = CMTime(seconds: Double(seconds), preferredTimescale: 1)
        let floatTime = Float64(CMTimeGetSeconds(timeSeek))
        let totalTime = currentTime + floatTime
        
        if self.sound?.currentItem?.status == .readyToPlay && isPlaying {
            self.seekTo(time: totalTime)
        } else if self.sound?.currentItem?.status == .readyToPlay {
            let timeSeekTo = CMTime.init(seconds: currentTime, preferredTimescale: 1)
            let time = timeSeekTo + timeSeek
            self.sound?.seek(to: time, completionHandler: {_ in
            })
        }
    }
    
    func pause(){
        isPaused = true
        self.sound?.pause()
    }
    
    func play() {
        isPaused = false
        sound?.play()
        setupMPTarget()
    }
    
    func getCurrentProgress() -> Float {
        if self.sound?.currentItem?.status == .readyToPlay {
            let time : Float64 = CMTimeGetSeconds(self.sound!.currentTime());
            let totalTime : Float64 = CMTimeGetSeconds(self.sound!.currentItem!.duration)
            let progress = Float(time) / Float(totalTime)
            return progress
        } else {
            return 0
        }
    }
    
    func play(audio: Audio, thumbnail: String) {
        self.audio = audio
        if let thumbnail = URL(string: thumbnail) {
            imgThumbnail = thumbnail
        }
        
        let url: URL?
        if let id = self.audio?.id,
           let itemPath = DatabaseHelper.getFilePath(id: id),
            FileManager.default.fileExists(atPath: itemPath) {
            url = URL(fileURLWithPath: itemPath)
        } else {
            url = URL(string: self.audio?.fileAudio.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
        self.play(url: url)
    }
    
    func play(url: URL?) {
        guard let audioUrl = url else {
            return
        }
        self.sound = AVPlayer(playerItem: AVPlayerItem(url: audioUrl))
        self.play()
        
        periodicTimeObserver = self.sound?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1),
                                                                   queue: DispatchQueue.main,
                                                                   using: { (cmTime) in
            if self.sound?.currentItem?.status == .readyToPlay {
                if let currentTime = self.sound?.currentTime(), let duration = self.sound?.currentItem?.duration {
                    let time: Float64 = CMTimeGetSeconds(currentTime)
                    let totalTime: Float64 = CMTimeGetSeconds(duration)
                    self.progressViewUpdate?(Float(time) / Float(totalTime))
                }
            }
        })
    }
    
    //MARK: - ReceivedWithEvent
    //response to remote control events
    func remoteControlReceivedWithEvent(_ receivedEvent:UIEvent) {
        
    }
    
    func seekToPercentage(_ perc: Double) {
        guard let duration = sound?.currentItem?.duration else { return }
        
        let totalTime : Float64 = CMTimeGetSeconds(duration)
        let time = totalTime * perc
        seekTo(time: time)
    }
    
    func buttonForwardTapper(timeToSeek : Double){
        guard AudioPlayer.shared.sound != nil else { return}
        let currentTime = CMTimeGetSeconds(AudioPlayer.shared.sound!.currentItem!.currentTime())
        let timeSeek = CMTime(seconds: Double(timeToSeek), preferredTimescale: 1)
        let floatTime = Float64(CMTimeGetSeconds(timeSeek))
        let totalTime = currentTime + floatTime
        if AudioPlayer.shared.sound?.currentItem?.status == AVPlayerItem.Status.readyToPlay && AudioPlayer.shared.isPlaying{
            AudioPlayer.shared.seekTo(time: totalTime)
        }
        else if AudioPlayer.shared.sound?.currentItem?.status == AVPlayerItem.Status.readyToPlay{
            let timeSeekTo = CMTime.init(seconds: currentTime, preferredTimescale: 1)
            let ttime = timeSeekTo + timeSeek
            AudioPlayer.shared.sound!.seek(to: ttime, completionHandler: {_ in
            })
        }
    }
    
    func buttonNextTapper(controlType: Constants.RemoteControlType){
        let currentURL = (AudioPlayer.shared.sound?.currentItem?.asset as? AVURLAsset)?.url
        for (index, audio) in self.upNextAudios.enumerated() {
            if currentURL?.absoluteString == Utilities.shared.getCloudFileUrl(fileName: audio.fileAudio) {
                var audioItem: Audio?
                if self.upNextAudios.count > 1 {
                    switch controlType {
                    case .remoteControlPreviousTrack:
                        if index > 0 {
                            audioItem = self.upNextAudios[index - 1]
                        } else {
                            audioItem = self.upNextAudios[self.upNextAudios.count - 1]
                        }
                        if let audioItem = audioItem {
                            //AudioPlayer.shared.play(audio: audioItem)
                            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: NSNotificationName.remoteControlType.remoteControlPreviousTrack.rawValue), object: nil, userInfo: ["data": audioItem])
                        }
                    case .remoteControlNextTrack:
                        if index == self.upNextAudios.count - 1 {
                            audioItem = self.upNextAudios[0]
                        } else {
                            audioItem = self.upNextAudios[index + 1]
                        }
                        if let audioItem = audioItem {
                            //AudioPlayer.shared.play(audio: audioItem)
                            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: NSNotificationName.remoteControlType.remoteControlNextTrack.rawValue), object: nil, userInfo: ["data": audioItem])
                        }
                    }
                }
            }
        }
    }
}
