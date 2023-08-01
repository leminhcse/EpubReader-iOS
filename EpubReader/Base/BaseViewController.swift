//
//  BaseViewController.swift
//  EpubReader
//
//  Created by MacBook on 5/26/22.
//

import UIKit

class BaseViewController: UIViewController {
    
    let inset: CGFloat = 16
    var frameWidth: CGFloat = UIScreen.main.bounds.width
    var frameHeight: CGFloat = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.color(with: .darkColor)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
}
