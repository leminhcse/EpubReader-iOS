//
//  BookDownloadsViewController.swift
//  EpubReader
//
//  Created by mac on 11/12/2022.
//

import UIKit
import SnapKit

class BookDownloadsViewController: BaseViewController {
    
    // MARK: - UI Controls
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 41))
        label.center = CGPoint(x: 160, y: 285)
        label.textColor = UIColor.color(with: .background)
        label.textAlignment = .center
        label.text = "Bạn chưa tải bất kì cuốn sách nào!"
        label.isHidden = true
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
    
    private var downloadBooks = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadData),
                                               name: NSNotification.Name(rawValue: EpubReaderHelper.RemoveBookSuccessNotification),
                                               object: nil)
        
        setupUI()
        setupConstranst()
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstranst()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        self.title = "Sách đã tải".uppercased()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(label)
        self.view.addSubview(bookTableView)
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
    
    // MARK: Handle favorite data
    @objc private func loadData() {
        downloadBooks = EpubReaderHelper.shared.downloadBooks
        if downloadBooks.count > 0 {
            self.bookTableView.isHidden = false
            self.label.isHidden = true
        } else {
            self.bookTableView.isHidden = true
            self.label.isHidden = false
        }
    }
}

extension BookDownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadBooks.count
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
        let book = downloadBooks[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(book: book)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = downloadBooks[indexPath.row]
        let viewController = BookDetailViewController(book: book)
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        if let tabBarController = self.tabBarController {
            tabBarController.present(viewController, animated: true, completion: nil)
        } else {
            present(viewController, animated: true, completion: nil)
        }
    }
}
