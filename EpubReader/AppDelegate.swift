//
//  AppDelegate.swift
//  EpubReader
//
//  Created by MacBook on 5/23/22.
//

import UIKit
import FolioReaderKit
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var splashVC: SplashViewController?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        PermissionManager.shared.checkAndRequestPermission()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        _ = Reachability.shared
        
        splashVC = SplashViewController(splashScreenDismissed: {
            print("show splash")
        })
        window?.rootViewController = splashVC

        MusicPlayerHelper.setupAppAudioSession()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if !UserDefs.continueAudioInBackground {
            if AudioPlayer.shared.sound != nil {
                if AudioPlayer.shared.sound?.rate == 0.0 {
                    AudioPlayer.shared.sound = nil
                } else {
                    if AudioPlayer.shared.isPlaying {
                        AudioPlayer.shared.pause()
                    }
                }
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if !UserDefs.continueAudioInBackground {
            if AudioPlayer.shared.sound != nil {
                AudioPlayer.shared.play()
            }
        }
        
        if AudioPlayer.shared.sound != nil && !AudioPlayer.shared.isPlaying {
            AudioPlayer.shared.pause()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: FullScreenAudioPlayerViewController.UpdatePlayPauseNotification), object: nil)
        }
    }
}
