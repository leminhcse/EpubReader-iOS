//
//  SignInViewController.swift
//  EpubReader
//
//  Created by mac on 18/09/2022.
//

import UIKit
import SnapKit
import GoogleSignIn
import FBSDKLoginKit

class SignInViewController: UIViewController {
    
    private var userViewModel = UserViewModel()
    
    // MARK: - Private Variables
    private static let CLIENT_ID = "390562581850-n9o3gbovbr023j0orfavrgh01mq59r4n.apps.googleusercontent.com"
    
    // MARK: - Private Controls
    private lazy var title1: UILabel = {
        let title1 = UILabel()
        title1.textColor = UIColor.black
        title1.backgroundColor = .clear
        title1.textAlignment = .center
        title1.sizeToFit()
        title1.text = "Let's Get Started"
        title1.font = UIFont.font(with: .h1)
        if UIDevice.current.userInterfaceIdiom == .pad {
            title1.font = UIFont.font(with: .h0)
        }
        return title1
    }()
    
    private lazy var title2: UILabel = {
        let title2 = UILabel()
        title2.textColor = UIColor.gray
        title2.backgroundColor = .clear
        title2.textAlignment = .center
        title2.sizeToFit()
        title2.numberOfLines = 2
        title2.text = "Chào mừng bạn đến với iSach"
        title2.font = UIFont.font(with: .h2)
        if UIDevice.current.userInterfaceIdiom == .pad {
            title2.font = UIFont.font(with: .h1)
        }
        return title2
    }()
    
    private lazy var googleSignButton: UIButton = {
        let googleSignButton = UIButton()
        googleSignButton.layer.borderWidth = 2
        googleSignButton.addTarget(self, action: #selector(googleAuthLogin), for: .touchUpInside)
        googleSignButton.setTitle("Tiếp tục bằng Google", for: .normal)
        googleSignButton.setTitleColor(UIColor.color(with: .background), for: .normal)
        googleSignButton.titleLabel?.font = UIFont.font(with: .h3)
        googleSignButton.layer.cornerRadius = 24
        if UIDevice.current.userInterfaceIdiom == .pad {
            googleSignButton.titleLabel?.font = UIFont.font(with: .h1)
            googleSignButton.layer.cornerRadius = 32
        }
        googleSignButton.setImage(UIImage(named: "google_icon"), for: .normal)
        googleSignButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        return googleSignButton
    }()
    
    private lazy var facebookSignInButton: UIButton = {
        let facebookSignInButton = UIButton()
        facebookSignInButton.layer.borderWidth = 2
        facebookSignInButton.addTarget(self, action: #selector(facebookAuthLogin), for: .touchUpInside)
        facebookSignInButton.setTitle("Tiếp tục với Facbook", for: .normal)
        facebookSignInButton.setTitleColor(UIColor.color(with: .background), for: .normal)
        facebookSignInButton.titleLabel?.font = UIFont.font(with: .h3)
        facebookSignInButton.layer.cornerRadius = 24
        if UIDevice.current.userInterfaceIdiom == .pad {
            facebookSignInButton.titleLabel?.font = UIFont.font(with: .h1)
            facebookSignInButton.layer.cornerRadius = 32
        }
        facebookSignInButton.setImage(UIImage(named: "facebook_icon"), for: .normal)
        facebookSignInButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18)
        return facebookSignInButton
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.style(with: .close)
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

    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotoHome(_:)),
                                               name: NSNotification.Name(rawValue: EpubReaderHelper.SignInSuccessfullyNotification), object: nil)
        self.view.backgroundColor = .white
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupConstraints()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        self.view.addSubview(title1)
        self.view.addSubview(title2)
        self.view.addSubview(googleSignButton)
        self.view.addSubview(facebookSignInButton)
        
        closeButtonView.addSubview(closeButton)
        self.view.addSubview(closeButtonView)
    }
    
    private func setupConstraints() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        let top: CGFloat = 24
        let signInButtonWidth = width/2 + 72
        let title1Top = height/2 - 192
        var buttonHeight: CGFloat = 48
        let padding: CGFloat = 48
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            buttonHeight = 64
        }
        
        closeButtonView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().inset(64)
            make.leading.equalTo(width - 64)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }

        closeButton.snp.makeConstraints{ (make) in
            make.size.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(4)
            make.top.equalToSuperview().inset(4)
        }
        
        title1.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(title1Top)
            make.size.equalTo(CGSize(width: signInButtonWidth*2, height: buttonHeight))
        }
        
        let title2Height: CGFloat = buttonHeight + top
        title2.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.centerX.equalToSuperview()
            make.top.equalTo(title1.snp.bottom)
            make.size.equalTo(CGSize(width: signInButtonWidth*2, height: title2Height))
        }
        
        googleSignButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(title2.snp.bottom).offset(top)
            make.size.equalTo(CGSize(width: signInButtonWidth, height: buttonHeight))
        }
        
        facebookSignInButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(googleSignButton.snp.bottom).offset(top)
            make.size.equalTo(CGSize(width: signInButtonWidth, height: buttonHeight))
        }
    }
    
    private func gotoHomeScreen() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let controller = MainTabBarViewController()
        appDelegate.window?.rootViewController = controller
        appDelegate.window?.makeKeyAndVisible()

        AppAppearanceDesigner.updateNavigationBarAppearance()
        AppAppearanceDesigner.updateTabBarAppearance()
        AppAppearanceDesigner.updateScrollableSegmentedControl()
    }
    
    private func getUserProfile(token: AccessToken?, userId: String?) {
        let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, picture, email"])
        graphRequest.start { _, result, error in
            if error == nil {
                let data: [String: AnyObject] = result as! [String: AnyObject]
                
                var fbName = ""
                var fbEmail = ""
                
                if let facebookName = data["name"] as? String {
                    fbName = facebookName
                }

                let facebookProfilePicURL = "https://graph.facebook.com/\(userId ?? "")/picture?type=large"
                if let facebookEmail = data["email"] as? String {
                    fbEmail = facebookEmail
                }
                
                let userInfo = User()
                userInfo.email = fbEmail
                userInfo.name = fbName
                userInfo.avatar = facebookProfilePicURL
                userInfo.access_token = token?.tokenString ?? ""
                userInfo.type = "0"
                userInfo.isPurchased = "0"
                
                self.userViewModel.isUserExists(email: userInfo.email, name: userInfo.name) { success in
                    if success == true {
                        self.gotoHomeScreen()
                    } else {
                        self.userViewModel.putUser(user: userInfo)
                    }
                }
            } else {
                print("Error: Trying to get user's info")
            }
        }
    }
    
    // MARK: SignIn Action Events
    @objc func googleAuthLogin() {
        let signInConfig = GIDConfiguration.init(clientID: SignInViewController.CLIENT_ID)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            if error == nil {
                guard let user = user else {
                    print("Uh oh. The user cancelled the Google login.")
                    return
                }
                //let userId = user.userID ?? ""
                let userIdToken = user.authentication.idToken ?? ""
                let userEmail = user.profile?.email ?? ""
                let googleProfilePicURL = user.profile?.imageURL(withDimension: 150)?.absoluteString ?? ""

                let userInfo = User()
                userInfo.email = userEmail
                userInfo.name = user.profile?.name ?? ""
                userInfo.avatar = googleProfilePicURL
                userInfo.access_token = userIdToken
                userInfo.type = "0"
                userInfo.isPurchased = "0"
                
                self.userViewModel.isUserExists(email: userInfo.email, name: userInfo.name) { success in
                    if success == true {
                        self.gotoHomeScreen()
                    } else {
                        self.userViewModel.putUser(user: userInfo)
                    }
                }
            }
        }
    }
    
    @objc func facebookAuthLogin() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: { result, error in
            if error != nil {
                print("ERROR: Trying to get login results")
            } else if result?.isCancelled != nil {
                print("The token is \(result?.token?.tokenString ?? "")")
                if result?.token?.tokenString != nil {
                    print("Logged in")
                    self.getUserProfile(token: result?.token, userId: result?.token?.userID)
                } else {
                    print("Cancelled")
                }
            }
        })
    }
    
    @objc func gotoHome(_ notification: NSNotification) {
        gotoHomeScreen()
    }
    
    @objc func closeButtonTapped() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
