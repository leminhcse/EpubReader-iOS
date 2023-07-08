//
//  ActionButton.swift
//  EpubReader
//
//  Created by mac on 18/06/2023.
//

import UIKit

class ActionButton: UIView {

    public lazy var imgView: UIImageView = {
        [unowned self] in
        let view: UIImageView = UIImageView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public lazy var lbDescription: UILabel = {
        [unowned self] in
        let label: UILabel = UILabel()
        label.backgroundColor = .blue
        label.textAlignment = .center
        label.font = UIFont.font(with: .h5)
        label.textColor = .darkGray
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    public lazy var btnAction: UIButton = {
        [unowned self] in
        let btn: UIButton = UIButton()
        btn.backgroundColor = .clear
        return btn
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
        self.addSubview(self.imgView)
        self.addSubview(self.btnAction)
        self.addSubview(self.lbDescription)
    }
    
    fileprivate func setupConstraint() {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([NSLayoutConstraint(item: imgView,
                                                        attribute: NSLayoutConstraint.Attribute.centerX,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: self,
                                                        attribute: NSLayoutConstraint.Attribute.centerX,
                                                        multiplier: 1,
                                                        constant: 0),
                                     NSLayoutConstraint(item: imgView,
                                                        attribute: NSLayoutConstraint.Attribute.centerY,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: self,
                                                        attribute: NSLayoutConstraint.Attribute.centerY,
                                                        multiplier: 1,
                                                        constant: -7),
                                     NSLayoutConstraint(item: imgView,
                                                        attribute: NSLayoutConstraint.Attribute.width,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: nil,
                                                        attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                        multiplier: 1,
                                                        constant: 32),
                                     NSLayoutConstraint(item: imgView,
                                                        attribute: NSLayoutConstraint.Attribute.height,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: nil,
                                                        attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                        multiplier: 1,
                                                        constant: 26)])
        
        lbDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([NSLayoutConstraint(item: lbDescription,
                                                        attribute: NSLayoutConstraint.Attribute.top,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: imgView,
                                                        attribute: NSLayoutConstraint.Attribute.bottom,
                                                        multiplier: 1,
                                                        constant: 4),
                                     NSLayoutConstraint(item: lbDescription,
                                                        attribute: NSLayoutConstraint.Attribute.leading,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: self,
                                                        attribute: NSLayoutConstraint.Attribute.leading,
                                                        multiplier: 1,
                                                        constant: 4),
                                     NSLayoutConstraint(item: lbDescription,
                                                        attribute: NSLayoutConstraint.Attribute.trailing,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: self,
                                                        attribute: NSLayoutConstraint.Attribute.trailing,
                                                        multiplier: 1,
                                                        constant: 4)])
        
        btnAction.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([NSLayoutConstraint(item: btnAction,
                                                        attribute: NSLayoutConstraint.Attribute.top,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: self,
                                                        attribute: NSLayoutConstraint.Attribute.top,
                                                        multiplier: 1,
                                                        constant: 0),
                                     NSLayoutConstraint(item: btnAction,
                                                        attribute: NSLayoutConstraint.Attribute.bottom,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: self,
                                                        attribute: NSLayoutConstraint.Attribute.bottom,
                                                        multiplier: 1,
                                                        constant: 0),
                                     NSLayoutConstraint(item: btnAction,
                                                        attribute: NSLayoutConstraint.Attribute.leading,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: self,
                                                        attribute: NSLayoutConstraint.Attribute.leading,
                                                        multiplier: 1,
                                                        constant: 0)])
    }
}
