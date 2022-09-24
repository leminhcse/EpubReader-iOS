//
//  SkillsViewController.swift
//  EpubReader
//
//  Created by MacBook on 6/4/22.
//

import UIKit
import RxSwift

class SkillsViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var flowLayout = UICollectionViewFlowLayout()
    private var bookViewModel = BookViewModel()
    
    private let inset: CGFloat = 16
    private let screenWidth = UIScreen.main.bounds.width - 24
    
    private let disposeBag = DisposeBag()
    private var listSkillBook = [Book]()
    
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
            self.listSkillBook.removeAll()
            self.listSkillBook = bookViewModel.listBook.filter({$0.type == "1"})
            self.collectionView.reloadData()
        }
    }
}

extension SkillsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listSkillBook.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        let book = self.listSkillBook[indexPath.row]

        DispatchQueue.main.async {
            if let url = URL(string: book.thumbnail) {
                cell.imageView.kf_setImage(url: url) {_ in
                    let imageWidth = cell.imageView.image?.size.width ?? 0
                    let imageHeight = cell.imageView.image?.size.height ?? 0
                    if imageHeight > imageWidth {
                        cell.imageView.backgroundColor = .clear
                    }
                }
            }
        }
        cell.titleLabel.text = book.title
        cell.subtitleLabel.text = book.composer
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = self.listSkillBook[indexPath.row]
        let viewController = BookDetailViewController(book: book)
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        tabBarController?.present(viewController, animated: true)
    }
}

extension SkillsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.isPad {
            return CGSize(width: screenWidth / 3 - inset*2, height: (screenWidth / 2) + inset)
        }
        return CGSize(width: screenWidth / 2 - inset, height: (screenWidth / 2)*5/4 + inset*5)
    }
}
