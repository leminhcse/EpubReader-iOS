//
//  AudioDownloadsViewController.swift
//  EpubReader
//
//  Created by mac on 11/12/2022.
//

import UIKit
import SnapKit

class AudioDownloadsViewController: BaseViewController {

    // MARK: - UI Controls
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 41))
        label.center = CGPoint(x: 160, y: 285)
        label.textColor = UIColor.color(with: .background)
        label.textAlignment = .center
        label.text = "Bạn chưa tải bất kì audio nào!"
        label.isHidden = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            label.font = UIFont.font(with: .h1)
        } else {
            label.font = UIFont.font(with: .h3)
        }
        return label
    }()
    
    private lazy var bookTableView: UITableView = {
        let tabBarHeight: CGFloat = self.tabBarController?.tabBar.frame.size.height ?? 64
        let bottom = tabBarHeight + inset*9
        let bookTableView = UITableView()
        bookTableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookTableViewCell")
        bookTableView.delegate = self
        bookTableView.dataSource = self
        bookTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        bookTableView.separatorInset = .zero
        bookTableView.backgroundColor = .clear
        bookTableView.contentInset = .init(top: 0, left: 0, bottom: bottom, right: 0)
        bookTableView.isHidden = true
        return bookTableView
    }()
    
    private lazy var miniAudioPlayerView: MiniAudioPlayerView = {
        let miniAudioPlayerView = MiniAudioPlayerView()
        miniAudioPlayerView.delegate = self
        miniAudioPlayerView.isAccessoriesScreen = false
        return miniAudioPlayerView
    }()
    
    private let playerView = UIView()
    private let playerViewController = PlayerViewController()
    
    private var downloadAudio = [Audio]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadData),
                                               name: NSNotification.Name(rawValue: EpubReaderHelper.RemoveAudioSuccessNotification),
                                               object: nil)
        
        setupUI()
        setupConstranst()
        loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if AudioPlayer.shared.sound != nil && !playerView.isHidden {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: MainTabBarViewController.HideShowAudioPlayer), object: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstranst()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        self.title = "Audio đã tải".uppercased()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(label)
        self.view.addSubview(bookTableView)
        
        playerView.addSubview(miniAudioPlayerView)
        playerView.isHidden = true
        self.view.addSubview(playerView)
    }
    
    private func setupConstranst() {
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        bookTableView.snp.makeConstraints{ (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(112)
            make.size.equalTo(CGSize(width: frameWidth, height: frameHeight))
        }
        
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
    
    // MARK: Handle favorite data
    @objc private func loadData() {
        if EpubReaderHelper.shared.user != nil {
            downloadAudio = EpubReaderHelper.shared.downloadAudio
            if downloadAudio.count > 0 {
                self.bookTableView.isHidden = false
                self.bookTableView.reloadData()
                self.label.isHidden = true
            } else {
                self.bookTableView.isHidden = true
                self.bookTableView.reloadData()
                self.label.isHidden = false
            }
        }
    }
    
    private func handleShowMiniPlayer() {
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

extension AudioDownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadAudio.count
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
        let audio = downloadAudio[indexPath.row]
        cell.selectionStyle = .none
        cell.configureAudio(audio: audio)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audio = downloadAudio[indexPath.row]
        if audio.fileAudio != "" {
            var thumbnail = ""
            for book in EpubReaderHelper.shared.books {
                if audio.book_id == book.id {
                    thumbnail = book.thumbnail
                }
            }
            Utilities.shared.openAudioPlayer(audio: audio, thumbnail: thumbnail)
            Utilities.shared.showFullScreenAudio()
            handleShowMiniPlayer()
        } else {
            Utilities.shared.showAlertDialog(title: "", message: "Sorry, this audio is comming soon")
        }
    }
}

extension AudioDownloadsViewController: MiniAudioPlayerViewDelegate {
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
