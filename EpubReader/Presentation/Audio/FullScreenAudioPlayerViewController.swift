//
//  FullScreenAudioPlayerViewController.swift
//  EpubReader
//
//  Created by mac on 09/08/2022.
//

import UIKit
import AVFoundation
import RxSwift
import SnapKit

class FullScreenAudioPlayerViewController: UIViewController {

    static let UpdatePlayPauseNotification = "UpdatePlayPauseNotification"
    
    // MARK: - UI Properties
    let uiImagePause = UIImage(named: "video_pause.png")?.withRenderingMode(.alwaysTemplate)
    let uiImagePlay = UIImage.init(named: "audio_play.png")?.withRenderingMode(.alwaysTemplate)
    
    let swipeView: UIView = {
        let swipeView = UIView()
        swipeView.backgroundColor = UIColor(hex: "#CECECE")
        swipeView.layer.cornerRadius = 3
        return swipeView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.font(with: .h3)
        titleLabel.textColor = UIColor.color(with: .background)
        titleLabel.backgroundColor = .clear
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.tintColor = UIColor.color(with: .background)
        imageView.layer.cornerRadius = 4.0
        return imageView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor(hex: "#CECECE")
        return progressView
    }()
    
    private lazy var rewindButton: UIButton = {
        let rewindButton = UIButton(type: .system)
        let uiImageRewind = UIImage.init(named: "backward_new_icon.png")?.withRenderingMode(.alwaysTemplate)
        rewindButton.setImage(uiImageRewind, for: .normal)
        rewindButton.tintColor = UIColor.color(with: .background)
        rewindButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        rewindButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        rewindButton.addTarget(self, action: #selector(rewindClick), for: .touchUpInside)
        return rewindButton
    }()
    
    private lazy var playButton: UIButton = {
        let playButton = UIButton(type: .system)
        playButton.tintColor = UIColor.color(with: .background)
        playButton.heightAnchor.constraint(equalToConstant: 67).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 67).isActive = true
        playButton.addTarget(self, action: #selector(playButtonClick), for: .touchUpInside)
        return playButton
    }()
    
    private lazy var seekButton: UIButton = {
        let uiImageSeek = UIImage.init(named: "forward_new_icon.png")?.withRenderingMode(.alwaysTemplate)
        let seekButton = UIButton(type: .system)
        seekButton.setImage(uiImageSeek, for: .normal)
        seekButton.tintColor = UIColor.color(with: .background)
        seekButton.isUserInteractionEnabled = true
        seekButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        seekButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        seekButton.addTarget(self, action: #selector(seekClick), for: .touchUpInside)
        return seekButton
    }()
    
    private lazy var controlsStack: UIStackView = {
        let controlsStack = UIStackView(arrangedSubviews: [rewindButton, playButton, seekButton])
        controlsStack.axis = .horizontal
        controlsStack.distribution = .equalCentering
        controlsStack.alignment = .center
        controlsStack.spacing = 60
        controlsStack.translatesAutoresizingMaskIntoConstraints = false
        controlsStack.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return controlsStack
    }()
    
    private lazy var containerStack: UIStackView = {
        let containerStack = UIStackView(arrangedSubviews: [controlsStack])
        containerStack.axis = .vertical
        containerStack.alignment = .center
        return containerStack
    }()
    
    private let scrubber: UISlider = {
        let scrubberThumb = UIImage(named: "audio_scrubber_dot.png")?.resizeImage(newSize: .init(width: 20, height: 20))
        let scrubber = UISlider()
        scrubber.setThumbImage(scrubberThumb, for: .normal)
        scrubber.setThumbImage(scrubberThumb, for: .highlighted)
        scrubber.minimumTrackTintColor = UIColor.color(with: .hightlight)
        scrubber.maximumTrackTintColor = .clear
        scrubber.isHighlighted = true
        scrubber.minimumValue = 0
        scrubber.isUserInteractionEnabled = true
        scrubber.addTarget(self, action: #selector(endScrubbing), for: .touchUpInside)
        scrubber.addTarget(self, action: #selector(endScrubbing), for: .touchUpOutside)
        scrubber.addTarget(self, action: #selector(endScrubbing), for: .touchCancel)
        scrubber.addTarget(self, action: #selector(updateScrubbing), for: .valueChanged)
        return scrubber
    }()
    
    private let soundSlider: UISlider = {
        let soundImageSize = 25
        let leftSoundImage = UIImage.init(named: "sound_decrease.png")?.withRenderingMode(.alwaysTemplate).resizeImage(newSize: CGSize(width: soundImageSize, height: soundImageSize))
        let rightSoundImage = UIImage.init(named: "sound_increase.png")?.withRenderingMode(.alwaysTemplate).resizeImage(newSize: CGSize(width: soundImageSize, height: soundImageSize))
        let soundThumb = UIImage(named: "audio_scrubber_dot.png")?.resizeImage(newSize: .init(width: 25, height: 25))
        let soundSlider = UISlider()
        soundSlider.minimumValueImage = leftSoundImage
        soundSlider.maximumValueImage = rightSoundImage
        soundSlider.setThumbImage(soundThumb, for: .normal)
        soundSlider.setThumbImage(soundThumb, for: .highlighted)
        soundSlider.minimumTrackTintColor = UIColor.color(with: .hightlight)
        soundSlider.maximumTrackTintColor = UIColor(hex: "#CECECE")
        soundSlider.isHighlighted = true
        soundSlider.minimumValue = 0
        soundSlider.isUserInteractionEnabled = true
        soundSlider.value = AVAudioSession.sharedInstance().outputVolume
        soundSlider.addTarget(self, action: #selector(seekAudio), for: .valueChanged)
        return soundSlider
    }()
    
    private lazy var currentVideoPosition: UILabel = {
        let currentVideoPosition = UILabel()
        currentVideoPosition.textAlignment = .left
        currentVideoPosition.text = "0:00"
        currentVideoPosition.tag = 1
        currentVideoPosition.textColor = UIColor.color(with: .background)
        currentVideoPosition.font = UIFont.font(with: .subtitle)
        return currentVideoPosition
    }()
    
    private lazy var durationLabel: UILabel = {
        let durationLabel = UILabel()
        durationLabel.textAlignment = .right
        durationLabel.text = "0:00"
        durationLabel.tag = 2
        durationLabel.textColor = UIColor.color(with: .background)
        durationLabel.font = UIFont.font(with: .subtitle)
        return durationLabel
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.tintColor = UIColor.color(with: .hightlight)
        activity.heightAnchor.constraint(equalToConstant: 67).isActive = true
        activity.widthAnchor.constraint(equalToConstant: 67).isActive = true
        return activity
    }()
    
    var progress: Float = 0 {
        didSet {
            progressView.progress = progress
            syncScrubber(progress: progress)
            updateDurationLabels()
        }
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.color(with: .backgroundFullScreenAudioPlayer)
        
        initUI()
        setupData()
        setupConstraints()
        
        updateDurationLabels()
        updateAudioTitle()
        updateProgressView()
        updatePlayPauseButton()
    }
    
    // MARK: - Private Methods
    private func initUI() {
        self.view.addSubview(swipeView)
        self.view.addSubview(imageView)
        self.view.addSubview(progressView)
        self.view.addSubview(currentVideoPosition)
        self.view.addSubview(durationLabel)
        self.view.addSubview(scrubber)
        self.view.addSubview(titleLabel)
        self.view.addSubview(containerStack)
        self.view.addSubview(soundSlider)
        self.view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 16
        
        swipeView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(6)
            make.width.equalTo(44)
            make.centerX.equalToSuperview()
        }

        imageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(swipeView.snp.bottom).offset(22)
            make.height.equalTo(imageView.snp.width).multipliedBy(9.0/10.0)
        }
        
        progressView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(imageView.snp.bottom).offset(padding)
        }
        
        scrubber.snp.makeConstraints { (make) in
            make.leading.equalTo(progressView).offset(-1)
            make.trailing.equalTo(progressView).offset(4)
            make.top.equalTo(progressView).offset(-9)
            make.height.equalTo(20)
        }
        
        currentVideoPosition.snp.makeConstraints { (make) in
            make.leading.equalTo(scrubber).offset(1)
            make.width.equalTo(100)
            make.height.equalTo(15)
            make.top.equalTo(progressView.snp.bottom).offset(9)
        }
        
        durationLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(scrubber).offset(-2)
            make.width.equalTo(100)
            make.height.equalTo(15)
            make.top.equalTo(currentVideoPosition)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(currentVideoPosition.snp.bottom).offset(48)
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        containerStack.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.height.equalTo(70)
        }
        
        soundSlider.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.height.equalTo(40)
        }
    }
    
    private func updateDurationLabels() {
        let currentTime = AudioPlayer.shared.sound?.currentTime().seconds ?? 0
        let playerItemDuration: CMTime = {
            if let item = AudioPlayer.shared.sound?.currentItem, item.status != .failed {
                return item.duration
            } else {
                return CMTime.invalid
            }
        }()
        
        let secondsRemaining = max(0, Float(CMTimeGetSeconds(playerItemDuration) - currentTime))
        let secondsRemainingFormat = Int(secondsRemaining).durationFormatted()
        durationLabel.text = "-\(secondsRemainingFormat)"
        currentVideoPosition.text = Int(currentTime).durationFormatted()
    }
    
    private func updateProgressView() {
        self.progress = AudioPlayer.shared.getCurrentProgress()
        
        if self.progress == 0 {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
        }
        
        AudioPlayer.shared.progressViewUpdate = {[weak self] (withProgress) in
            self?.progress = withProgress
            if withProgress > 0 {
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func syncScrubber(progress: Float) {
        scrubber.value = progress
    }
    
    private func updatePlayPauseButton() {
        if AudioPlayer.shared.isPaused {
            setPlayImage()
        } else {
            setPauseImage()
        }
    }
    
    private func setPlayImage() {
        DispatchQueue.main.async {
            self.playButton.setImage(self.uiImagePlay, for: .normal)
        }
    }
    
    private func setPauseImage() {
        DispatchQueue.main.async {
            self.playButton.setImage(self.uiImagePause, for: .normal)
        }
    }
    
    private func setupData() {
        if let title = AudioPlayer.shared.audio?.title {
            titleLabel.text = title
        }
        
        if let imgThumbnail = AudioPlayer.shared.imgThumbnail {
            imageView.kf_setImage(url: imgThumbnail)
        }
        
        AudioPlayer.shared.isPaused = !AudioPlayer.shared.isPlaying
        updatePlayPauseButton()
    }
    
    private func updateAudioTitle() {
        AudioPlayer.shared.updateAudioTitle = {[weak self] (title) in
            self?.titleLabel.text = title
        }
    }

    //MARK:  - Control events -
    @objc private func playButtonClick() {
        if AudioPlayer.shared.isPaused {
            AudioPlayer.shared.play()
            setPauseImage()
        } else {
            AudioPlayer.shared.pause()
            setPlayImage()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: FullScreenAudioPlayerViewController.UpdatePlayPauseNotification), object: nil)
    }
    
    @objc private func seekClick() {
        AudioPlayer.shared.seek(seconds: 15)
    }
    
    @objc private func rewindClick() {
        AudioPlayer.shared.seek(seconds: -15)
    }
    
    @objc private func updateScrubbing() {
        if let playerItemDuration = AudioPlayer.shared.sound?.currentItem, playerItemDuration.status != .failed {
            var currentTime = Double()
            let value = Double(scrubber.value)
            currentTime = CMTimeGetSeconds(playerItemDuration.duration) * value
            currentVideoPosition.text = Int(currentTime).durationFormatted()
        } else {
            print("duration invalid")
            return
        }
    }
    
    @objc private func endScrubbing() {
        let minValue = scrubber.minimumValue
        let maxValue = scrubber.maximumValue
        let value = scrubber.value
        AudioPlayer.shared.seekToPercentage(Double(value/(maxValue-minValue)))
        updateDurationLabels()
    }
    
    @objc private func seekAudio() {
        let value = soundSlider.value
        AudioPlayer.shared.volume = value
    }
}
