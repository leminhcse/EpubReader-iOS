//
//  UIColorExtensions.swift
//  EpubReader
//
//  Created by MacBook on 5/26/22.
//

import UIKit

extension UIColor {
    
    enum ColorScheme:  String {
        case Dark = "Dark"
        case Light = "Light"
    }
    
    enum ColorStyle {
        case background
        case darkColor
        case hightlight
        case backgroundFullScreenAudioPlayer
        case primaryItem
        case primaryElevation
        case backgroudTransparent
        
        fileprivate var lightModeColor: UIColor {
            let color: UIColor
            switch self {
            case .background:
                color = UIColor(hex: "#2d4170")
            case .darkColor:
                color = UIColor(hex: "#484848")
            case .hightlight:
                color = UIColor(hex: "#2d4170")
            case .backgroundFullScreenAudioPlayer:
                color = UIColor(hex: "#FEFEFE")
            case .backgroudTransparent:
                color = UIColor(hex: "#FEFEFE")
            case .primaryItem:
                color = UIColor(hex: "#484848")
            case .primaryElevation:
                color = UIColor(hex: "#FFFFFF")
            }
            return color
        }
        
        fileprivate var darkModeColor: UIColor {
            let color: UIColor
            switch self {
            case .background:
                color = UIColor(hex: "#2d4170")
            case .darkColor:
                color = UIColor(hex: "#484848")
            case .hightlight:
                color = UIColor(hex: "#2d4170")
            case .backgroundFullScreenAudioPlayer:
                color = UIColor(hex: "#FEFEFE")
            case .backgroudTransparent:
                color = UIColor(hex: "#FEFEFE")
            case .primaryItem:
                color = UIColor(hex: "#484848")
            case .primaryElevation:
                color = UIColor(hex: "#171717")
            }
            return color
        }
    }
    
    static func color(with style: ColorStyle) -> UIColor {
        return style.lightModeColor
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(hex: String) {
        var hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (hexString.hasPrefix("#")) {
            hexString.remove(at: hexString.startIndex)
        }
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    static func color(with style: ColorStyle, colorScheme: ColorScheme? = nil) -> UIColor {
        if colorScheme == .Light || colorScheme == nil {
            return style.lightModeColor
        } else {
            return style.darkModeColor
        }
    }
    
    static func primaryTextColor(traitCollection: UITraitCollection) -> UIColor {
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                return UIColor.color(with: .primaryElevation, colorScheme: .Dark)
            } else {
                return UIColor.color(with: .primaryElevation, colorScheme: .Light)
            }
        } else {
            return UIColor.color(with: .primaryElevation, colorScheme: .Dark)
        }
    }
}
