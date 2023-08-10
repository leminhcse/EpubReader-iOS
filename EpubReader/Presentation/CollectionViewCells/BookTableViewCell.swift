//
//  BookTableViewCell.swift
//  EpubReader
//
//  Created by mac on 26/09/2022.
//

import UIKit
import SnapKit

class BookTableViewCell: UITableViewCell {
    
    private var book: Book!
    private var audio: Audio!
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = CGFloat(6)
        image.backgroundColor = .clear
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        if UIDevice.current.userInterfaceIdiom == .pad {
            titleLabel.font = UIFont.font(with: .h2)
        } else {
            titleLabel.font = UIFont.font(with: .h4)
        }
        titleLabel.textColor = .darkText
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    private lazy var composerLabel: UILabel = {
        let composerLabel = UILabel()
        if UIDevice.current.userInterfaceIdiom == .pad {
            composerLabel.font = UIFont.font(with: .h3)
        } else {
            composerLabel.font = UIFont.font(with: .h5)
        }
        composerLabel.textColor = .darkGray
        composerLabel.adjustsFontSizeToFitWidth = true
        composerLabel.minimumScaleFactor = 0.5
        composerLabel.numberOfLines = 1
        return composerLabel
    }()
    
    private lazy var pageLabel: UILabel = {
        let pageLabel = UILabel()
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageLabel.font = UIFont.font(with: .h3)
        } else {
            pageLabel.font = UIFont.font(with: .h5)
        }
        pageLabel.textColor = .darkGray
        pageLabel.textAlignment = .center
        pageLabel.backgroundColor = .systemGray.withAlphaComponent(0.25)
        pageLabel.adjustsFontSizeToFitWidth = true
        pageLabel.minimumScaleFactor = 0.5
        pageLabel.numberOfLines = 1
        pageLabel.isHidden = true
        return pageLabel
    }()
    
    private lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.style(with: .favorite)
        favoriteButton.tintColor = UIColor.color(with: .background)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return favoriteButton
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.style(with: .delete)
        deleteButton.tintColor = UIColor.color(with: .background)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.isHidden = true
        return deleteButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(image)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(composerLabel)
        self.contentView.addSubview(pageLabel)
        self.contentView.addSubview(favoriteButton)
        self.contentView.addSubview(deleteButton)
    }
    
    private func setupConstraints() {
        let width = self.frame.size.width
        let height = self.frame.size.height
        let padding: CGFloat = 12
        
        var imageWidth = width/5 + padding*2
        var imageHeight = height*2 + padding*4
        var titleWidth = width - imageWidth
        var titleHeight = height/3
        var titleY = CGFloat(24)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            imageWidth = width/5 + padding*8
            imageHeight = height*2 + padding*12
            titleWidth = titleWidth*2
            titleHeight = titleHeight*1.5
            titleY = CGFloat(58)
        }
        
        image.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(padding)
            make.size.equalTo(CGSize(width: imageWidth, height: imageHeight))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(image.snp.trailing).offset(padding)
            make.size.equalTo(CGSize(width: titleWidth - padding, height: titleHeight*3))
            make.top.equalToSuperview().offset(titleY)
        }
        
        composerLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(image.snp.trailing).offset(padding)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.size.equalTo(CGSize(width: titleWidth, height: titleHeight))
        }
        
        pageLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(image.snp.trailing).offset(padding)
            make.top.equalTo(composerLabel.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: titleWidth/2, height: titleHeight + 8))
        }
        
        favoriteButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(padding*2)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(padding*2)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
    }
    
    public func configure(book: Book, pageNumber: Int? = nil, isCanDelete: Bool? = nil) {
        self.book = book
        DispatchQueue.main.async {
            if let url = URL(string: book.thumbnail) {
                self.image.kf_setImage(url: url) { _ in
                    let imageWidth = self.image.image?.size.width ?? 0
                    let imageHeight = self.image.image?.size.height ?? 0
                    if imageHeight > imageWidth {
                        self.image.backgroundColor = .clear
                    }
                }
            }
        }
        titleLabel.text = book.title
        composerLabel.text = book.composer
        
        if pageNumber != nil {
            pageLabel.isHidden = false
            pageLabel.text = "Đã đọc \(pageNumber ?? 1) trang"
        }
        
        if isCanDelete != nil && isCanDelete == true {
            favoriteButton.isHidden = true
            deleteButton.isHidden = false
        } else {
            favoriteButton.isHidden = false
            deleteButton.isHidden = true
            
            var imageName = "fi_heart.png"
            if Utilities.shared.isFavorited(bookId: book.id) {
                imageName = "fi_heart_fill.png"
            }
            let uiImage = UIImage.init(named: imageName)?.withRenderingMode(.alwaysTemplate)
            favoriteButton.setImage(uiImage, for: .normal)
        }
    }
    
    public func configureAudio(audio: Audio) {
        self.audio = audio
        var thumbnail = ""
        var composer = ""
        for book in EpubReaderHelper.shared.books {
            if audio.book_id == book.id {
                thumbnail = book.thumbnail
                composer = book.composer
            }
        }
        DispatchQueue.main.async {
            if let url = URL(string: thumbnail) {
                self.image.kf_setImage(url: url) { _ in
                    let imageWidth = self.image.image?.size.width ?? 0
                    let imageHeight = self.image.image?.size.height ?? 0
                    if imageHeight > imageWidth {
                        self.image.backgroundColor = .clear
                    }
                }
            }
        }
        titleLabel.text = audio.title
        composerLabel.text = composer
    }
    
    @objc func favoriteButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if #available(iOS 13.0, *) {
            alert.view.tintColor = UIColor.primaryTextColor(traitCollection: UITraitCollection.current)
        } else {
            alert.view.tintColor = UIColor.color(with: .primaryItem)
        }
        alert.popoverPresentationController?.permittedArrowDirections = []

        if self.book != nil {
            let bookViewModel = BookViewModel()
            if Utilities.shared.isFavorited(bookId: self.book.id) {
                bookViewModel.removeFavorite(bookId: self.book.id, userId: EpubReaderHelper.shared.user.id) { success in
                    BannerNotification.removedFromFavourites.present()
                }
            } else {
                bookViewModel.putToFavorites(book: self.book, userId: EpubReaderHelper.shared.user.id) { success in
                    BannerNotification.addedToFavourites.present()
                }
            }
        }
    }
    
    @objc func deleteButtonTapped() {
        let alert = UIAlertController(title: "Xóa sách \(self.book.title)",
                                      message: "Bạn có chắc muốn xóa cuốn sách này không ?",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Đồng ý", style: .default) { action in
            if let bookUrl = URL(string: self.book.epub_source) {
                let fileName = bookUrl.lastPathComponent
                let path: String = Utilities.shared.getFileExist(fileName: fileName)
                if path != "" {
                    try? FileManager.default.removeItem(atPath: path)
                    DispatchQueue.main.async {
                        BannerNotification.downloadDeleted(title: self.book.title).present()
                        EpubReaderHelper.shared.downloadBooks.removeAll(where: { $0.id == self.book.id})
                        PersistenceHelper.saveData(object: EpubReaderHelper.shared.downloadBooks, key: "downloadBook")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.RemoveBookSuccessNotification), object: nil)
                    }
                }
            }
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .cancel)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
}
