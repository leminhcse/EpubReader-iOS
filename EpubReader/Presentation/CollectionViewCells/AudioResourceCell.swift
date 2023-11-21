//
//  AudioResourceCell.swift
//  EpubReader
//
//  Created by mac on 25/08/2022.
//

import UIKit
import SnapKit
import RxSwift

class AudioResourceCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var progressDownloadView: ProgressBarView!
    
    private var imageSound = UIImage(named: "headphones.png")?.withRenderingMode(.alwaysTemplate)
    private var downloadObsDisposable: Disposable?
    private var audio: Audio?
    
    private let disposeBag = DisposeBag()
    
    var progressDownload: Float! {
        didSet {
            DispatchQueue.main.async {
                self.progressDownloadView.progress = self.progressDownload
            }
        }
    }
    
    // MARK: - UICollectionViewCell life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraint()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.tintColor = UIColor.color(with: .background)
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.backgroundColor = .clear
        titleLabel.numberOfLines = 2
        titleLabel.sizeToFit()
        titleLabel.font = UIFont.font(with: .h5)
        
        progressDownloadView = ProgressBarView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        progressDownloadView.tintColor = UIColor.color(with: .darkColor)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(downloadAudioClick))
        progressDownloadView.addGestureRecognizer(gesture)
        progressDownloadView.isHidden = false
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(progressDownloadView)
    }
    
    private func setupConstraint() {
        let cellWidth = self.frame.size.width - 2*24
        self.contentView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(CGSize(width: self.frame.size.width, height: 50))
        }
        
        imageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.size.equalTo(CGSize(width: cellWidth - 96, height: 36))
            make.centerY.equalToSuperview()
        }
        
        progressDownloadView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.trailing).offset(24)
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureDownloadView() {
        guard let progressDownloadView = progressDownloadView else {
            return
        }
        if self.isAudioDownloaded() {
            progressDownloadView.status = .finish
        } else {
            progressDownloadView.status = .notDownloaded
        }
    }
    
    private func subscribeDownloadProgress(downloadObs: BehaviorSubject<Float>) {
        downloadObsDisposable?.dispose()
        downloadObsDisposable = downloadObs.subscribe(onNext: { [weak self] progress in
            print("download progress is = \(progress)")
            self?.progressDownload = progress
        }, onError: { [weak self] _ in
            self?.configureDownloadView()
        }, onCompleted: { [weak self] in
            self?.configureDownloadView()
        })
        downloadObsDisposable?.disposed(by: self.disposeBag)
    }
    
    private func isAudioDownloaded() -> Bool {
        if let url = URL(string: self.audio!.fileAudio) {
            let fileName = url.lastPathComponent
            let path: String = Utilities.shared.getFileExist(fileName: fileName)
            if path != "" {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    @objc func downloadAudioClick() {
        if !Reachability.shared.isConnectedToNetwork {
            Utilities.shared.noConnectionAlert()
            return
        }
        
        if EpubReaderHelper.shared.user == nil {
            Utilities.shared.showLoginDialog()
            return
        }
        
        if Reachability.shared.isConnectedViaCellular {
            let alert = UIAlertController(title: "Download Wifi Only",
                                          message: "Please update your settings in the profile screen to download using mobile data",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(action)
            DispatchQueue.main.async {
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        if progressDownloadView.status == .finish {
            if let id = self.audio?.id,
                let itemPath = DatabaseHelper.getFilePath(id: id),
                FileManager.default.fileExists(atPath: itemPath) {
                
                var title = ""
                if let audioTitle = self.audio?.title {
                    title = audioTitle
                }
                
                let alert = UIAlertController(title: "\(title)",
                                              message: "Bạn có chắc chắn muốn loại bỏ tệp này không?",
                                              preferredStyle: .alert)
                let deleteAction = UIAlertAction(title: "Có", style: .default, handler: { (action) in
                    try? FileManager.default.removeItem(atPath: itemPath)
                    self.progressDownloadView.status = .notDownloaded
                    EpubReaderHelper.shared.downloadAudio.removeAll(where: {$0.id == self.audio?.id})
                    PersistenceHelper.saveAudioData(object: EpubReaderHelper.shared.downloadAudio, key: "downloadAudio")
                    BannerNotification.downloadDeleted(title: title).present()
                })
                let cancelAction = UIAlertAction(title: "Không", style: .cancel)
                
                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                
                DispatchQueue.main.async{
                    if let viewController = UIApplication.topViewController() {
                        viewController.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else if progressDownloadView.status == .notDownloaded {
            progressDownloadView.progress = 0.0
            if let url = URL(string: self.audio?.fileAudio ?? "") {

            }
        } else {
            if let id = self.audio?.id {
                ApiWebService.shared.cancelDownload(audioId: id)
                progressDownloadView.status = .notDownloaded
            }
        }
    }
    
    // MARK: - Public Methods
    public func configure(audio: Audio) {
        self.audio = audio
        titleLabel.text = audio.title
        imageView.image = imageSound
        
        configureDownloadView()
    }
    
    static func sizeForResource(audio: Audio,cellWidth: CGFloat, cell: AudioResourceCell?) -> CGSize {
        return CGSize(width: max(cellWidth, 0), height: max(40, 0))
    }
}
