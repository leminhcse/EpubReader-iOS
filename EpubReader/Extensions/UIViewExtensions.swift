//
//  UIViewExtensions.swift
//  EpubReader
//
//  Created by MacBook on 5/24/22.
//

import UIKit
import SnapKit

extension UIView {
    
    func applyNavBarConstraints(size: CGSize) {
        let widthConstraint = self.widthAnchor.constraint(equalToConstant: size.width)
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: size.height)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }
}
