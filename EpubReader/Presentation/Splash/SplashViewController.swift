//
//  SplashViewController.swift
//  EpubReader
//
//  Created by mac on 15/12/2022.
//

import UIKit
import SnapKit
import GoogleSignIn
import FBSDKCoreKit

class SplashViewController: UIViewController {

    // MARK: - Properties
    private var activityIndicator: UIActivityIndicatorView!
    private var splashScreenDismissed: (() -> Void)? = nil
    private var bookViewModel = BookViewModel()
    private var imageView: UIImageView!
    
    init(splashScreenDismissed: (() -> Void)? = nil) {
       super.init(nibName: nil, bundle: nil)
       self.splashScreenDismissed = splashScreenDismissed
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        imageView = UIImageView()
        imageView.image = UIImage(named: "ic_book.png")
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)

        let activityFrame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.backgroundColor = UIColor.black
        activityIndicator.alpha = 0.5
        activityIndicator.frame = activityFrame
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.layer.cornerRadius = 5
        activityIndicator.layer.masksToBounds = true
        self.view.addSubview(activityIndicator)
        
        self.activityIndicator.startAnimating()
        
        bookViewModel.getBookList() { success in
            if success {
                self.setupView()
            } else {
                Utilities.shared.showAlertDialog(title: "Error", message: "Đã xày ra lỗi, vui lòng kiểm tra kết nối internet!")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupView() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
              if error != nil || user == nil {
                  self.activityIndicator.stopAnimating()
                  let signInViewController = SignInViewController()
                  appDelegate.window?.rootViewController = signInViewController
              } else {
                  self.activityIndicator.stopAnimating()
                  self.setupMainTab()
              }
            }
            setupMainTab()
        } else if Utilities.shared.isFacebookSignedIn() {
            self.activityIndicator.stopAnimating()
            setupMainTab()
        } else {
            self.activityIndicator.stopAnimating()
            let signInViewController = SignInViewController()
            appDelegate.window?.rootViewController = signInViewController
        }
    }
    
    private func setupMainTab() {
        let controller = MainTabBarViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = controller
        AppAppearanceDesigner.updateNavigationBarAppearance()
        AppAppearanceDesigner.updateTabBarAppearance()
        AppAppearanceDesigner.updateScrollableSegmentedControl()
    }
}
