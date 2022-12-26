//
//  MainTabBarViewController.swift
//  EpubReader
//
//  Created by MacBook on 5/23/22.
//

import UIKit
import SnapKit

class MainTabBarViewController: UITabBarController {
    
    static let HideShowAudioPlayer = "HideShowAudioPlayer"
    
    var playerView: PlayerViewController?
    
    // MARK: UITabBarController LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideShowAudioPlayer(note:)), name: NSNotification.Name(rawValue: MainTabBarViewController.HideShowAudioPlayer), object: nil)
        
        setupView()
        setupTabBarController()
    }
    
    // MARK: Setup View
    private func setupView() {
        self.delegate = self
        self.tabBar.backgroundColor = UIColor.white
        
        playerView = PlayerViewController()
        if let view = playerView?.view {
            view.isHidden = true
            self.view.addSubview(view)
        }
    }
    
    private func setupTabBarController() {
        let homeVC = HomeViewController()
        let homeImage = UIImage(named: "home_icon.png")
        let homeBarItem = UITabBarItem(title: "Trang chủ", image: homeImage, tag: 0)
        homeVC.tabBarItem = homeBarItem
        let homeViewController = UINavigationController(rootViewController: homeVC)
        
        let searchVC = SearchViewController()
        let searchImage = UIImage(named: "search_icon.png")
        let searchBarItem = UITabBarItem(title: "Tìm kiếm", image: searchImage, tag: 1)
        searchVC.tabBarItem = searchBarItem
        let searchViewController = UINavigationController(rootViewController: searchVC)
        
        let favoritesVC = FavoritesViewController()
        let favoriteImage = UIImage(named: "favorite_icon.png")
        let favoriteBarItem = UITabBarItem(title: "Yêu thích", image: favoriteImage, tag: 2)
        favoritesVC.tabBarItem = favoriteBarItem
        let favoritesViewController = UINavigationController(rootViewController: favoritesVC)
        
        let bookmarkVC = BookmarkViewController()
        let bookMarkImage = UIImage(named: "reading_icon.png")
        let bookmarkBarItem = UITabBarItem(title: "Đang đọc", image: bookMarkImage, tag: 3)
        bookmarkVC.tabBarItem = bookmarkBarItem
        let bookmarkViewController = UINavigationController(rootViewController: bookmarkVC)
        
        self.viewControllers = [homeViewController, searchViewController, favoritesViewController, bookmarkViewController]
    }
    
    // MARK: Audio Player Events
    @objc func hideShowAudioPlayer(note: NSNotification) {
        if AudioPlayer.shared.sound != nil {
            if let title = AudioPlayer.shared.audio?.title {
                self.playerView?.miniAudioPlayerView.title = title
            }
            if let imgThumbnail = AudioPlayer.shared.imgThumbnail {
                self.playerView?.miniAudioPlayerView.urlThumnail = imgThumbnail
            }
            
            if AudioPlayer.shared.isPlaying {
                self.playerView?.miniAudioPlayerView.statusPlay = false
            } else {
                self.playerView?.miniAudioPlayerView.statusPlay = true
            }
            
            self.playerView?.view.isHidden = false
        } else {
            self.playerView?.view.isHidden = true
        }
    }
}

// MARK: UITabBarControllerDelegate
extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(String(describing: viewController.title))")
    }
}
