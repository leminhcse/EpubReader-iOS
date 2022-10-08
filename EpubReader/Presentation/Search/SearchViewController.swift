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
    
    var frameWidth: CGFloat = UIScreen.main.bounds.width
    var frameHeight: CGFloat = UIScreen.main.bounds.height
    
    // MARK: - UI Controls
    private lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var searchController: UISearchController = {
        let sb = UISearchController()
        sb.searchBar.placeholder = "Tìm sách"
        sb.searchBar.searchBarStyle = .default
        sb.searchBar.tintColor = .white
        sb.searchBar.layer.borderWidth = 2
        sb.searchBar.layer.borderColor = UIColor.clear.cgColor
        return sb
    }()
    
    private lazy var bookTableView: UITableView = {
        let bookTableView = UITableView()
        bookTableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookTableViewCell")
        bookTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        bookTableView.separatorInset = .zero
        bookTableView.backgroundColor = .white
        return bookTableView
    }()
    
    // MARK: UIViewController - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tìm Kiếm"
        self.view.backgroundColor = UIColor.white
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.orange
        searchController.searchBar.barTintColor = UIColor.white
        
        searchView.addSubview(searchController.searchBar)
        searchController.delegate = self
        
        bookTableView.backgroundColor = UIColor.white
        bookTableView.delegate = self
        bookTableView.dataSource = self
        
        self.view.addSubview(searchView)
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
        
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(searchTop)
            make.height.equalTo(56)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        bookTableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(CGSize(width: frameWidth, height: frameHeight))
        }
    }
}

//MARK: - Extension with UISearchBarDelegate, UISearchControllerDelegate
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        if searchText != "" {
            bookViewModel.getResultSearch(keySearch: searchText) { success in
                if success == true {
                    self.searchResults = self.bookViewModel.resultSearch
                    self.bookTableView.isHidden = false
                    self.bookTableView.reloadData()
                }
            }
        }
    }
       
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchResults.removeAll()
        self.bookTableView.isHidden = true
    }
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       // Click on search button on keyboard
    }
}

//MARK: - Extension with UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
