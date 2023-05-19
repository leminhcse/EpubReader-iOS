//
//  ScienceTechnologyViewController.swift
//  EpubReader
//
//  Created by mac on 10/09/2022.
//

import UIKit
import RxSwift

class ScienceTechnologyViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var flowLayout = UICollectionViewFlowLayout()
    private var bookViewModel = BookViewModel()
    
    private let inset: CGFloat = 16
    private let screenWidth = UIScreen.main.bounds.width - 24
    
    private let disposeBag = DisposeBag()
    private var listScienceBook = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadData(_:)),
                                               name: NSNotification.Name(rawValue: EpubReaderHelper.ReloadDataNotification),
                                               object: nil)
        
        setupView()
        loadData()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.white
        
        let tabBarHeight: CGFloat = self.tabBarController?.tabBar.frame.size.height ?? 64
        let bottom = tabBarHeight + inset*9
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(hex: "#FEFEFE")
        collectionView.contentInset = .init(top: inset, left: inset, bottom: bottom, right: inset)
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: "BookCell")
        collectionView.layoutIfNeeded()
        view.addSubview(collectionView)
    }
    
    private func loadData() {
        bookViewModel.getBookList()
    }
    
    @objc func reloadData(_ notification: NSNotification) {
        if bookViewModel.listBook.count > 0 {
            self.listScienceBook.removeAll()
            self.listScienceBook = bookViewModel.listBook.filter({$0.type == "5"})
            self.collectionView.reloadData()
        }
    }
}

extension ScienceTechnologyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listScienceBook.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        let book = self.listScienceBook[indexPath.row]
        cell.configure(book: book)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = self.listScienceBook[indexPath.row]
        let viewController = BookDetailViewController(book: book)
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        tabBarController?.present(viewController, animated: true)
    }
}

extension ScienceTechnologyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.isPad {
            return CGSize(width: screenWidth / 3 - inset*2, height: (screenWidth / 2) + inset)
        }
        return CGSize(width: screenWidth / 2 - inset, height: (screenWidth / 2)*5/4 + inset*5)
    }
}
