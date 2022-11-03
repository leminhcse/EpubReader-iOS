//
//  BaseViewController.swift
//  EpubReader
//
//  Created by MacBook on 5/26/22.
//

import UIKit

class BaseViewController: UIViewController {
    
    let inset: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.backgroundColor =  UIColor.color(with: .background)
        navigationController?.navigationBar.barTintColor = UIColor.color(with: .background)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
}
