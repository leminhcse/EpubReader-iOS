//
//  UIScreenExtensions.swift
//  EpubReader
//
//  Created by mac on 22/08/2022.
//

import UIKit

extension UIScreen {
    static var hasSafeAreaInsets: Bool {
        return UIApplication.shared.delegate?.window??.safeAreaInsets != .zero
    }
    
    static var hasTopNotch: Bool {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
    }
}
