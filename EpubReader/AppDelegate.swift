//
//  AppDelegate.swift
//  EpubReader
//
//  Created by MacBook on 5/23/22.
//

import UIKit
import FolioReaderKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var mainTabBarController = MainTabBarViewController()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let controller = MainTabBarViewController()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        AppAppearanceDesigner.updateNavigationBarAppearance()
        AppAppearanceDesigner.updateTabBarAppearance()
        AppAppearanceDesigner.updateScrollableSegmentedControl()
        
        return true
    }
}

