//
//  AboutViewController.swift
//  EpubReader
//
//  Created by mac on 26/09/2022.
//

import UIKit
import WebKit
import SnapKit

class AboutViewController: UIViewController {
    
    private lazy var swipeView: UIView = {
        let swipeView = UIView()
        swipeView.backgroundColor = UIColor(hex: "#CECECE")
        swipeView.layer.cornerRadius = 3
        return swipeView
    }()
    
    private lazy var sendEmailView: UIView = {
        let sendEmailView = UIView()
        sendEmailView.backgroundColor = .white
        return sendEmailView
    }()
    
    private lazy var sendEmailButton: UIButton = {
        let sendEmailButton = UIButton()
        sendEmailButton.layer.cornerRadius = 20
        sendEmailButton.backgroundColor = UIColor.color(with: .background)
        sendEmailButton.setTitle("Gửi email", for: .normal)
        sendEmailButton.addTarget(self, action: #selector(sendEmailTapped), for: .touchUpInside)
        return sendEmailButton
    }()
    
    private lazy var wkWebViewDes: WKWebView = {
        let wkWebViewDes = WKWebView(frame: .zero)
        wkWebViewDes.scrollView.isScrollEnabled = true
        wkWebViewDes.contentMode = .scaleAspectFit
        wkWebViewDes.isOpaque = false
        wkWebViewDes.scrollView.showsVerticalScrollIndicator = false
        wkWebViewDes.scrollView.showsHorizontalScrollIndicator = false
        wkWebViewDes.backgroundColor = .clear
        wkWebViewDes.scrollView.backgroundColor = .clear
        return wkWebViewDes
    }()

    // MARK: UIViewController - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadWebView()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "Về chúng tôi"
        
        sendEmailView.addSubview(sendEmailButton)
        self.view.addSubview(swipeView)
        self.view.addSubview(wkWebViewDes)
        self.view.addSubview(sendEmailView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        var emailViewHeight = CGFloat(100)
        let webWidth = width - 24
        let webHeight = height - emailViewHeight
        var buttonHeight = CGFloat(42)
        if UIDevice.current.userInterfaceIdiom == .pad {
            buttonHeight = 72
            emailViewHeight = 164
        }
        
        swipeView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(6)
            make.width.equalTo(128)
            make.centerX.equalToSuperview()
        }
        
        wkWebViewDes.snp.makeConstraints { (make) in
            make.top.equalTo(swipeView.snp.bottom).offset(12)
            make.height.equalTo(webHeight)
            make.width.equalTo(webWidth)
            make.centerX.equalToSuperview()
        }
        
        sendEmailView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: width, height: emailViewHeight))
            make.top.equalTo(wkWebViewDes.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        sendEmailButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: width/2, height: buttonHeight))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: Load data
    private func loadWebView() {
        if let path = Bundle.main.path(forResource: "about_us", ofType: "html") {
            let contents = try! String(contentsOfFile: path, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: path)
            wkWebViewDes.loadHTMLString(contents as String, baseURL: baseUrl)
        }
    }
    
    // MARK: Events Method
    @objc private func sendEmailTapped() {
        print("tapped")
    }
}
