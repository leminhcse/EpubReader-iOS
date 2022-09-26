//
//  HomeViewController.swift
//  EpubReader
//
//  Created by MacBook on 5/23/22.
//

import UIKit
import ScrollableSegmentedControl

class HomeViewController: BaseViewController {
    
    private var viewControllers = [UIViewController]()
    private var pageViewController = UIPageViewController()
    
    private let listTopic = ["KĨ NĂNG SỐNG", "KINH TẾ - TÀI CHÍNH", "VĂN HỌC - TIỂU THUYẾT", "VĂN HÓA - LỊCH SỬ", "KHOA HỌC - KĨ THUẬT", "SỨC KHỎE - TÂM LÝ"]
    
    private lazy var segmentedControl: ScrollableSegmentedControl = {
        let segmentFrame: CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        let segmentedControl = ScrollableSegmentedControl.init(frame: segmentFrame)
        let boldFont = UIFont(name: "Helvetica-Bold", size: 14.0)
        for i in 0..<(listTopic.count) {
            segmentedControl.insertSegment(withTitle: listTopic[i], at: i)
        }
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.underlineSelected = true
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: boldFont as Any], for: .normal)
        segmentedControl.layer.masksToBounds = false
        segmentedControl.layer.shadowOpacity = 0.8
        segmentedControl.layer.shadowOffset = CGSize(width: 0, height: 2)
        segmentedControl.layer.shadowColor = UIColor.gray.cgColor
        return segmentedControl
    }()
    
    private func menuButton() -> UIBarButtonItem {
        let size = CGSize(width: 30, height: 30)
        let view = UIView(frame: CGRect(origin: .zero, size: size))
        let button = UIButton(type: .system)
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        button.tintColor = UIColor.white
        button.setImage(UIImage(named: "menu.png"), for: .normal)
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        button.applyNavBarConstraints(size: button.frame.size)
        view.addSubview(button)
        return UIBarButtonItem(customView: view)
    }
    
    // MARK: UIViewController - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupViewControllers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    // MARK: SETUP UI
    private func setupView() {
        view.backgroundColor = UIColor.white
        
        title = "TRANG CHỦ"
        navigationItem.leftBarButtonItem = menuButton()
        
        view.addSubview(segmentedControl)
        view.addSubview(pageViewController.view)
        addChild(pageViewController)
        
        pageViewController.didMove(toParent: self)
    }
    
    private func setupViewControllers() {
        viewControllers.append(SkillsViewController())
        viewControllers.append(EconomicsViewController())
        viewControllers.append(LiteraryViewController())
        viewControllers.append(CultureHistoryViewController())
        viewControllers.append(ScienceTechnologyViewController())
        viewControllers.append(HealthViewController())
        
        pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: false, completion: nil)
    }
    
    private func setupConstraints() {
        let safeAreaTop = self.view.safeAreaInsets.top
        let segmentControlsTop = safeAreaTop
        
        segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(segmentControlsTop)
            make.height.equalTo(64)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        pageViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom).offset(4)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: EVENTS METHODS
    @objc func ButtonTapped() {
        print("Button Tapped")
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
        let tabPosition = sender.selectedSegmentIndex
        pageViewController.setViewControllers([viewControllers[tabPosition]], direction: .forward, animated: false, completion: nil)
    }
    
    @objc func menuButtonTapped() {
        let menuController = SideMenuViewController()
        if UI_USER_INTERFACE_IDIOM() == .phone {
            let value = NSNumber(value: UIInterfaceOrientation.portrait.rawValue)
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        let navigationController = UINavigationController(rootViewController: menuController)
        navigationController.modalPresentationStyle = .overFullScreen
        if let tabBarController = tabBarController {
            tabBarController.present(navigationController, animated: false) {
                menuController.HandleAnimationTapperMenu()
            }
        } else {
            present(navigationController, animated: false) {
                menuController.HandleAnimationTapperMenu()
            }
        }
    }
}
