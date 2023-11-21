//
//  UIFont.swift
//  EpubReader
//
//  Created by mac on 17/09/2022.
//

import UIKit

extension UIFont {
    
    enum FontStyle {
        case h0
        case h1
        case h2
        case h3
        case h4
        case h5
        case subtitle
        
        var size: CGFloat {
            let fontSize: CGFloat
            
            switch self {
            case .h0: fontSize = 48
            case .h1: fontSize = 32
            case .h2: fontSize = 24
            case .h3: fontSize = 20
            case .h4: fontSize = 16
            case .h5: fontSize = 14
            case .subtitle: fontSize = 12
            }
            return fontSize
        }
        
        var weight: UIFont.Weight {
            let weight: UIFont.Weight
            
            switch self {
            case .h0, .h1, .h2, .subtitle:
                weight = .semibold
            case .h3, .h4:
                weight = .medium
            case .h5:
                weight = .regular
            }
            return weight
        }
        
        var defaultFontName: String {
            switch self {
            case .h0, .h1, .h2, .h4, .h5: return "OpenSans-Bold"
            case .h3:
                return "OpenSans-Regular"
            case .subtitle: return "OpenSans-Regular"
            }
        }
    }
    
    static func font(with style: FontStyle) -> UIFont {
        return UIFont(name: style.defaultFontName, size: style.size) ?? UIFont.systemFont(ofSize: style.size, weight: style.weight)
    }
}
