//
//  ProfileViewController.swift
//  EpubReader
//
//  Created by mac on 26/09/2022.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    private let profileIcon = UIImage.init(named: "ic_profile.png")?.withRenderingMode(.alwaysTemplate)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private lazy var profileView: UIView = {
        let profileView = UIView()
        profileView.backgroundColor = .white
        return profileView
    }()
    
    private lazy var swipeView: UIView = {
        let swipeView = UIView()
        swipeView.backgroundColor = UIColor(hex: "#CECECE")
        return swipeView
    }()
    
    private lazy var settingsView: UIView = {
        let settingsView = UIView()
        settingsView.backgroundColor = .white
        return settingsView
    }()
    
    private lazy var deleteDownloadView: UIView = {
        let deleteDownloadView = UIView()
        deleteDownloadView.backgroundColor = .white
        return deleteDownloadView
    }()
    
    private lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.backgroundColor = .clear
        profileImage.clipsToBounds = true
        profileImage.tintColor = UIColor.color(with: .background)
        profileImage.layer.cornerRadius = 40
        if UIDevice.current.userInterfaceIdiom == .pad {
            profileImage.layer.cornerRadius = 64
        }
        return profileImage
    }()
    
    private lazy var profileNameLabel: UILabel = {
        let profileNameLabel = UILabel()
        profileNameLabel.font = UIFont.font(with: .h5)
        profileNameLabel.textColor = .darkGray
        profileNameLabel.backgroundColor = .clear
        profileNameLabel.numberOfLines = 1
        profileNameLabel.textAlignment = .center
        profileNameLabel.text = "Bạn hiện chưa đăng nhập"
        profileNameLabel.font = UIFont.font(with: .h5)
        if UIDevice.current.userInterfaceIdiom == .pad {
            profileNameLabel.font = UIFont.font(with: .h2)
        }
        return profileNameLabel
    }()
    
    private lazy var settingTitle: UILabel = {
        let settingTitle = UILabel()
        settingTitle.textColor = .darkGray
        settingTitle.backgroundColor = .clear
        settingTitle.text = "Settings"
        settingTitle.font = UIFont.font(with: .subtitle)
        if UIDevice.current.userInterfaceIdiom == .pad {
            settingTitle.font = UIFont.font(with: .h3)
        }
        return settingTitle
    }()
    
    private lazy var autoPlayLabel: UILabel = {
        let autoPlayLabel = UILabel()
        autoPlayLabel.textColor = .darkGray
        autoPlayLabel.backgroundColor = .clear
        autoPlayLabel.text = "Tự động phát audio tiếp theo"
        autoPlayLabel.font = UIFont.font(with: .h5)
        if UIDevice.current.userInterfaceIdiom == .pad {
            autoPlayLabel.font = UIFont.font(with: .h2)
        }
        return autoPlayLabel
    }()
    
    private lazy var continuePlayLabel: UILabel = {
        let continuePlayLabel = UILabel()
        continuePlayLabel.textColor = .darkGray
        continuePlayLabel.backgroundColor = .clear
        continuePlayLabel.text = "Cho phép phát audio ở background"
        continuePlayLabel.font = UIFont.font(with: .h5)
        if UIDevice.current.userInterfaceIdiom == .pad {
            continuePlayLabel.font = UIFont.font(with: .h2)
        }
        return continuePlayLabel
    }()

    private lazy var allowBackgroundLabel: UILabel = {
        let allowBackgroundLabel = UILabel()
        allowBackgroundLabel.textColor = .darkGray
        allowBackgroundLabel.backgroundColor = .clear
        allowBackgroundLabel.text = "Cho phép audio từ các ứng dụng khác được phát"
        allowBackgroundLabel.font = UIFont.font(with: .h5)
        if UIDevice.current.userInterfaceIdiom == .pad {
            allowBackgroundLabel.font = UIFont.font(with: .h2)
        }
        return allowBackgroundLabel
    }()
    
    private lazy var onlyDownloadLabel: UILabel = {
        let onlyDownloadLabel = UILabel()
        onlyDownloadLabel.textColor = .darkGray
        onlyDownloadLabel.backgroundColor = .clear
        onlyDownloadLabel.text = "Chỉ tải thông qua wifi"
        onlyDownloadLabel.font = UIFont.font(with: .h5)
        if UIDevice.current.userInterfaceIdiom == .pad {
            onlyDownloadLabel.font = UIFont.font(with: .h2)
        }
        return onlyDownloadLabel
    }()
    
    private lazy var darkModeLabel: UILabel = {
        let darkModeLabel = UILabel()
        darkModeLabel.textColor = .darkGray
        darkModeLabel.backgroundColor = .clear
        darkModeLabel.text = "Chế độ tối"
        darkModeLabel.font = UIFont.font(with: .h5)
        if UIDevice.current.userInterfaceIdiom == .pad {
            darkModeLabel.font = UIFont.font(with: .h2)
        }
        return darkModeLabel
    }()

    private lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.isEnabled = true
        switchControl.onTintColor = UIColor.color(with: .background)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return switchControl
    }()
    
    private lazy var switchControl1: UISwitch = {
        let switchControl1 = UISwitch()
        switchControl1.isOn = false
        switchControl1.isEnabled = true
        switchControl1.onTintColor = UIColor.color(with: .background)
        switchControl1.translatesAutoresizingMaskIntoConstraints = false
        switchControl1.addTarget(self, action: #selector(handleSwitchAction1), for: .valueChanged)
        return switchControl1
    }()
    
    private lazy var switchControl2: UISwitch = {
        let switchControl2 = UISwitch()
        switchControl2.isOn = false
        switchControl2.isEnabled = true
        switchControl2.onTintColor = UIColor.color(with: .background)
        switchControl2.translatesAutoresizingMaskIntoConstraints = false
        switchControl2.addTarget(self, action: #selector(handleSwitchAction2), for: .valueChanged)
        return switchControl2
    }()
    
    private lazy var switchControl3: UISwitch = {
        let switchControl3 = UISwitch()
        switchControl3.isOn = false
        switchControl3.isEnabled = true
        switchControl3.onTintColor = UIColor.color(with: .background)
        switchControl3.translatesAutoresizingMaskIntoConstraints = false
        switchControl3.addTarget(self, action: #selector(handleSwitchAction3), for: .valueChanged)
        return switchControl3
    }()
    
    private lazy var switchControl4: UISwitch = {
        let switchControl4 = UISwitch()
        switchControl4.isOn = false
        switchControl4.isEnabled = true
        switchControl4.onTintColor = UIColor.color(with: .background)
        switchControl4.translatesAutoresizingMaskIntoConstraints = false
        switchControl4.addTarget(self, action: #selector(handleSwitchAction4), for: .valueChanged)
        return switchControl4
    }()
    
    private lazy var downloadButton: UIButton = {
        let downloadButton = UIButton(type: .system)
        downloadButton.style(with: .profile)
        downloadButton.tintColor = UIColor.color(with: .background)
        downloadButton.contentHorizontalAlignment = .left
        downloadButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -32, bottom: 0, right: 0)
        downloadButton.customButton(title: "Xóa tất cả tệp đã tải")
        downloadButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return downloadButton
    }()
    
    private lazy var shareButton: UIButton = {
        let shareButton = UIButton(type: .system)
        shareButton.style(with: .profile)
        shareButton.tintColor = UIColor.color(with: .background)
        shareButton.contentHorizontalAlignment = .left
        shareButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -32, bottom: 0, right: 0)
        shareButton.customButton(title: "Chia sẻ ứng dụng tới người khác")
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        shareButton.isHidden = true
        return shareButton
    }()

    // MARK: UIViewController - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateStatusToogle()
        loadData()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "Hồ sơ".uppercased()
        
        profileImage.image = profileIcon
        profileView.addSubview(profileImage)
        profileView.addSubview(profileNameLabel)
        profileView.addSubview(swipeView)
        
        settingsView.addSubview(settingTitle)
        settingsView.addSubview(autoPlayLabel)
        settingsView.addSubview(continuePlayLabel)
        settingsView.addSubview(allowBackgroundLabel)
        settingsView.addSubview(onlyDownloadLabel)
        settingsView.addSubview(darkModeLabel)
        
        settingsView.addSubview(switchControl)
        settingsView.addSubview(switchControl1)
        settingsView.addSubview(switchControl2)
        settingsView.addSubview(switchControl3)
        settingsView.addSubview(switchControl4)
        
        settingsView.addSubview(downloadButton)
        //settingsView.addSubview(shareButton)
        
        scrollView.addSubview(profileView)
        scrollView.addSubview(settingsView)
        
        self.view.addSubview(scrollView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        let profileViewHeight = height/4
        let profileLabelWidth = width
        let profileLabelHeight = CGFloat(32)
        let paddingTop = CGFloat(12)
        
        let switchWidth = CGFloat(48)
        let switchTitleWidth = width - switchWidth
        let switchTitleHeight = CGFloat(28)
        var switchTop = CGFloat(8)
        
        var profileImageSize = CGFloat(90)
        var top = CGFloat(24)
        var padding = CGFloat(24)

        if UIDevice.current.userInterfaceIdiom == .pad {
            profileImageSize = CGFloat(128)
            switchTop = CGFloat(24)
            top = CGFloat(48)
            padding = CGFloat(48)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: width, height: height))
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        profileView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: width, height: profileViewHeight))
            make.top.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(top)
            make.size.equalTo(CGSize(width: profileImageSize, height: profileImageSize))
            make.centerX.equalToSuperview()
        }
        
        profileNameLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: profileLabelWidth, height: profileLabelHeight))
            make.top.equalTo(profileImage.snp.bottom).offset(paddingTop)
            make.centerX.equalToSuperview()
        }
        
        swipeView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(paddingTop)
            make.size.equalTo(CGSize(width: width-padding, height: 2))
            make.centerX.equalToSuperview()
        }
        
        // Settings view
        let settingsViewHeight = height - profileViewHeight
        settingsView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: width - padding, height: settingsViewHeight))
            make.top.equalTo(profileView.snp.bottom)
            make.centerX.equalToSuperview()
        }

        settingTitle.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(switchTitleHeight)
        }
    
        autoPlayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(settingTitle.snp.bottom).offset(switchTop)
            make.size.equalTo(CGSize(width: switchTitleWidth, height: switchTitleHeight))
            make.leading.equalToSuperview()
        }
        
        switchControl.snp.makeConstraints { (make) in
            make.top.equalTo(settingTitle.snp.bottom).offset(switchTop)
            make.width.equalTo(switchWidth)
            make.trailing.equalToSuperview()
        }
        
        continuePlayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(autoPlayLabel.snp.bottom).offset(switchTop + paddingTop)
            make.size.equalTo(CGSize(width: switchTitleWidth, height: switchTitleHeight))
            make.leading.equalToSuperview()
        }
        
        switchControl1.snp.makeConstraints { (make) in
            make.top.equalTo(autoPlayLabel.snp.bottom).offset(switchTop + paddingTop)
            make.width.equalTo(switchWidth)
            make.trailing.equalToSuperview()
        }
        
        allowBackgroundLabel.snp.makeConstraints { (make) in
            make.top.equalTo(continuePlayLabel.snp.bottom).offset(switchTop + paddingTop)
            make.size.equalTo(CGSize(width: switchTitleWidth, height: switchTitleHeight))
            make.leading.equalToSuperview()
        }
        
        switchControl2.snp.makeConstraints { (make) in
            make.top.equalTo(continuePlayLabel.snp.bottom).offset(switchTop + paddingTop)
            make.width.equalTo(switchWidth)
            make.trailing.equalToSuperview()
        }
        
        onlyDownloadLabel.snp.makeConstraints { (make) in
            make.top.equalTo(allowBackgroundLabel.snp.bottom).offset(switchTop + paddingTop)
            make.size.equalTo(CGSize(width: switchTitleWidth, height: switchTitleHeight))
            make.leading.equalToSuperview()
        }
        
        switchControl3.snp.makeConstraints { (make) in
            make.top.equalTo(allowBackgroundLabel.snp.bottom).offset(switchTop + paddingTop)
            make.width.equalTo(switchWidth)
            make.trailing.equalToSuperview()
        }
        
        darkModeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(onlyDownloadLabel.snp.bottom).offset(switchTop + paddingTop)
            make.size.equalTo(CGSize(width: switchTitleWidth, height: switchTitleHeight))
            make.leading.equalToSuperview()
        }
        
        switchControl4.snp.makeConstraints { (make) in
            make.top.equalTo(onlyDownloadLabel.snp.bottom).offset(switchTop + paddingTop)
            make.width.equalTo(switchWidth)
            make.trailing.equalToSuperview()
        }
        
        downloadButton.snp.makeConstraints { (make) in
            make.top.equalTo(darkModeLabel.snp.bottom).offset(switchTop + 8)
            make.size.equalTo(CGSize(width: width, height: switchTitleHeight + paddingTop))
            make.leading.equalToSuperview()
        }
        
//        shareButton.snp.makeConstraints { (make) in
//            make.top.equalTo(downloadButton.snp.bottom).offset(switchTop)
//            make.size.equalTo(CGSize(width: width, height: switchTitleHeight + paddingTop))
//            make.leading.equalToSuperview()
//        }
        
        downloadButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: width - padding, bottom: 4, right: 0)
        //shareButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: width - padding, bottom: 4, right: 0)
    }
    
    private func loadData() {
        if let user = EpubReaderHelper.shared.user {
            if let imagelUrl = URL(string: user.avatar) {
                profileImage.kf_setImage(url: imagelUrl) {_ in
                    self.profileImage.contentMode = .scaleAspectFill
                }
            }
            profileNameLabel.text = user.email
        }
    }
    
    private func updateStatusToogle() {
        if UserDefs.isAutoPlay {
            switchControl.isOn = true
        } else {
            switchControl.isOn = false
        }
        
        if UserDefs.continueAudioInBackground {
            switchControl1.isOn = true
        } else {
            switchControl1.isOn = false
        }
        
        if UserDefs.allowBackgroundAudio {
            switchControl2.isOn = true
        } else {
            switchControl2.isOn = false
        }
        
        if UserDefs.isDownloadViaWifi {
            switchControl3.isOn = true
        } else {
            switchControl3.isOn = false
        }
        
        if UserDefs.isDarkMode {
            switchControl4.isOn = true
        } else {
            switchControl4.isOn = false
        }
    }
    
    // MARK: Selector methods
    @objc private func handleSwitchAction() {
        print("Auto play next audio click")
        if switchControl.isOn {
            UserDefs.userSetting["isAutoPlay"] = true
        } else {
            UserDefs.userSetting["isAutoPlay"] = false
        }
    }
    
    @objc private func handleSwitchAction1() {
        print("Continue audio in background click")
        if switchControl1.isOn {
            UserDefs.userSetting["continueAudioInBackground"] = true
        } else {
            UserDefs.userSetting["continueAudioInBackground"] = false
        }
    }
    
    @objc private func handleSwitchAction2() {
        print("Allow audio from another apps click")
        var value = false
        if switchControl2.isOn {
            value = true
            UserDefs.userSetting["allowBackgroundAudio"] = true
            let msg = "When turned on you will not be able to use the audio controller when your screen is locked."
            let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(cancelAction)
            DispatchQueue.main.async {
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            }
        } else {
            value = false
            UserDefs.userSetting["allowBackgroundAudio"] = false
        }
        
        if value {
            MusicPlayerHelper.setupMixWitOthers()
        } else {
            MusicPlayerHelper.setupInterruptSpokenAudioAndMixWithOthers()
        }
    }
    
    @objc private func handleSwitchAction3() {
        print("Download via wifi click")
        if switchControl3.isOn {
            UserDefs.userSetting["isDownloadViaWifi"] = true
        } else {
            UserDefs.userSetting["isDownloadViaWifi"] = false
        }
    }
    
    @objc private func handleSwitchAction4() {
        print("Dark mode enable click")
        if switchControl4.isOn {
            UserDefs.userSetting["isDarkMode"] = true
        } else {
            UserDefs.userSetting["isDarkMode"] = false
        }
    }
    
    @objc private func deleteTapped() {
        let title = "Xóa tất cả sách đã tải"
        let msg = "Bạn có chắc chắn muốn xóa tất cả các nội dung đã tải không?"
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Đồng ý", style: .default) { action in
            Utilities.shared.deteleAllDownloads()
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .cancel)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func shareTapped() {
        print("shareTapped")
    }
}
