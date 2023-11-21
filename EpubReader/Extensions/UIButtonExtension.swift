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
    case profile
    case more
    case close
    case view
    case delete
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
            let inset: CGFloat = 8
            let imageName = "fi_heart.png"
            let favoriteIcon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            setImage(favoriteIcon, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        case .profile:
            let inset: CGFloat = 0
            let imageName = "ic_next.png"
            let profileIcon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            setImage(profileIcon, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: inset)
        case .more:
            let inset: CGFloat = 0
            let imageName = "ic_more.png"
            let moreIcon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            setImage(moreIcon, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: inset)
        case .close:
            let inset: CGFloat = 0
            let imageName = "close_button.png"
            let closeIcon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            setImage(closeIcon, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: inset)
        case .view:
            let inset: CGFloat = 28
            let imageName = "ic_view.png"
            let viewIcon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            setImage(viewIcon, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        case .delete:
            let inset: CGFloat = 8
            let imageName = "trash.png"
            let trashIcon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            setImage(trashIcon, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        }
    }
    
    func customButton(title: String) {
        var fontStyle = UIFont.font(with: .h5)
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontStyle = UIFont.font(with: .h2)
        }
        let textRange = NSMakeRange(0, title.count)
        let attributedText = NSMutableAttributedString(string: title)
        attributedText.addAttributes([.foregroundColor: UIColor.darkGray, .font: fontStyle], range: textRange)
        self.setAttributedTitle(attributedText, for: .normal)
    }
}
