//
//  BannerHelper.swift
//  EpubReader
//
//  Created by mac on 08/12/2022.
//

import Foundation
import SnapKit

enum BannerNotification {
    
    case downloadSuccessful(title: String)
    case downloadDeleted(title: String)
    case addedToMyList
    case removedFromMyList
    case addedToFavourites
    case removedFromFavourites
    case noInternetConnection
    case notLoggedIn
    
    func present() {
        DispatchQueue.main.async {
            self.banner.show(duration: 3)
        }
    }
    
    var banner: Banner {
        let banner = Banner(title: nil,
                            subtitle: subtitle,
                            image: nil,
                            backgroundColor: backgroundColor,
                            didTapBlock: nil)
        switch self {
        default: banner.imageView.tintColor = UIColor.color(with: .primaryItem)
        }
        banner.detailLabel.textColor = UIColor.color(with: .primaryItem)
        banner.titleLabel.textColor = UIColor.color(with: .primaryItem)
        banner.detailLabel.font = UIFont.font(with: .h4)
        return banner
    }
    
    private var subtitle: String? {
        switch self {
        case .downloadSuccessful(let title): return "\("Đã tải ") \(title) \("thành công!")"
        case .downloadDeleted(let title): return "\(title) \("đã được xóa! ")"
        case .addedToMyList: return "\("Successfully added to")"
        case .removedFromMyList: return "\("Removed from")"
        case .addedToFavourites: return "\("Đã thêm vào danh sách yêu thích")"
        case .removedFromFavourites: return "\("Đã xóa khỏi danh sách yêu thích")"
        case .noInternetConnection: return NSLocalizedString("Không kết nối internet", comment:"")
        case .notLoggedIn: return NSLocalizedString("Please login or subscribe.", comment:"")
        }
    }
    
    private var backgroundColor: UIColor {
        UIColor.color(with: .backgroudTransparent).withAlphaComponent(0.8)
    }
}
