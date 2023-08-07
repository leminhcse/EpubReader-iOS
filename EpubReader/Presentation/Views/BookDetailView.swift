//
//  BookDetailView.swift
//  EpubReader
//
//  Created by mac on 07/08/2023.
//

import UIKit
import SnapKit

class BookDetailView: UIView {
    
    public lazy var imgView: UIImageView = {
        [unowned self] in
        let imgView = UIImageView()
        imgView.backgroundColor = .clear
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    public lazy var lbTitle: UILabel = {
        [unowned self] in
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.font(with: .h3)
        label.textColor = .black
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    public lazy var lbDescription: UILabel = {
        [unowned self] in
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.font(with: .h5)
        label.textColor = .darkGray
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupConstraint()
    }

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        self.addSubview(self.lbTitle)
        self.addSubview(self.imgView)
        self.addSubview(self.lbDescription)
    }
    
    fileprivate func setupConstraint() {
        self.lbTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.top.equalTo(lbTitle.snp.bottom).offset(6)
            make.size.equalTo(CGSize(width: 18, height: 18))
            make.centerX.equalTo(self.lbTitle.snp.centerX).offset(-24)
        }
        
        self.lbDescription.snp.makeConstraints { (make) in
            make.top.equalTo(lbTitle.snp.bottom).offset(6)
            make.leading.equalTo(self.imgView.snp.trailing).offset(4)
        }
        
    }
}
