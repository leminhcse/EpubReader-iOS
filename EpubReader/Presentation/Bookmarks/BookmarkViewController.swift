//
//  BookmarkViewController.swift
//  EpubReader
//
//  Created by MacBook on 5/23/22.
//

import UIKit
import SnapKit

class BookmarkViewController: BaseViewController {
    
    // MARK: - UI Controls
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 41))
        label.center = CGPoint(x: 160, y: 285)
        label.textColor = UIColor.color(with: .background)
        label.textAlignment = .center
        label.text = "You are not currently reading any books"
        label.isHidden = false
        if UIDevice.current.userInterfaceIdiom == .pad {
            label.font = UIFont.font(with: .h1)
        } else {
            label.font = UIFont.font(with: .h3)
        }
        return label
    }()
    
    // MARK: UIViewController - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstranst()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        self.title = "Đang Đọc".uppercased()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(label)
        
        setupConstranst()
    }
    
    private func setupConstranst() {
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
