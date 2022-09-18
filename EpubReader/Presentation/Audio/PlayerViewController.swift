//
//  PlayerViewController.swift
//  EpubReader
//
//  Created by mac on 20/08/2022.
//

import UIKit
import SnapKit

class PlayerViewController: UIViewController {
    
    var miniAudioPlayerView = MiniAudioPlayerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.red
        view.backgroundColor = UIColor.clear
        miniAudioPlayerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        miniAudioPlayerView.delegate = self
        if AudioPlayer.shared.sound != nil {
            if AudioPlayer.shared.isPlaying {
                miniAudioPlayerView.statusPlay = false
            }else{
                miniAudioPlayerView.statusPlay = true
            }
        }
        self.view.addSubview(miniAudioPlayerView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let y = UIScreen.main.bounds.height - 60 - (tabBarController?.tabBar.frame.height ?? 44) - UIApplication.shared.keyWindow!.safeAreaInsets.bottom
        self.view.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.top.equalTo(y)
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 60))
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            miniAudioPlayerView.snp.makeConstraints { (make) in
                make.leading.equalTo(0)
                make.top.equalTo(0)
                make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 60))
            }
        }
    }
}

extension PlayerViewController: MiniAudioPlayerViewDelegate {
    func removeController() {
        print("close audio player")
        AudioPlayer.shared.sound = nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MainTabBarViewController.HideShowAudioPlayer), object: nil)
    }
    
    func showFullScreenAudioPlayerFromMiniPlayer() {
        print("show full audio player")
        let viewController = FullScreenAudioPlayerViewController()
        DispatchQueue.main.async {
            self.present(viewController, animated: true, completion: nil)
        }
    }
}
