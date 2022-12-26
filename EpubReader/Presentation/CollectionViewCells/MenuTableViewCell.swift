//
//  MenuTableViewCell.swift
//  EpubReader
//
//  Created by mac on 25/09/2022.
//

import UIKit
import SnapKit

class MenuTableViewCell: UITableViewCell {

    var menuImage: UIImageView = {
        let menuImage = UIImageView()
        menuImage.contentMode = .scaleAspectFit
        menuImage.tintColor = UIColor.color(with: .background)
        return menuImage
    }()
    
    var title: UILabel = {
        let title = UILabel()
        title.textColor = .darkText
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.font = UIFont.font(with: .h4)
        if UIDevice.current.userInterfaceIdiom == .pad {
            title.font = UIFont.font(with: .h2)
        }
        return title
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
        self.setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(menuImage)
        self.contentView.addSubview(title)
    }
    
    private func setupConstraint() {
        menuImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(21)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(menuImage.snp.trailing).offset(16)
        }
    }
}
