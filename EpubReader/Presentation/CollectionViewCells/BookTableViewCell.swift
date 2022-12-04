//
//  BookTableViewCell.swift
//  EpubReader
//
//  Created by mac on 26/09/2022.
//

import UIKit
import SnapKit

class BookTableViewCell: UITableViewCell {
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = CGFloat(6)
        image.backgroundColor = .clear
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        if UIDevice.current.userInterfaceIdiom == .pad {
            titleLabel.font = UIFont.font(with: .h2)
        } else {
            titleLabel.font = UIFont.font(with: .h4)
        }
        titleLabel.textColor = .darkText
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    private lazy var composerLabel: UILabel = {
        let composerLabel = UILabel()
        if UIDevice.current.userInterfaceIdiom == .pad {
            composerLabel.font = UIFont.font(with: .h3)
        } else {
            composerLabel.font = UIFont.font(with: .h5)
        }
        composerLabel.textColor = .darkGray
        composerLabel.adjustsFontSizeToFitWidth = true
        composerLabel.minimumScaleFactor = 0.5
        composerLabel.numberOfLines = 1
        return composerLabel
    }()
    
    private lazy var pageLabel: UILabel = {
        let pageLabel = UILabel()
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageLabel.font = UIFont.font(with: .h3)
        } else {
            pageLabel.font = UIFont.font(with: .h5)
        }
        pageLabel.textColor = .darkGray
        pageLabel.textAlignment = .center
        pageLabel.backgroundColor = .systemGray.withAlphaComponent(0.25)
        pageLabel.adjustsFontSizeToFitWidth = true
        pageLabel.minimumScaleFactor = 0.5
        pageLabel.numberOfLines = 1
        pageLabel.isHidden = true
        return pageLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(image)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(composerLabel)
        self.contentView.addSubview(pageLabel)
    }
    
    private func setupConstraints() {
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        var imageWidth = width/5 + 24
        var imageHeight = height*2 + 48
        var titleWidth = width - imageWidth
        var titleHeight = height/3
        var titleY = CGFloat(36)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            imageWidth = width/5 + 96
            imageHeight = height*2 + 144
            titleWidth = titleWidth*2
            titleHeight = titleHeight*1.5
            titleY = CGFloat(58)
        }
        
        image.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: imageWidth, height: imageHeight))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.size.equalTo(CGSize(width: titleWidth, height: titleHeight*2))
            make.top.equalToSuperview().offset(titleY)
        }
        
        composerLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.size.equalTo(CGSize(width: titleWidth, height: titleHeight))
        }
        
        pageLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.top.equalTo(composerLabel.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: titleWidth/2, height: titleHeight + 8))
        }
        
    }
    
    public func configure(book: Book) {
        DispatchQueue.main.async {
            if let url = URL(string: book.thumbnail) {
                self.image.kf_setImage(url: url) { _ in
                    let imageWidth = self.image.image?.size.width ?? 0
                    let imageHeight = self.image.image?.size.height ?? 0
                    if imageHeight > imageWidth {
                        self.image.backgroundColor = .clear
                    }
                }
            }
        }
        titleLabel.text = book.title
        composerLabel.text = book.composer
    }
    
    public func configure(book: Book, pageNumber: Int) {
        DispatchQueue.main.async {
            if let url = URL(string: book.thumbnail) {
                self.image.kf_setImage(url: url) { _ in
                    let imageWidth = self.image.image?.size.width ?? 0
                    let imageHeight = self.image.image?.size.height ?? 0
                    if imageHeight > imageWidth {
                        self.image.backgroundColor = .clear
                    }
                }
            }
        }
        titleLabel.text = book.title
        composerLabel.text = book.composer
        pageLabel.isHidden = false
        pageLabel.text = "Đã đọc \(pageNumber) trang"
    }
}
