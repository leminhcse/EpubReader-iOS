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
        titleLabel.numberOfLines = 1
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
    
    private lazy var moreButton: UIButton = {
        let moreButton = UIButton()
        moreButton.style(with: .more)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        moreButton.tintColor = UIColor.darkText
        moreButton.isHidden = false
        return moreButton
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
        self.contentView.addSubview(moreButton)
    }
    
    private func setupConstraints() {
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        var imageWidth = width/5 + 24
        var imageHeight = height*2 + 48
        var titleWidth = width - imageWidth
        var titleHeight = height/3
        var titleY = CGFloat(36)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            imageWidth = width/5 + 96
            imageHeight = height*2 + 144
            titleWidth = titleWidth*2
            titleHeight = titleHeight*1.5
            titleY = CGFloat(58)
        }
        
        image.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: imageWidth, height: imageHeight))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.size.equalTo(CGSize(width: titleWidth, height: titleHeight*2))
            make.top.equalToSuperview().offset(titleY)
        }
        
        composerLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.size.equalTo(CGSize(width: titleWidth, height: titleHeight))
        }
        
        pageLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.top.equalTo(composerLabel.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: titleWidth/2, height: titleHeight + 8))
        }
        
        moreButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 32, height: titleHeight + 12))
        }
    }
    
    public func configure(book: Book, pageNumber: Int? = nil) {
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
            pageLabel.text = "???? ?????c \(pageNumber ?? 1) trang"
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
    
    @objc func moreButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if #available(iOS 13.0, *) {
            alert.view.tintColor = UIColor.primaryTextColor(traitCollection: UITraitCollection.current)
        } else {
            alert.view.tintColor = UIColor.color(with: .primaryItem)
        }
        alert.popoverPresentationController?.permittedArrowDirections = []

        if self.book != nil {
            if Utilities.shared.isFavorited(bookId: self.book.id) {
                let favouritesAction = UIAlertAction(title: "X??a kh???i Y??u th??ch", style: .default) { action in
                    if EpubReaderHelper.shared.user == nil {
                        Utilities.shared.showLoginDialog()
                        return
                    }
                    let bookViewModel = BookViewModel()
                    bookViewModel.removeFavorite(bookId: self.book.id, userId: EpubReaderHelper.shared.user.id) { success in
                        BannerNotification.removedFromFavourites.present()
                    }
                }
                alert.addAction(favouritesAction)
            } else {
                let favouritesAction = UIAlertAction(title: "Th??m v??o Y??u th??ch", style: .default) { action in
                    if EpubReaderHelper.shared.user == nil {
                        Utilities.shared.showLoginDialog()
                        return
                    }
                    let bookViewModel = BookViewModel()
                    bookViewModel.putToFavorites(book: self.book, userId: EpubReaderHelper.shared.user.id) { success in
                        BannerNotification.addedToFavourites.present()
                    }
                }
                alert.addAction(favouritesAction)
            }
        
            if let bookUrl = URL(string: self.book.epub_source), pageLabel.isHidden {
                let fileName = bookUrl.lastPathComponent
                let path: String = Utilities.shared.getFileExist(fileName: fileName)
                if path != "" {
                    let downloadAction = UIAlertAction(title: "X??a s??ch", style: .default) { action in
                        try? FileManager.default.removeItem(atPath: path)
                        DispatchQueue.main.async {
                            BannerNotification.downloadDeleted(title: self.book.title).present()
                            EpubReaderHelper.shared.downloadBooks.removeAll(where: { $0.id == self.book.id})
                            PersistenceHelper.saveData(object: EpubReaderHelper.shared.downloadBooks, key: "downloadBook")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.RemoveBookSuccessNotification), object: nil)
                        }
                    }
                    alert.addAction(downloadAction)
                } else {
                    let downloadAction = UIAlertAction(title: "T???i s??ch", style: .default) { action in
                        if !Reachability.shared.isConnectedToNetwork {
                            Utilities.shared.noConnectionAlert()
                            return
                        }
                        if !self.book.epub_source.contains("http") {
                            Utilities.shared.showAlertDialog(title: "", message: "Kh??ng th??? t???i, ???? x???y ra l???i!")
                        } else {
                            ApiWebService.shared.downloadFile(url: bookUrl) { success in
                                print("download")
                                if success {
                                    DispatchQueue.main.async {
                                        BannerNotification.downloadSuccessful(title: self.book.title).present()
                                        EpubReaderHelper.shared.downloadBooks.append(self.book)
                                        PersistenceHelper.saveData(object: EpubReaderHelper.shared.downloadBooks, key: "downloadBook")
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        Utilities.shared.showAlertDialog(title: "", message: "Download kh??ng th??nh c??ng, vui l??ng ki???m tra k???t n???i internet!")
                                    }
                                }
                            }
                        }
                    }
                    alert.addAction(downloadAction)
                }
            }
        } else if self.audio != nil {
            let deleteAction = UIAlertAction(title: "X??a audio", style: .default) { action in
                if let id = self.audio?.id, let itemPath = DatabaseHelper.getFilePath(id: id), FileManager.default.fileExists(atPath: itemPath) {
                    try? FileManager.default.removeItem(atPath: itemPath)
                    EpubReaderHelper.shared.downloadAudio.removeAll(where: {$0.id == self.audio?.id})
                    PersistenceHelper.saveAudioData(object: EpubReaderHelper.shared.downloadAudio, key: "downloadAudio")
                    BannerNotification.downloadDeleted(title: self.audio.title).present()
                    NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.RemoveAudioSuccessNotification), object: nil)
                }
            }
            alert.addAction(deleteAction)
        } else {
            return
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
}
