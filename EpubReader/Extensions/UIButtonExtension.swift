//
//  UIButtonExtension.swift
//  EpubReader
//
//  Created by mac on 29/06/2022.
//

import Foundation
import UIKit

enum ButtonStyle {
    case downArrow
    case favorite
}

extension UIButton {
    
    func style(with buttonStyle: ButtonStyle) {
        switch buttonStyle {
        case .downArrow:
            let inset: CGFloat = 28
            let imageName = "chevron_down.png"
            let downArrowIcon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            setImage(downArrowIcon, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        case .favorite:
            let inset: CGFloat = 28
            let imageName = "fi_heart.png"
            let downArrowIcon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            setImage(downArrowIcon, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        }
    }
    
}
