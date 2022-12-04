//
//  SideMenuViewController.swift
//  EpubReader
//
//  Created by mac on 25/09/2022.
//

import UIKit
import SnapKit

class SideMenuViewController: BaseViewController {

    var viewMenu: UIView!
    var menuTableView = UITableView()
    var buttonViewCloseTouch: UIButton!
    var ratiowidth: CGFloat = 0.815
    
    private let listMenu = ["Profile", "Về Chúng Tôi", "Đánh Gía", "Tắt Quảng Cáo"]
    
    // MARK: UIViewController - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraint()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraint()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        viewMenu = UIView()
        viewMenu.backgroundColor = .white
        viewMenu.layer.shadowColor = UIColor.black.cgColor
        viewMenu.layer.shadowOffset = CGSize(width: 4, height: 0)
        viewMenu.layer.shadowOpacity = 0.2
        viewMenu.layer.shadowRadius = 4.0
        viewMenu.layer.masksToBounds = false
        viewMenu.isHidden = true
        self.view.addSubview(viewMenu)
        
        buttonViewCloseTouch = UIButton()
        buttonViewCloseTouch.isAccessibilityElement = true
        buttonViewCloseTouch.accessibilityIdentifier = "CloseMenuButton"
        buttonViewCloseTouch.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.view.addSubview(buttonViewCloseTouch)
        
        menuTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuTableViewCell")
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        menuTableView.separatorInset = .zero
        menuTableView.backgroundColor = .clear
        self.view.addSubview(menuTableView)
    }
    
    private func setupConstraint() {
        viewMenu.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: frameWidth*ratiowidth, height: frameHeight))
        }
        buttonViewCloseTouch.snp.makeConstraints { (make) in
            make.leading.equalTo(frameWidth*ratiowidth)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: frameWidth*(1 - ratiowidth), height: frameHeight))
        }
        menuTableView.snp.makeConstraints{ (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(14)
            make.size.equalTo(CGSize(width: frameWidth*ratiowidth, height: frameHeight))
        }
    }
    
    // MARK: Action Methods
    @objc func cancelButtonTapped(){
        buttonViewCloseTouch.isUserInteractionEnabled = false
        self.view.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.2, animations: {
            var frame = self.viewMenu.frame
            frame.origin.x = -self.viewMenu.frame.width
            self.viewMenu.frame = frame
        }, completion: { _ in
            self.dismiss(animated: false, completion: {
                if let controller = UIApplication.topViewController() as? SideMenuViewController {
                    controller.dismiss(animated: false, completion: nil)
                }
            })
        })
    }
    
    func HandleAnimationTapperMenu(){
        self.viewMenu.frame = CGRect(x: -frameWidth*ratiowidth, y: 0, width: frameWidth*ratiowidth, height: frameHeight)
        self.viewMenu.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.viewMenu.frame = CGRect(x: 0, y: 0, width: self.frameWidth*self.ratiowidth, height: self.frameHeight)
        }, completion: nil)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource - Methods
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listMenu.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 80
        }
        return 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        let title = self.listMenu[indexPath.row]
        cell.title.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = self.listMenu[indexPath.row]
        switch title {
        case self.listMenu[0]:
            let viewController = ProfileViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
            break
        case self.listMenu[1]:
            let viewController = AboutViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
            break
        case self.listMenu[2]:
            break
        case self.listMenu[3]:
            let viewController = DisableAdsViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
            break
        default:
            break
        }
    }
}
