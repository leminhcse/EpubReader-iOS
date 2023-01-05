//
//  BookCell.swift
//  EpubReader
//
//  Created by MacBook on 6/5/22.
//

import UIKit
import SnapKit

class BookCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    
    private let imageCornerRadius = CGFloat(8)
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    private func setupView() {
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageCornerRadius
        imageView.backgroundColor = UIColor.color(with: .background).withAlphaComponent(0.2)
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.backgroundColor = .clear
        titleLabel.numberOfLines = 2
        titleLabel.sizeToFit()
        titleLabel.font = UIFont.font(with: .h4)
        
        subtitleLabel = UILabel()
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.numberOfLines = 1
        subtitleLabel.sizeToFit()
        subtitleLabel.font = UIFont.font(with: .h5)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
    }
    
    private func setupConstraints() {
        let cellWidth = self.frame.size.width
        let cellHeight = self.frame.size.height
        let titleViewHeight = CGFloat(48)
        
        imageView.snp.makeConstraints{ (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(cellWidth)
            make.height.equalTo(cellHeight - titleViewHeight - 24)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(6)
            make.width.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(6)
            make.width.equalToSuperview()
            make.height.equalTo(titleViewHeight/2)
        }
    }
}
