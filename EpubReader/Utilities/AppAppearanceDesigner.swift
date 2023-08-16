//
//  AppAppearanceDesigner.swift
//  EpubReader
//
//  Created by MacBook on 5/26/22.
//

import UIKit
import ScrollableSegmentedControl

struct AppAppearanceDesigner {
    
    static func updateNavigationBarAppearance() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.color(with: .darkColor)]
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.left
            paragraphStyle.lineBreakMode = .byTruncatingTail

            UINavigationBar.appearance().tintColor = UIColor.color(with: .darkColor)
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    static func updateTabBarAppearance() {
        let appearance = UITabBar.appearance()
        appearance.unselectedItemTintColor = UIColor.color(with: .darkColor)
        appearance.tintColor = UIColor.color(with: .background)
        appearance.barTintColor = UIColor.white
        appearance.isTranslucent = false
    }
    
    static func updateScrollableSegmentedControl() {
        let segmentedControlAppearance = ScrollableSegmentedControl.appearance()
        segmentedControlAppearance.segmentContentColor = UIColor.black
        segmentedControlAppearance.selectedSegmentContentColor = UIColor.color(with: .background)
        segmentedControlAppearance.backgroundColor = UIColor.white
    }
}
