//
//  UITextFieldExtensions.swift
//  EpubReader
//
//  Created by mac on 03/08/2023.
//

import UIKit

extension UITextField {
    func setLeftImage(with padding: CGFloat = 0) {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.tintColor = .gray
        
        if padding != 0 {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fill
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            let paddingView = UIView()
            paddingView.translatesAutoresizingMaskIntoConstraints = false
            paddingView.widthAnchor.constraint(equalToConstant: padding).isActive = true
            paddingView.heightAnchor.constraint(equalToConstant: padding).isActive = true
            stackView.addArrangedSubview(paddingView)
            stackView.addArrangedSubview(imageView)
            self.leftView = stackView
        } else {
            self.leftView = imageView
        }
    }
}
