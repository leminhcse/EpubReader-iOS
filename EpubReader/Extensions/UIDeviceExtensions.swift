//
//  UIDeviceExtensions.swift
//  EpubReader
//
//  Created by MacBook on 6/5/22.
//

import UIKit

extension UIDevice {
    
    class var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    class var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
