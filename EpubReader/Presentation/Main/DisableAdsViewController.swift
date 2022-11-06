//
//  DisableAdsViewController.swift
//  EpubReader
//
//  Created by mac on 26/09/2022.
//

import UIKit
import WebKit
import SnapKit

class DisableAdsViewController: UIViewController {
    
    private lazy var swipeView: UIView = {
        let swipeView = UIView()
        swipeView.backgroundColor = UIColor(hex: "#CECECE")
        swipeView.layer.cornerRadius = 3
        return swipeView
    }()
    
    private lazy var purchaseView: UIView = {
        let purchaseView = UIView()
        purchaseView.backgroundColor = .white
        return purchaseView
    }()
    
    private lazy var purchaseButton: UIButton = {
        let purchaseButton = UIButton()
        purchaseButton.layer.cornerRadius = 20
        purchaseButton.backgroundColor = UIColor.color(with: .background)
        purchaseButton.setTitle("Mua gói Premimum", for: .normal)
        purchaseButton.addTarget(self, action: #selector(purchaseTapped), for: .touchUpInside)
        return purchaseButton
    }()
    
    private lazy var wkWebViewDes: WKWebView = {
        let wkWebViewDes = WKWebView(frame: .zero)
        wkWebViewDes.scrollView.isScrollEnabled = true
        wkWebViewDes.contentMode = .scaleAspectFit
        wkWebViewDes.isOpaque = false
        wkWebViewDes.scrollView.showsVerticalScrollIndicator = false
        wkWebViewDes.scrollView.showsHorizontalScrollIndicator = false
        wkWebViewDes.backgroundColor = .clear
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
        self.title = "Tắt Quảng Cáo".uppercased()
        
        purchaseView.addSubview(purchaseButton)
        self.view.addSubview(swipeView)
        self.view.addSubview(wkWebViewDes)
        self.view.addSubview(purchaseView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        var purchaseViewHeight = CGFloat(120)
        let webWidth = width - 24
        let webHeight = height - purchaseViewHeight
        var buttonHeight = CGFloat(42)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            buttonHeight = 72
            purchaseViewHeight = 164
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
        
        purchaseView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: width, height: purchaseViewHeight))
            make.top.equalTo(wkWebViewDes.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        purchaseButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: width/2 + 64, height: buttonHeight))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: Load data
    private func loadWebView() {
        if let path = Bundle.main.path(forResource: "disable_ads", ofType: "html") {
            let contents = try! String(contentsOfFile: path, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: path)
            wkWebViewDes.loadHTMLString(contents as String, baseURL: baseUrl)
        }
    }
    
    // MARK: Events Method
    @objc private func purchaseTapped() {
        print("tapped")
    }
}
