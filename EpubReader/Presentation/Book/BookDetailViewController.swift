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
    private lazy var largeContainerView: UIView = {
        let largeContainerView = UIView()
        largeContainerView.backgroundColor = .clear
        return largeContainerView
    }()
    
    private lazy var booksDetailsView: UIView = {
        let booksDetailsView = UIView()
        booksDetailsView.backgroundColor = .clear
        return booksDetailsView
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
    
    private lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.style(with: .favorite)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        favoriteButton.tintColor = UIColor.color(with: .background)
        return favoriteButton
    }()
    
    private lazy var bookDetailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = .clear
        label.numberOfLines = 1
        label.sizeToFit()
        label.text = "Detail Books"
        return label
    }()
    
    private lazy var previewImage: UIImageView = {
        let previewImage = UIImageView()
        previewImage.clipsToBounds = true
        previewImage.contentMode = .scaleAspectFill
        previewImage.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        return previewImage
    }()
    
    private lazy var gradiantLayer: CAGradientLayer = {
        let gradiantLayer = CAGradientLayer(layer: previewImage.layer)
        gradiantLayer.frame = previewImage.bounds
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
    
    private lazy var bookDescription: UIView = {
        let bookDescription = UIView()
        bookDescription.backgroundColor = .clear
        return bookDescription
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
        label.textColor = UIColor.black
        label.backgroundColor = .clear
        label.numberOfLines = 1
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
    
    private lazy var downloadButtonView: UIView = {
        let downloadButtonView = UIView()
        downloadButtonView.backgroundColor = UIColor.color(with: .background)
        downloadButtonView.layer.cornerRadius = 24
        return downloadButtonView
    }()
    
    private lazy var downloadButton: UIButton = {
        let downloadButton = UIButton()
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        downloadButton.tintColor = UIColor.color(with: .background)
        downloadButton.setTitle("Tải Sách", for: .normal)
        downloadButton.titleLabel?.font = UIFont.font(with: .h4)
        if UIDevice.current.userInterfaceIdiom == .pad {
            downloadButton.titleLabel?.font = UIFont.font(with: .h2)
        }
        return downloadButton
    }()
    
    private lazy var downloadAudioView: UIView = {
        let downloadAudioView = UIView()
        downloadAudioView.backgroundColor = .clear
        return downloadAudioView
    }()
    
    private lazy var miniAudioPlayerView: MiniAudioPlayerView = {
        let miniAudioPlayerView = MiniAudioPlayerView()
        miniAudioPlayerView.delegate = self
        miniAudioPlayerView.isAccessoriesScreen = false
        return miniAudioPlayerView
    }()
    
    private lazy var audioFlowLayout: UICollectionViewFlowLayout = {
        let audioFlowLayout = UICollectionViewFlowLayout()
        audioFlowLayout.sectionInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        audioFlowLayout.scrollDirection = .vertical
        return audioFlowLayout
    }()

    private lazy var audioCollectionView: UICollectionView = {
        let audioCollectionView = UICollectionView(frame: .zero, collectionViewLayout: audioFlowLayout)
        audioCollectionView.register(AudioResourceCell.self, forCellWithReuseIdentifier: "AudioResourceCell")
        audioCollectionView.delegate = self
        audioCollectionView.dataSource = self
        audioCollectionView.isHidden = true
        audioCollectionView.clipsToBounds = false
        audioCollectionView.backgroundColor = .white
        return audioCollectionView
    }()
    
    private lazy var segmentedControl: ScrollUISegmentController = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 42)
        let segmentedControl = ScrollUISegmentController(frame: frame)
        segmentedControl.segmentDelegate = self
        return segmentedControl
    }()
    
    private lazy var overviewView: UITextView = {
        let overviewView = UITextView(frame: .zero)
        overviewView.isScrollEnabled = true
        overviewView.backgroundColor = .white
        overviewView.isHidden = false
        overviewView.textColor = UIColor.color(with: .darkColor)
        overviewView.font = UIFont.font(with: .h5)
        if UIDevice.current.userInterfaceIdiom == .pad {
            overviewView.font = UIFont.font(with: .h4)
        }
        return overviewView
    }()
    
    // MARK: - Local variables
    private let listTopic = ["Giới Thiệu", "File Audio"]
    private let playerView = UIView()
    private let playerViewController = PlayerViewController()
    
    private var listAudio: [Audio] = []
    private var pageViewController = UIPageViewController()
    private var book: Book
    private var audioViewModel = AudioViewModel()
    private var bookViewModel = BookViewModel()
    private var selectedSegmentIndex: Int = 0
    
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadData(_:)),
                                               name: NSNotification.Name(rawValue: EpubReaderHelper.ReloadDataNotification),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadFavoriteStatus(_:)),
                                               name: NSNotification.Name(rawValue: EpubReaderHelper.ReloadFavoriteSuccessfullyNotification),
                                               object: nil)
        
        setupViews()
        setupData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraint()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = UIColor.white
        
        closeButtonView.addSubview(closeButton)
        topButtonView.addSubview(closeButtonView)
        topButtonView.addSubview(bookDetailsLabel)
        topButtonView.addSubview(favoriteButton)
        
        previewImage.layer.addSublayer(gradiantLayer)
        
        bookDescription.addSubview(bookImage)
        bookDescription.addSubview(bookTitle)
        bookDescription.addSubview(bookComposer)
        
        downloadButtonView.addSubview(downloadButton)
        
        booksDetailsView.addSubview(previewImage)
        booksDetailsView.addSubview(topButtonView)
        booksDetailsView.addSubview(bookDescription)
        booksDetailsView.addSubview(downloadButtonView)
        
        playerView.addSubview(miniAudioPlayerView)
        playerView.isHidden = true
        
        largeContainerView.addSubview(booksDetailsView)
        largeContainerView.addSubview(segmentedControl)
        largeContainerView.addSubview(audioCollectionView)
        largeContainerView.addSubview(overviewView)
        largeContainerView.addSubview(playerView)
        
        view.addSubview(largeContainerView)
    }
    
    private func setUpSegmentControls() {
        segmentedControl.itemWidth = Utils.getLengthMaxOfTextArray(arrStr: self.listTopic,
                                                                   font: UIFont.font(with: .h3),
                                                                   height: segmentHeight) + 20
        segmentedControl.segmentItems = self.listTopic
        segmentedControl.segmentedControl.selectedSegmentIndex = selectedSegmentIndex
    }
    
    private func setupConstraint() {
        let safeAreaTop = self.view.safeAreaInsets.top
        let top = safeAreaTop
        let frameWidth = self.view.frame.size.width
        let frameHeight = self.view.frame.size.height
        var bookViewHeight = frameHeight/2 + 128
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            bookViewHeight = frameHeight / 1.5 + 40
        }
        
        largeContainerView.frame = self.view.frame
        resetContrainst()
        
        booksDetailsView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: frameWidth, height: bookViewHeight))
        }
        
        previewImage.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        
        topButtonView.snp.makeConstraints { (make) in
            make.top.equalTo(top)
            make.size.equalTo(CGSize(width: frameWidth, height: segmentHeight))
        }
        closeButtonView.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(24)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }

        closeButton.snp.makeConstraints{ (make) in
            make.size.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(4)
            make.top.equalToSuperview().inset(4)
        }
        
        bookDetailsLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 120, height: 32))
        }
        
        favoriteButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        let bookDescWidth = frameWidth / 2 + 64
        var bookDescHeight = bookViewHeight / 2 + 72
        if UIDevice.current.userInterfaceIdiom == .pad {
            bookDescHeight = bookViewHeight / 1.5 + 100
            bookDescription.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(padding)
                make.size.equalTo(CGSize(width: bookDescWidth, height: bookDescHeight))
            }
        } else {
            bookDescription.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.size.equalTo(CGSize(width: bookDescWidth, height: bookDescHeight))
            }
        }
        
        var bookImageWidth = bookDescWidth - 72
        var bookImageHeight = bookDescHeight - 70
        let downloadButtonViewWidth = frameWidth / 2 - 32
        var downloadButtonViewHeight: CGFloat = 48
        var downloadButtonY: CGFloat = 24
        var titleTop: CGFloat = 16
        var composerTop: CGFloat = 0
        if UIDevice.current.userInterfaceIdiom == .pad {
            bookImageWidth = bookDescWidth - 72 * 3
            bookImageHeight = bookDescHeight - 70 * 3
            titleTop = 32
            composerTop = 32
            downloadButtonViewHeight = 80
            downloadButtonY = 42
            bookTitle.font = UIFont.systemFont(ofSize: 32.0)
            bookComposer.font = UIFont.systemFont(ofSize: 28.0)
        }
        
        bookImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: bookImageWidth, height: bookImageHeight))
        }
        
        bookTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(bookImage.snp.bottom).offset(titleTop)
            make.size.equalTo(CGSize(width: bookDescWidth, height: 28))
        }
        
        bookComposer.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(bookTitle.snp.bottom).offset(composerTop)
            make.size.equalTo(CGSize(width: bookDescWidth, height: 28))
        }
        
        downloadButtonView.snp.makeConstraints { (make) in
            make.top.equalTo(bookDescription.snp.bottom).offset(padding)
            make.bottom.equalTo(booksDetailsView.snp.bottom).inset(downloadButtonY)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: downloadButtonViewWidth, height: downloadButtonViewHeight))
        }
        
        downloadButton.snp.makeConstraints{ (make) in
            make.size.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(4)
            make.top.equalToSuperview().inset(4)
        }
        
        segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(bookViewHeight)
            make.height.equalTo(segmentHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        let descHeight = frameHeight - bookViewHeight
        var inset: CGFloat = 24
        if !playerView.isHidden {
            inset = 24 + 60 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!
        }

        audioCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom).offset(padding + 6)
            make.bottom.equalToSuperview().inset(inset)
            make.height.equalTo(descHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        overviewView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(inset)
            make.height.equalTo(descHeight)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
        }
        overviewView.translatesAutoresizingMaskIntoConstraints = false
        
        let miniPlayerWidth = UIScreen.main.bounds.width
        miniAudioPlayerView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.size.equalTo(CGSize(width: miniPlayerWidth, height: 60))
        }
        
        handleShowMiniPlayer()
        if !playerView.isHidden {
            let top = UIScreen.main.bounds.height - 60 - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!
            let height = 60 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!
            playerView.snp.makeConstraints { (make) in
                make.leading.equalTo(0)
                make.top.equalTo(top)
                make.size.equalTo(CGSize(width: miniPlayerWidth, height: height))
            }
        }
    }
    
    private func resetContrainst() {
        audioCollectionView.snp.removeConstraints()
        overviewView.snp.removeConstraints()
    }
    
    // MARK: - Setup and Load data
    private func setupData() {
        if let thumbnailUrl = URL(string: self.book.thumbnail) {
            previewImage.kf_setImage(url: thumbnailUrl) {_ in
                self.previewImage.alpha = 0.1
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
        loadAudioData()
        loadDescription()
        setUpSegmentControls()
    }
    
    private func loadAudioData() {
        audioViewModel.getAudioList(bookId: book.id)
    }
    
    private func loadDescription() {
        overviewView.text = book.description
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
        let downArrowIcon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(downArrowIcon, for: .normal)
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
    
    private func openAudioPlayer(audio: Audio) {
        AudioPlayer.shared.sound = nil
        AudioPlayer.shared.play(audio: audio, thumbnail: book.thumbnail)
        AudioPlayer.shared.isPaused = false
    }
    
    private func showFullScreenAudio() {
        let viewController = FullScreenAudioPlayerViewController()
        if (UI_USER_INTERFACE_IDIOM() == .phone) {
            let value = NSNumber(value: UIInterfaceOrientation.portrait.rawValue)
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
        if let tabBar = self.tabBarController {
            DispatchQueue.main.async {
                tabBar.present(viewController, animated: true, completion: nil)
            }
        } else if let topController = UIApplication.topViewController() {
            DispatchQueue.main.async {
                topController.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    private func showAlertDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func segmentChanged(segmentControl: UISegmentedControl) {
        if segmentControl.selectedSegmentIndex == 0 {
            self.audioCollectionView.isHidden = true
            self.overviewView.isHidden = false
        } else if segmentControl.selectedSegmentIndex == 1 {
            self.audioCollectionView.isHidden = false
            self.overviewView.isHidden = true
        }
    }
    
    //MARK: - @objc Attributes
    @objc func reloadData(_ notification: NSNotification) {
        if EpubReaderHelper.shared.listAudio.count > 0 {
            self.listAudio.removeAll()
            self.listAudio = EpubReaderHelper.shared.listAudio
            self.audioCollectionView.reloadData()
        }
    }
    
    @objc func reloadFavoriteStatus(_ notification: NSNotification) {
        setStatusButton()
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
        let id = EpubReaderHelper.shared.user.id
        if Utilities.shared.isFavorited(bookId: book.id) {
            bookViewModel.removeFavorite(bookId: book.id, userId: id)
        } else {
            bookViewModel.putToFavorites(book: book, userId: id)
        }
    }
    
    @objc func downloadButtonTapped() {
        if let url = URL(string: book.epub_source) {
            let fileName = url.lastPathComponent
            let path: String = Utilities.shared.getFileExist(fileName: fileName)
            if path != "" {
                self.open(path: path)
            } else {
                ApiWebService.shared.downloadFile(url: url) { success in
                    print("download")
                    DispatchQueue.main.async {
                        self.setStatusButton()
                    }
                }
            }
        } else {
            showAlertDialog(title: "", message: "Sorry, this book is comming soon")
        }
    }
    
    func handleShowMiniPlayer() {
        if AudioPlayer.shared.sound != nil {
            playerView.isHidden = false
            miniAudioPlayerView.urlThumnail = AudioPlayer.shared.imgThumbnail
            miniAudioPlayerView.statusPlay = AudioPlayer.shared.isPaused
            miniAudioPlayerView.setNeedsLayout()
        } else {
            playerView.isHidden = true
        }
    }
}

//MARK: - Extension with MiniAudioPlayerViewDelegate -
extension BookDetailViewController: MiniAudioPlayerViewDelegate {
    func removeController() {
        AudioPlayer.shared.sound = nil
        handleShowMiniPlayer()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func showFullScreenAudioPlayerFromMiniPlayer() {
        let viewController = FullScreenAudioPlayerViewController()
        DispatchQueue.main.async {
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

//MARK: - Extension with UICollectionView
extension BookDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listAudio.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AudioResourceCell", for: indexPath) as! AudioResourceCell
        let audio = self.listAudio[indexPath.row]
        cell.configure(audio: audio)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let audio = self.listAudio[indexPath.row]
        if audio.fileAudio != "" {
            self.openAudioPlayer(audio: audio)
            self.showFullScreenAudio()
            self.handleShowMiniPlayer()
        } else {
            showAlertDialog(title: "", message: "Sorry, this audio is comming soon")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return AudioResourceCell.sizeForResource(audio: self.listAudio[indexPath.row],
                                            cellWidth: collectionView.bounds.width,
                                            cell: audioCollectionView.cellForItem(at: indexPath) as? AudioResourceCell)
    }
}

// MARK: - ScrollUISegmentControllerDelegate
extension BookDetailViewController: ScrollUISegmentControllerDelegate{
    func selectItemAt(_ sender: SegmentedControl) {
        self.segmentChanged(segmentControl: sender)
    }
}
