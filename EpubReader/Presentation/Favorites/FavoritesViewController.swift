//
//  FavoritesViewController.swift
//  EpubReader
//
//  Created by MacBook on 5/23/22.
//

import Foundation
import UIKit
import SnapKit

class FavoritesViewController: BaseViewController {
    
    var frameWidth: CGFloat = UIScreen.main.bounds.width
    var frameHeight: CGFloat = UIScreen.main.bounds.height
    
    private var favoritedBooks = [Book]()
    private var bookViewModel = BookViewModel()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 41))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "Favorites View"
        return label
    }()
    
    private lazy var bookTableView: UITableView = {
        let bookTableView = UITableView()
        bookTableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookTableViewCell")
        bookTableView.delegate = self
        bookTableView.dataSource = self
        bookTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        bookTableView.separatorInset = .zero
        bookTableView.backgroundColor = .clear
        return bookTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadData(_:)),
                                               name: NSNotification.Name(rawValue: EpubReaderHelper.ReloadDataNotification),
                                               object: nil)
        
        self.title = "Yêu Thích"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(bookTableView)
        
        setupConstranst()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstranst()
    }
    
    private func setupConstranst() {
        bookTableView.snp.makeConstraints{ (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(CGSize(width: frameWidth, height: frameHeight))
        }
    }
    
    private func loadData() {
        bookViewModel.getFavoritesBook(userId: "1")
    }
    
    @objc func reloadData(_ notification: NSNotification) {
        if bookViewModel.favoritesBook.count > 0 {
            self.favoritedBooks.removeAll()
            self.favoritedBooks = bookViewModel.favoritesBook//.filter({$0.type == "3"})
            self.bookTableView.reloadData()
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoritedBooks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as! BookTableViewCell
        let book = self.favoritedBooks[indexPath.row]
        cell.configure(book: book)
        return cell
    }
}
