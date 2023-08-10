//
//  BookDetailViewController.swift
//  EpubReader
//
//  Created by mac on 29/06/2022.
//

import UIKit
import FolioReaderKit
import Kingfisher

class BookDetailViewController: UIViewController {
    
    // MARK: - Private Controls
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var contentView: UIStackView = {
        let contentView = UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.alignment = .fill
        contentView.axis = .vertical
        contentView.distribution = .equalSpacing
        return contentView
    }()
    
    private lazy var firstContentView: UIView = {
        let firstContentView = UIView()
        firstContentView.backgroundColor = .clear
        return firstContentView
    }()
    
    private lazy var secondContentView: UIView = {
        let secondContentView = UIView()
        secondContentView.backgroundColor = .white
        secondContentView.layer.cornerRadius = 30
        return secondContentView
    }()
    
    private lazy var previewBookImage: UIImageView = {
        let previewBookImage = UIImageView()
        previewBookImage.clipsToBounds = true
        previewBookImage.contentMode = .scaleAspectFill
        return previewBookImage
    }()
    
    private lazy var topButtonView: UIView = {
        let topButtonView = UIView()
        topButtonView.backgroundColor = .clear
        return topButtonView
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.style(with: .downArrow)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.tintColor = UIColor.color(with: .background)
        return closeButton
    }()
    
    private lazy var closeButtonView: UIView = {
        let closeButtonView = UIView()
        closeButtonView.backgroundColor = UIColor.init(hex: "#ECECEC")
        closeButtonView.layer.cornerRadius = 16
        return closeButtonView
    }()
    
    private lazy var gradiantLayer: CAGradientLayer = {
        let gradiantLayer = CAGradientLayer(layer: previewBookImage.layer)
        gradiantLayer.frame = previewBookImage.bounds
        let gradientColour = UIColor.black
        gradiantLayer.colors = [gradientColour.withAlphaComponent(0.8).cgColor,
                                gradientColour.withAlphaComponent(0.4).cgColor,
                                gradientColour.withAlphaComponent(0.1).cgColor,
                                gradientColour.withAlphaComponent(0).cgColor,
                                gradientColour.withAlphaComponent(0).cgColor]
        gradiantLayer.locations = [0.0,0.1,0.2,0.3,1.0]
        gradiantLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradiantLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return gradiantLayer
    }()
    
    private lazy var bookDescView: UIView = {
        let bookDescView = UIView()
        bookDescView.backgroundColor = .clear
        return bookDescView
    }()
    
    private lazy var bookImage : UIImageView = {
        let bookImage = UIImageView()
        bookImage.clipsToBounds = true
        bookImage.contentMode = .scaleAspectFill
        bookImage.backgroundColor = .clear
        return bookImage
    }()
    
    private lazy var bookTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 3
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont.font(with: .h3)
        return label
    }()
    
    private lazy var bookComposer: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.backgroundColor = .clear
        label.numberOfLines = 1
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont.font(with: .h4)
        return label
    }()
    
    fileprivate lazy var menuBookView: MenuBookView = {
        [unowned self] in
        let menuViewX = CGFloat(16)
        let width = self.view.bounds.size.width-2*16
        let menuView: MenuBookView = MenuBookView(frame: CGRect(x: menuViewX, y: 0, width: width, height: 72))
        menuView.backgroundColor = UIColor.init(hex: "#f8f8fc").withAlphaComponent(0.2)
        menuView.layer.borderWidth = 0.2
        menuView.layer.cornerRadius = 12.0

        menuView.setPages(hasIn: true, text: "231")
        menuView.setRating(rating: "4.4")
        menuView.setReview(reviews: "168")
        return menuView
    }()
    
    private lazy var summaryText: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = UIFont.font(with: .h5)
        return label
    }()
    
    private lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        return bottomView
    }()
    
    private lazy var downloadButton: UIButton = {
        let downloadButton = UIButton()
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        downloadButton.tintColor = UIColor.color(with: .background)
        downloadButton.backgroundColor = UIColor.color(with: .background)
        downloadButton.setTitle("Tải Sách", for: .normal)
        downloadButton.titleLabel?.font = UIFont.font(with: .h4)
        downloadButton.layer.cornerRadius = 24
        if UIDevice.current.userInterfaceIdiom == .pad {
            downloadButton.titleLabel?.font = UIFont.font(with: .h2)
        }
        return downloadButton
    }()
    
    private lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.tintColor = UIColor.color(with: .background)
        favoriteButton.style(with: .favorite)
        favoriteButton.titleLabel?.font = UIFont.font(with: .h4)
        favoriteButton.layer.borderColor = UIColor.gray.cgColor
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        if UIDevice.current.userInterfaceIdiom == .pad {
            favoriteButton.titleLabel?.font = UIFont.font(with: .h2)
        }
        return favoriteButton
    }()
    
    private lazy var favoriteButtonView: UIView = {
        let favoriteButtonView = UIView()
        favoriteButtonView.backgroundColor = UIColor.init(hex: "#ECECEC")
        favoriteButtonView.layer.cornerRadius = 24
        return favoriteButtonView
    }()
    
//    private lazy var downloadAudioView: UIView = {
//        let downloadAudioView = UIView()
//        downloadAudioView.backgroundColor = .clear
//        return downloadAudioView
//    }()
//
//    private lazy var miniAudioPlayerView: MiniAudioPlayerView = {
//        let miniAudioPlayerView = MiniAudioPlayerView()
//        miniAudioPlayerView.delegate = self
//        miniAudioPlayerView.isAccessoriesScreen = false
//        return miniAudioPlayerView
//    }()
//
//    private lazy var audioFlowLayout: UICollectionViewFlowLayout = {
//        let audioFlowLayout = UICollectionViewFlowLayout()
//        audioFlowLayout.sectionInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
//        audioFlowLayout.scrollDirection = .vertical
//        return audioFlowLayout
//    }()
//
//    private lazy var audioCollectionView: UICollectionView = {
//        let audioCollectionView = UICollectionView(frame: .zero, collectionViewLayout: audioFlowLayout)
//        audioCollectionView.register(AudioResourceCell.self, forCellWithReuseIdentifier: "AudioResourceCell")
//        audioCollectionView.delegate = self
//        audioCollectionView.dataSource = self
//        audioCollectionView.isHidden = true
//        audioCollectionView.clipsToBounds = false
//        audioCollectionView.backgroundColor = .white
//        return audioCollectionView
//    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor.darkText
        textLabel.backgroundColor = .clear
        textLabel.numberOfLines = 1
        textLabel.textAlignment = .center
        textLabel.sizeToFit()
        textLabel.font = UIFont.font(with: .h4)
        textLabel.text = "Sách này hiện không hỗ trợ audio"
        textLabel.isHidden = false
        return textLabel
    }()
    
    // MARK: - Local variables
    private let listTopic = ["Lời Tựa", "File Audio"]
    private let playerView = UIView()
    private let playerViewController = PlayerViewController()
    
    private var listAudio: [Audio] = []
    private var pageViewController = UIPageViewController()
    private var book: Book
    private var audioViewModel = AudioViewModel()
    private var bookViewModel = BookViewModel()
    private var selectedSegmentIndex: Int = 0
    private var currentPage: Int = 0
    
    private let segmentHeight = CGFloat(42)
    private let padding = CGFloat(12)

    // MARK: - Constructor
    required init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(reloadData(_:)),
//                                               name: NSNotification.Name(rawValue: EpubReaderHelper.ReloadDataNotification),
//                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadFavoriteStatus(_:)),
                                               name: NSNotification.Name(rawValue: EpubReaderHelper.ReloadFavoriteSuccessfullyNotification),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getCurrentPageNumber(_:)),
                                               name: NSNotification.Name(rawValue: "pageNumberNotification"), object: nil)
        
        setupViews()
        setupData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraint()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        self.view.backgroundColor = UIColor.white
        
        scrollView.addSubview(contentView)
        contentView.addSubview(previewBookImage)
        contentView.addSubview(firstContentView)
        contentView.addSubview(secondContentView)
        
        closeButtonView.addSubview(closeButton)
        topButtonView.addSubview(closeButtonView)
        firstContentView.addSubview(topButtonView)
        firstContentView.addSubview(bookImage)
        firstContentView.addSubview(bookTitle)
        firstContentView.addSubview(bookComposer)
        
        secondContentView.addSubview(menuBookView)
        secondContentView.addSubview(summaryText)

        favoriteButtonView.addSubview(favoriteButton)
        bottomView.addSubview(downloadButton)
        bottomView.addSubview(favoriteButtonView)
        
        self.view.addSubview(scrollView)
        self.view.addSubview(bottomView)
    }
    
    private func setupConstraint() {
        let safeAreaTop = self.view.safeAreaInsets.top
        let top = safeAreaTop > 48 ? safeAreaTop : 48
        let frameWidth = self.view.frame.size.width
        let frameHeight = self.view.frame.size.height
        let bookViewHeight = frameHeight/2 + 72
        let marginTop: CGFloat = 16
        let padding: CGFloat = 24
        
        if book.description == "" {
            scrollView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.top.equalToSuperview().offset(top)
            }
        } else {
            scrollView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.top.equalToSuperview().offset(-top)
            }
        }
        
        contentView.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        let firstContentHeight = frameHeight/2 + 64
        firstContentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: frameWidth, height: firstContentHeight))
        }
        
        // Close button
        topButtonView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(top)
            make.size.equalTo(CGSize(width: frameWidth, height: segmentHeight))
        }

        closeButtonView.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(padding)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }

        closeButton.snp.makeConstraints{ (make) in
            make.size.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(4)
            make.top.equalToSuperview().inset(4)
        }
        
        previewBookImage.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        
        bookImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(topButtonView.snp.bottom)
            make.size.equalTo(CGSize(width: frameWidth/3 + padding*2, height: bookViewHeight/2 + 32))
        }
        
        // Book Description
        let bookHeight: CGFloat = Utils.estimatedHeightOfLabel(text: bookTitle.text!, font: bookTitle.font, width: frameWidth - 64)
        bookTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(bookImage.snp.bottom).offset(marginTop)
            make.size.equalTo(CGSize(width: frameWidth - 64, height: bookHeight))
        }

        let bookCompose: CGFloat = Utils.estimatedHeightOfLabel(text: bookComposer.text!, font: bookComposer.font, width: frameWidth - 64)
        bookComposer.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(bookTitle.snp.bottom).offset(marginTop/2)
            make.size.equalTo(CGSize(width: frameWidth/2, height: bookCompose))
        }
        
        secondContentView.snp.makeConstraints { (make) in
            make.top.equalTo(firstContentView.snp.bottom)
            make.size.equalToSuperview()
        }
        
        // Bottom view
        bottomView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: frameWidth, height: padding*4))
            make.bottom.equalToSuperview()
        }

        downloadButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(padding/2)
            make.size.equalTo(CGSize(width: frameWidth - padding*5, height: padding*2))
            make.leading.equalTo(padding)
        }

        favoriteButtonView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(padding/2)
            make.leading.equalTo(downloadButton.snp.trailing).offset(padding - 8)
            make.size.equalTo(CGSize(width: padding*2, height: padding*2))
        }

        favoriteButton.snp.makeConstraints{ (make) in
            make.size.equalToSuperview().inset(2)
            make.leading.equalToSuperview().inset(2)
            make.top.equalToSuperview().inset(2)
        }
        
        menuBookView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(padding)
            make.size.equalTo(CGSize(width: frameWidth - padding*2, height: padding*3))
        }
        
        summaryText.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(padding)
            make.top.equalTo(menuBookView.snp.bottom).offset(marginTop)
        }
        
        let summaryHeight: CGFloat = Utils.estimatedHeightOfLabel(text: book.description, font: summaryText.font, width: frameWidth - padding)
        let height = summaryHeight + frameHeight - top*2 - marginTop
        scrollView.contentSize = CGSize(width: frameWidth, height: height)
    }
    
//    private func resetContrainst() {
//        audioCollectionView.snp.removeConstraints()
//    }
    
    // MARK: - Setup and Load data
    private func setupData() {
        if let thumbnailUrl = URL(string: self.book.thumbnail) {
            previewBookImage.kf_setImage(url: thumbnailUrl) {_ in
                self.previewBookImage.alpha = 0.2
            }
        }
        
        if let imagelUrl = URL(string: self.book.thumbnail) {
            bookImage.kf_setImage(url: imagelUrl) {_ in
                self.bookImage.contentMode = .scaleAspectFill
                self.bookImage.layer.cornerRadius = 8
            }
        }
        
        bookTitle.text = self.book.title
        bookComposer.text = self.book.composer
        
        setStatusButton()
//      loadAudioData()
        audioViewModel.getAudioList(bookId: book.id)
        summaryText.text = book.description
    }
    
    private func setStatusButton() {
        if let bookUrl = URL(string: book.epub_source) {
            let fileName = bookUrl.lastPathComponent
            let path: String = Utilities.shared.getFileExist(fileName: fileName)
            if path != "" {
                downloadButton.setTitle("Đọc Sách", for: .normal)
            } else {
                downloadButton.setTitle("Tải Sách", for: .normal)
            }
        }
        
        var imageName = "fi_heart.png"
        if Utilities.shared.isFavorited(bookId: book.id) {
            imageName = "fi_heart_fill.png"
        }
        let uiImage = UIImage.init(named: imageName)?.withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(uiImage, for: .normal)
    }
    
    private func readerConfiguration(forEpub epub: Epub) -> FolioReaderConfig {
        let config = FolioReaderConfig(withIdentifier: epub.readerIdentifier)
        config.shouldHideNavigationOnTap = epub.shouldHideNavigationOnTap
        config.scrollDirection = epub.scrollDirection

        // Custom sharing quote background
        config.quoteCustomBackgrounds = []
        if let image = UIImage(named: "demo-bg") {
            let customImageQuote = QuoteImage(withImage: image, alpha: 0.6, backgroundColor: UIColor.black)
            config.quoteCustomBackgrounds.append(customImageQuote)
        }

        let textColor = UIColor(red:0.86, green:0.73, blue:0.70, alpha:1.0)
        let customColor = UIColor(red:0.30, green:0.26, blue:0.20, alpha:1.0)
        let customQuote = QuoteImage(withColor: customColor, alpha: 1.0, textColor: textColor)
        config.quoteCustomBackgrounds.append(customQuote)

        return config
    }
    
    private func open(path: String) {
        let config = FolioReaderConfig()
        let folioReader = FolioReader()
        folioReader.presentReader(parentViewController: self, withEpubPath: path, andConfig: config)
    }
    
    //MARK: - @objc Attributes
//    @objc func reloadData(_ notification: NSNotification) {
//        if EpubReaderHelper.shared.listAudio.count > 0 {
//            self.listAudio.removeAll()
//            self.listAudio = EpubReaderHelper.shared.listAudio
//            self.audioCollectionView.reloadData()
//            self.textLabel.isHidden = true
//        } else {
//            self.textLabel.isHidden = false
//        }
//    }
    
    @objc func reloadFavoriteStatus(_ notification: NSNotification) {
        setStatusButton()
    }
    
    @objc func getCurrentPageNumber(_ notification: NSNotification) {
        if let pageNumber = notification.userInfo?["pageNumber"] as? Int {
            currentPage = pageNumber
        }
        bookViewModel.putToReading(book: book, currentPage: currentPage)
    }
    
    @objc func closeButtonTapped() {
        if AudioPlayer.shared.sound != nil && !playerView.isHidden {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: MainTabBarViewController.HideShowAudioPlayer), object: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func favoriteButtonTapped() {
        if EpubReaderHelper.shared.user == nil {
            Utilities.shared.showLoginDialog()
            return
        }
        
        let id = EpubReaderHelper.shared.user.id
        if Utilities.shared.isFavorited(bookId: book.id) {
            bookViewModel.removeFavorite(bookId: book.id, userId: id) { success in
                if success {
                    BannerNotification.removedFromFavourites.present()
                }
            }
        } else {
            bookViewModel.putToFavorites(book: book, userId: id) { success in
                if success {
                    BannerNotification.addedToFavourites.present()
                }
            }
        }
    }
    
    @objc func downloadButtonTapped() {
        if let url = URL(string: book.epub_source) {
            let fileName = url.lastPathComponent
            let path: String = Utilities.shared.getFileExist(fileName: fileName)
            if path != "" {
                self.open(path: path)
            } else {
                if !Reachability.shared.isConnectedToNetwork {
                    Utilities.shared.noConnectionAlert()
                    return
                }
                if !book.epub_source.contains("http") {
                    Utilities.shared.showAlertDialog(title: "", message: "Không thể tải, đã xảy ra lỗi!")
                } else {
                    downloadButton.setTitle("Đang tải ... ", for: .normal)
                    ApiWebService.shared.downloadFile(url: url) { success in
                        print("download")
                        if success {
                            DispatchQueue.main.async {
                                BannerNotification.downloadSuccessful(title: self.book.title).present()
                                EpubReaderHelper.shared.downloadBooks.append(self.book)
                                PersistenceHelper.saveData(object: EpubReaderHelper.shared.downloadBooks, key: "downloadBook")
                                self.setStatusButton()
                            }
                        } else {
                            DispatchQueue.main.async {
                                Utilities.shared.showAlertDialog(title: "", message: "Download không thành công, vui lòng kiểm tra kết nối internet!")
                                self.setStatusButton()
                            }
                        }
                    }
                }
            }
        } else {
            Utilities.shared.showAlertDialog(title: "", message: "Sorry, this book is comming soon")
        }
    }
    
//    func handleShowMiniPlayer() {
//        if AudioPlayer.shared.sound != nil {
//            playerView.isHidden = false
//            miniAudioPlayerView.urlThumnail = AudioPlayer.shared.imgThumbnail
//            miniAudioPlayerView.statusPlay = AudioPlayer.shared.isPaused
//            miniAudioPlayerView.setNeedsLayout()
//        } else {
//            playerView.isHidden = true
//        }
//    }
}

//MARK: - Extension with MiniAudioPlayerViewDelegate -
//extension BookDetailViewController: MiniAudioPlayerViewDelegate {
//    func removeController() {
//        AudioPlayer.shared.sound = nil
//        handleShowMiniPlayer()
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
//    }
//
//    func showFullScreenAudioPlayerFromMiniPlayer() {
//        let viewController = FullScreenAudioPlayerViewController()
//        DispatchQueue.main.async {
//            self.present(viewController, animated: true, completion: nil)
//        }
//    }
//}

//MARK: - Extension with UICollectionView
//extension BookDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.listAudio.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AudioResourceCell", for: indexPath) as! AudioResourceCell
//        let audio = self.listAudio[indexPath.row]
//        cell.configure(audio: audio)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let audio = self.listAudio[indexPath.row]
//        if audio.fileAudio != "" {
//            Utilities.shared.openAudioPlayer(audio: audio, thumbnail: book.thumbnail)
//            Utilities.shared.showFullScreenAudio()
//            self.handleShowMiniPlayer()
//        } else {
//            Utilities.shared.showAlertDialog(title: "", message: "Sorry, this audio is comming soon")
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return AudioResourceCell.sizeForResource(audio: self.listAudio[indexPath.row],
//                                            cellWidth: collectionView.bounds.width,
//                                            cell: audioCollectionView.cellForItem(at: indexPath) as? AudioResourceCell)
//    }
//}
