//
//  UIApplicationExtension.swift
//  EpubReader
//
//  Created by mac on 14/08/2022.
//

import UIKit

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let tabCount = tabController.tabBar.items?.count, let vcCount = tabController.viewControllers?.count {
                let index = (vcCount > tabCount) ? tabCount - 1 : tabCount
                if tabController.selectedIndex < index {
                    if let selected = tabController.selectedViewController {
                        return topViewController(controller: selected)
                    }
                } else {
                    return topViewController(controller: tabController.moreNavigationController.visibleViewController)
                }
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
