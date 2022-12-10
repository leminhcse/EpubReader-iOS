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
    
    // MARK: - UI Controls
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .default
        searchBar.placeholder = " Tìm sách....."
        searchBar.sizeToFit()
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
        
        self.title = "Tìm Kiếm".uppercased()
        self.view.backgroundColor = UIColor.white
        
        bookTableView.delegate = self
        bookTableView.dataSource = self
        searchBar.delegate = self
        
        self.view.addSubview(searchBar)
        self.view.addSubview(bookTableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraint()
    }
    
    // MARK: Setup UI
    private func setupConstraint() {
        let safeAreaTop = self.view.safeAreaInsets.top
        let searchTop = safeAreaTop
        
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(searchTop)
            make.height.equalTo(56)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        bookTableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(CGSize(width: frameWidth, height: frameHeight))
        }
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
