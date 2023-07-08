//
//  UILabelExtensions.swift
//  EpubReader
//
//  Created by mac on 18/06/2023.
//

import UIKit

extension UILabel {

    func addCharacterSpacing(kernValue: Double = -0.5) {
        guard let labelText = text, labelText.isNotEmpty() else { return }
        
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern,
                                      value: kernValue,
                                      range: NSRange(location: 0, length: attributedString.length - 1))
        attributedText = attributedString
    }
}
