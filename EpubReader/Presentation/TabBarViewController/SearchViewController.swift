//
//  SearchViewController.swift
//  EpubReader
//
//  Created by MacBook on 5/23/22.
//

import Foundation
import UIKit
import SnapKit

class SearchViewController: BaseViewController {
    
    //MARK: - Local variables
    private var searchResults: [Book] = []
    private var bookViewModel = BookViewModel()
    
    var keyboardActive = false
    var keyboardHeight: CGFloat!
    
    // MARK: - UI Controls
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = " Tên sách, tên tác giả"
        searchBar.sizeToFit()
        searchBar.searchTextField.layer.cornerRadius = 20
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.setLeftImage(with: 12)
        return searchBar
    }()
    
    private lazy var bookTableView: UITableView = {
        let tabBarHeight: CGFloat = self.tabBarController?.tabBar.frame.size.height ?? 64
        let bottom = tabBarHeight + inset*9
        let bookTableView = UITableView()
        bookTableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookTableViewCell")
        bookTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        bookTableView.separatorInset = .zero
        bookTableView.backgroundColor = .clear
        bookTableView.contentInset = .init(top: 0, left: 0, bottom: bottom, right: 0)
        return bookTableView
    }()
    
    // MARK: UIViewController - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(_:)),
                                               name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name:UIResponder.keyboardWillHideNotification, object: nil)
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraint()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        
        bookTableView.delegate = self
        bookTableView.dataSource = self
        searchBar.delegate = self

        self.view.addSubview(searchBar)
        self.view.addSubview(bookTableView)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func setupConstraint() {
        let safeAreaTop = self.view.safeAreaInsets.top
        let searchTop = safeAreaTop
        let padding: CGFloat = 24
        
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(searchTop)
            make.height.equalTo(64)
            make.size.equalTo(CGSize(width: frameWidth - padding, height: 64))
            make.centerX.equalToSuperview()
        }
        
        bookTableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(CGSize(width: frameWidth - padding, height: frameHeight))
        }
    }
    
    @objc func dismissKeyboard() {
        keyboardActive = false
        self.view.endEditing(true)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard self.view.frame.origin.y >= 0 else {
            return
        }
        print("keyboard will show")
        keyboardHeight = CGFloat(0)
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            print("Keyboard height is \(String(describing: keyboardHeight))")
        }
        keyboardActive = true
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        print("keyboard will hide")
        keyboardActive = false
        keyboardHeight = 0
        self.searchBar.snp.removeConstraints()
        self.bookTableView.snp.removeConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.bookTableView.resignFirstResponder()
    }
}

//MARK: - Extension with UISearchBarDelegate, UISearchControllerDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel search")
        self.searchBar.text = ""
        self.searchResults.removeAll()
        self.bookTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Key search is: \(searchText)")
        if searchText != "" {
            bookViewModel.getResultSearch(keySearch: searchText) { success in
                if success == true {
                    self.searchResults = self.bookViewModel.resultSearch
                    self.bookTableView.isHidden = false
                    self.bookTableView.reloadData()
                }
            }
        } else {
            print("clear search")
            self.searchResults.removeAll()
            self.bookTableView.reloadData()
        }
    }
}

//MARK: - Extension with UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
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
        let book = self.searchResults[indexPath.row]
        cell.configure(book: book)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = self.searchResults[indexPath.row]
        let viewController = BookDetailViewController(book: book)
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        tabBarController?.present(viewController, animated: true)
    }
}
