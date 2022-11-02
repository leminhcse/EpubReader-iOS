//
//  BookmarkViewController.swift
//  EpubReader
//
//  Created by MacBook on 5/23/22.
//

import UIKit

class BookmarkViewController: BaseViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 41))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "Bookmark View"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Đang Đọc".uppercased()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(label)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
