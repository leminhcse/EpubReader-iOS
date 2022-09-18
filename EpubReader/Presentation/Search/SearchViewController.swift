//
//  SearchViewController.swift
//  EpubReader
//
//  Created by MacBook on 5/23/22.
//

import Foundation
import UIKit

class SearchViewController: BaseViewController {
    
    private var SearchBar: UISearchController = {
        let sb = UISearchController()
        sb.searchBar.placeholder = "Tìm sách"
        sb.searchBar.searchBarStyle = .minimal
        sb.searchBar.tintColor = .white
        return sb
    }()
       
    private var BookCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(BookCell.self, forCellWithReuseIdentifier: "BookCell")
//        cv.delegate = self
//        cv.dataSource = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tìm Kiếm"
        self.view.backgroundColor = UIColor.white
        
        SearchBar.searchResultsUpdater = self
        navigationItem.searchController = SearchBar
        
        self.view.addSubview(BookCollectionView)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
    }
}
