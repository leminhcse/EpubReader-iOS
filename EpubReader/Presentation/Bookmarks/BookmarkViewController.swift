//
//  BookmarkViewController.swift
//  EpubReader
//
//  Created by MacBook on 5/23/22.
//

import UIKit
import SnapKit

class BookmarkViewController: BaseViewController {
    
    private var readingBook = [ReadingBook]()
    private var bookViewModel = BookViewModel()
    
    // MARK: - UI Controls
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 41))
        label.center = CGPoint(x: 160, y: 285)
        label.textColor = UIColor.color(with: .background)
        label.textAlignment = .center
        label.text = "Bạn hiện chưa đọc bất kỳ cuốn sách nào"
        label.isHidden = false
        if UIDevice.current.userInterfaceIdiom == .pad {
            label.font = UIFont.font(with: .h1)
        } else {
            label.font = UIFont.font(with: .h3)
        }
        return label
    }()
    
    private lazy var bookTableView: UITableView = {
        let tabBarHeight: CGFloat = self.tabBarController?.tabBar.frame.size.height ?? 64
        let bottom = tabBarHeight + inset*9
        let bookTableView = UITableView()
        bookTableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookTableViewCell")
        bookTableView.delegate = self
        bookTableView.dataSource = self
        bookTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        bookTableView.separatorInset = .zero
        bookTableView.backgroundColor = .clear
        bookTableView.contentInset = .init(top: 0, left: 0, bottom: bottom, right: 0)
        bookTableView.isHidden = true
        return bookTableView
    }()
    
    // MARK: UIViewController - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadData),
                                               name: NSNotification.Name(rawValue: EpubReaderHelper.GetReadingBookSuccessNotification),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadData),
                                               name: NSNotification.Name(rawValue: EpubReaderHelper.GetReadingBookFailedNotification),
                                               object: nil)
        setupUI()
        loadData()
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
        self.view.addSubview(bookTableView)
        
        setupConstranst()
    }
    
    private func setupConstranst() {
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        bookTableView.snp.makeConstraints{ (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(112)
            make.size.equalTo(CGSize(width: frameWidth, height: frameHeight))
        }
    }
    
    private func loadData() {
        bookViewModel.getReadingBook()
    }
    
    @objc func reloadData() {
        let count = EpubReaderHelper.shared.readingBook.count
        if count > 0 {
            self.readingBook.removeAll()
            self.readingBook = EpubReaderHelper.shared.readingBook
            self.bookTableView.reloadData()
            self.label.isHidden = true
            self.bookTableView.isHidden = false
        } else {
            self.label.isHidden = false
            self.bookTableView.isHidden = true
        }
    }
}

//MARK: - Extension with UITableView
extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.readingBook.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 250
        } else {
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as! BookTableViewCell
        let readingBook = self.readingBook[indexPath.row]
        cell.selectionStyle = .none
        if let book = readingBook.book {
            cell.configure(book: book, pageNumber: readingBook.currentPage)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let readingBook = self.readingBook[indexPath.row]
        if let book = readingBook.book {
            let viewController = BookDetailViewController(book: book)
            viewController.providesPresentationContextTransitionStyle = true
            viewController.definesPresentationContext = true
            viewController.modalPresentationStyle = .overCurrentContext
            tabBarController?.present(viewController, animated: true)
        }
    }
}
