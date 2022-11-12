//
//  Utils.swift
//  EpubReader
//
//  Created by mac on 07/11/2022.
//

import UIKit

class Utils {

    class func estimatedWidthOfLabel(text: String, font: UIFont, height: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
    
    class func getLengthMaxOfTextArray(arrStr: [String], font: UIFont, height: CGFloat) -> CGFloat {
        var stringMax = String()
        var count : Int = 0
        for value in arrStr {
            if count <= value.count {
                count = value.count
                stringMax = value
            }
        }
        return Utils.estimatedWidthOfLabel(text: stringMax, font: font, height: height)
    }
}
