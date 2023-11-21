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
        label.textColor = .black
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        if UIDevice.current.userInterfaceIdiom == .pad {
            label.font = UIFont.font(with: .h2)
        } else {
            label.font = UIFont.font(with: .h4)
        }
        return label
    }()
    
    public lazy var lbDescription: UILabel = {
        [unowned self] in
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkGray
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        if UIDevice.current.userInterfaceIdiom == .pad {
            label.font = UIFont.font(with: .h4)
        } else {
            label.font = UIFont.font(with: .h5)
        }
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
        var imageSize: CGFloat = 18
        var top: CGFloat = 6
        if UIDevice.current.userInterfaceIdiom == .pad {
            imageSize = 28
            top = 10
        }
        
        self.lbTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-12)
        }

        self.imgView.snp.makeConstraints { (make) in
            make.top.equalTo(lbTitle.snp.bottom).offset(6)
            make.size.equalTo(CGSize(width: imageSize, height: imageSize))
            make.centerX.equalTo(self.lbTitle.snp.centerX).offset(-26)
        }
        
        self.lbDescription.snp.makeConstraints { (make) in
            make.top.equalTo(lbTitle.snp.bottom).offset(top)
            make.leading.equalTo(self.imgView.snp.trailing).offset(4)
        }
        
    }
}
