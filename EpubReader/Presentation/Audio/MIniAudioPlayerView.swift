//
//  MiniAudioPlayerView.swift
//  EpubReader
//
//  Created by mac on 20/08/2022.
//

import UIKit
import AVFoundation
import CoreMedia
import SDWebImage
import SnapKit

@objc protocol MiniAudioPlayerViewDelegate: AnyObject {
    @objc optional func removeController()
    @objc optional func showFullScreenAudioPlayerFromMiniPlayer()
}

class MiniAudioPlayerView: UIView {

    private lazy var containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private lazy var containerButtonView: UIView = {
        let containerButtonView = UIView()
        containerButtonView.backgroundColor = UIColor.color(with: .hightlight)
        containerButtonView.alpha = 1
        return containerButtonView
    }()
    
    private lazy var inFrontBlurView: UIView = {
        let inFrontBlurView = UIView()
        inFrontBlurView.backgroundColor = UIColor.white
        return inFrontBlurView
    }()
    
    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return lineView
    }()
    
    private lazy var removePlayButton: UIImageView = {
        let removePlayButton = UIImageView()
        removePlayButton.image = UIImage.init(named: "close_button.png")
        removePlayButton.contentMode = .scaleAspectFit
        removePlayButton.tintColor = UIColor.white
        return removePlayButton
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.color(with: .hightlight)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.color(with: .hightlight)
        titleLabel.font = UIFont.font(with: .h5)
        return titleLabel
    }()
    
    private lazy var buttonPlay: UIButton = {
        let buttonPlay = UIButton()
        buttonPlay.setImage(UIImage(named: "play_filled.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonPlay.tintColor = UIColor.color(with: .hightlight)
        buttonPlay.addTarget(self, action: #selector(playButtonClick), for: .touchUpInside)
        return buttonPlay
    }()
    
    private lazy var buttonNext: UIButton = {
        let buttonNext = UIButton()
        buttonNext.setImage(UIImage(named: "rewind_15_seconds.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonNext.tintColor = UIColor.color(with: .hightlight)
        buttonNext.addTarget(self, action: #selector(rewindClick), for: .touchUpInside)
        return buttonNext
    }()
    
    private lazy var buttonForward: UIButton = {
        let buttonForward = UIButton()
        buttonForward.setImage(UIImage(named: "fastforward_15_seconds.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonForward.tintColor = UIColor.color(with: .hightlight)
        buttonForward.addTarget(self, action: #selector(seekClick), for: .touchUpInside)
        return buttonForward
    }()
    
    let scrubber = UISlider()
    let timeToSeek :CGFloat = 15
    let uiImagePause = UIImage(named: "video_pause.png")?.withRenderingMode(.alwaysTemplate)
    let uiImagePlay = UIImage.init(named: "video_play.png")?.withRenderingMode(.alwaysTemplate)
    
    var progressView: UIProgressView!
    var blurEffectStyle: UIBlurEffect.Style!
    var buttonColour: UIColor!
    var ratio : CGFloat = 16/9
    var heightlabel : CGFloat = 32.0
    var pading: CGFloat!
    var sizeButton: CGFloat!
    var viewType: Constants.audioViewType = .minimized
    var isAccessoriesScreen = false
    var panRight = false
    
    weak var delegate: MiniAudioPlayerViewDelegate? = nil
    
    var progress: Float = 0 {
        didSet {
            progressView.progress = progress
            syncScrubber(progress: progress)
        }
    }
    
    var statusPlay: Bool = true {
        didSet {
            if statusPlay {
                buttonPlay.setImage(uiImagePlay, for: .normal)
            } else {
                buttonPlay.setImage(uiImagePause, for: .normal)
            }
        }
    }
    
    var title : String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var urlThumnail: URL?{
        didSet {
            self.imageView.sd_setImage(with: urlThumnail)
        }
    }
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayPauseButton(note:)), name: NSNotification.Name(rawValue: FullScreenAudioPlayerViewController.UpdatePlayPauseNotification), object: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            pading = 15
            sizeButton = 30
        } else {
            pading = 10
            sizeButton = 25
        }
        
        containerView.addSubview(inFrontBlurView)
        containerView.addSubview(lineView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(buttonPlay)
        containerView.addSubview(buttonNext)
        containerView.addSubview(buttonForward)
    
        self.addSubview(containerButtonView)
        self.addSubview(removePlayButton)
        self.addSubview(containerView)
        
        addGestures()

        self.backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var height : CGFloat = 0.0
        height = self.frame.height
        let padding: CGFloat = 16
        
        containerView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(CGSize(width: self.frame.width, height: self.frame.height))
        }
        
        if viewType == .fullScreen {
            let imageWidth = self.frame.width - padding*2
            imageView.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(padding)
                make.top.equalToSuperview().offset(50)
                make.size.equalTo(CGSize(width: imageWidth, height: imageWidth/ratio))
            }
        } else {
            inFrontBlurView.frame = self.bounds
            
            lineView.snp.makeConstraints { (make) in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 0.5))
            }
            
            if let title = AudioPlayer.shared.audio?.title {
                titleLabel.text = title
            }

            let imageWidth = height*ratio*0.5
            imageView.snp.makeConstraints{ (make) in
                make.leading.equalToSuperview().offset(10)
                make.top.equalToSuperview().offset(height*0.1)
                make.size.equalTo(CGSize(width: imageWidth, height: 0.8*height))
            }
            
            buttonForward.snp.makeConstraints{ (make) in
                make.leading.equalTo(UIScreen.main.bounds.width - pading - sizeButton)
                make.top.equalTo((height - sizeButton)/2)
                make.size.equalTo(CGSize(width: sizeButton, height: sizeButton))
            }
            
            let buttonPlayX = UIScreen.main.bounds.width - pading*2 - sizeButton*2
            buttonPlay.snp.makeConstraints{ (make) in
                make.leading.equalTo(buttonPlayX - 12)
                make.top.equalTo((height - sizeButton)/2)
                make.size.equalTo(CGSize(width: sizeButton, height: sizeButton))
            }
            
            buttonNext.snp.makeConstraints{ (make) in
                make.leading.equalTo(buttonPlayX - 64)
                make.top.equalTo((height - sizeButton)/2)
                make.size.equalTo(CGSize(width: sizeButton, height: sizeButton))
            }
            
            let widthlabel = imageWidth*4
            let titleLabelX = imageWidth + pading*2
            titleLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(titleLabelX)
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: widthlabel, height: heightlabel))
            }
            
            containerButtonView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            removePlayButton.frame = CGRect(x: self.bounds.width - 50 , y: 10, width: 40, height: 40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func addGestures() {
        let slideView = UIPanGestureRecognizer(target: self, action: #selector(showRemoveButton))
        let closePlayerGesture = UITapGestureRecognizer(target: self, action: #selector(directDismisPlayer))
        let thumbnailGesture = UITapGestureRecognizer(target: self, action: #selector(showFullPlayer))
        thumbnailGesture.numberOfTapsRequired = 1
        thumbnailGesture.numberOfTouchesRequired = 1
        
        containerView.addGestureRecognizer(slideView)
        containerButtonView.addGestureRecognizer(closePlayerGesture)
        imageView.addGestureRecognizer(thumbnailGesture)
        
        containerView.isUserInteractionEnabled = true
        containerButtonView.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
    }
    
    private func syncScrubber(progress: Float) {
        scrubber.value = progress
    }
    
    // MARK: - Private Methods Events
    @objc private func endScrubbing() {
    }
    
    @objc private func showRemoveButton(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.changed || gestureRecognizer.state == UIGestureRecognizer.State.began {
            let translation = gestureRecognizer.translation(in: self)
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + (translation.x)/2,
                                                     y: gestureRecognizer.view!.center.y)
            if translation.x > 0 {
                panRight = true
            } else {
                panRight = false
            }
            self.containerButtonView.alpha = (self.bounds.width - (self.containerView.frame.origin.x + self.containerView.frame.width))/60
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self)
        }
        
        if gestureRecognizer.state == .ended {
            if panRight {
                UIView.animate(withDuration: 0.3) {
                    gestureRecognizer.view!.center = CGPoint(x: self.bounds.width/2, y: gestureRecognizer.view!.center.y)
                    self.containerButtonView.alpha = (self.bounds.width - (self.containerView.frame.origin.x + self.containerView.frame.width))/60
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    gestureRecognizer.view!.center = CGPoint(x:  self.bounds.width/2 - 60, y: gestureRecognizer.view!.center.y)
                    self.containerButtonView.alpha = (self.bounds.width - (self.containerView.frame.origin.x + self.containerView.frame.width))/60
                }
            }
        }
    }
    
    @objc func updatePlayPauseButton(note: NSNotification) {
        if AudioPlayer.shared.isPaused {
            self.statusPlay = true
        } else {
            self.statusPlay = false
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    @objc func playButtonClick() {
        if AudioPlayer.shared.isPlaying {
            AudioPlayer.shared.pause()
            AudioPlayer.shared.progressViewUpdate = nil
            self.statusPlay = true
        } else {
            AudioPlayer.shared.play()
            self.statusPlay = false
        }
    }
    
    @objc func seekClick() {
        AudioPlayer.shared.seek(seconds: 15)
    }
    
    @objc func rewindClick() {
        AudioPlayer.shared.seek(seconds: -15)
    }
    
    @objc func showFullPlayer() {
        self.delegate?.showFullScreenAudioPlayerFromMiniPlayer?()
    }
    
    @objc func directDismisPlayer() {
        self.delegate?.removeController?()
    }
}
