//
//  MenuTableViewCell.swift
//  EpubReader
//
//  Created by mac on 25/09/2022.
//

import UIKit
import SnapKit

class MenuTableViewCell: UITableViewCell {

    var title: UILabel = {
        let title = UILabel()
        title.font = UIFont.font(with: .h4)
        title.textColor = .darkText
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
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
        self.contentView.addSubview(title)
    }
    
    private func setupConstraint() {
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(21)
            make.trailing.equalToSuperview().inset(21)
        }
    }

}
