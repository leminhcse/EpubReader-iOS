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
    
    // MARK: - Private Variables
    private static let CLIENT_ID = "390562581850-n9o3gbovbr023j0orfavrgh01mq59r4n.apps.googleusercontent.com"
    
    // MARK: - Private Controls
    private lazy var title1: UILabel = {
        let title1 = UILabel()
        title1.textColor = UIColor.black
        title1.backgroundColor = .clear
        title1.textAlignment = .center
        title1.sizeToFit()
        title1.font = UIFont.font(with: .h1)
        title1.text = "Let's Get Started"
        return title1
    }()
    
    private lazy var title2: UILabel = {
        let title2 = UILabel()
        title2.textColor = UIColor.gray
        title2.backgroundColor = .clear
        title2.textAlignment = .center
        title2.sizeToFit()
        title2.font = UIFont.font(with: .h2)
        title2.numberOfLines = 2
        title2.text = "Make a login using with social network accounts"
        return title2
    }()
    
    private lazy var googleSignButton: UIButton = {
        let googleSignButton = UIButton()
        googleSignButton.layer.borderWidth = 2
        googleSignButton.layer.cornerRadius = 24
        googleSignButton.addTarget(self, action: #selector(googleAuthLogin), for: .touchUpInside)
        googleSignButton.setTitle("Sign in with Google", for: .normal)
        googleSignButton.setTitleColor(UIColor.color(with: .background), for: .normal)
        googleSignButton.titleLabel?.font = UIFont.font(with: .h3)
        googleSignButton.setImage(UIImage(named: "google_icon"), for: .normal)
        googleSignButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        return googleSignButton
    }()
    
    private lazy var facebookSignInButton: UIButton = {
        let facebookSignInButton = UIButton()
        facebookSignInButton.layer.borderWidth = 2
        facebookSignInButton.layer.cornerRadius = 24
        facebookSignInButton.addTarget(self, action: #selector(facebookAuthLogin), for: .touchUpInside)
        facebookSignInButton.setTitle("Sign in with Facbook", for: .normal)
        facebookSignInButton.setTitleColor(UIColor.color(with: .background), for: .normal)
        facebookSignInButton.titleLabel?.font = UIFont.font(with: .h3)
        facebookSignInButton.setImage(UIImage(named: "facebook_icon"), for: .normal)
        facebookSignInButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18)
        return facebookSignInButton
    }()

    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    private func setupConstraints() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        let top: CGFloat = 24
        let signInButtonWidth = width/2 + 72
        let title1Top = height/2 - 192
        let buttonHeight: CGFloat = 48
        let padding: CGFloat = 48
        
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
    
    // MARK: SignIn Action Events
    @objc func googleAuthLogin() {
        let signInConfig = GIDConfiguration.init(clientID: SignInViewController.CLIENT_ID)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            if error == nil {
                guard let user = user else {
                    print("Uh oh. The user cancelled the Google login.")
                    return
                }
                let userId = user.userID ?? ""
                print("Google User ID: \(userId)")
                
                let userIdToken = user.authentication.idToken ?? ""
                print("Google ID Token: \(userIdToken)")
                
                let userFirstName = user.profile?.givenName ?? ""
                print("Google User First Name: \(userFirstName)")
                
                let userLastName = user.profile?.familyName ?? ""
                print("Google User Last Name: \(userLastName)")
                
                let userEmail = user.profile?.email ?? ""
                print("Google User Email: \(userEmail)")
                
                let googleProfilePicURL = user.profile?.imageURL(withDimension: 150)?.absoluteString ?? ""
                print("Google Profile Avatar URL: \(googleProfilePicURL)")
                self.gotoHomeScreen()
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

    func getUserProfile(token: AccessToken?, userId: String?) {
        let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, picture, email"])
        graphRequest.start { _, result, error in
            if error == nil {
                let data: [String: AnyObject] = result as! [String: AnyObject]
                
                // Facebook Id
                if let facebookId = data["id"] as? String {
                    print("Facebook Id: \(facebookId)")
                } else {
                    print("Facebook Id: Not exists")
                }
                
                // Facebook First Name
                if let facebookFirstName = data["first_name"] as? String {
                    print("Facebook First Name: \(facebookFirstName)")
                } else {
                    print("Facebook First Name: Not exists")
                }
                
                // Facebook Middle Name
                if let facebookMiddleName = data["middle_name"] as? String {
                    print("Facebook Middle Name: \(facebookMiddleName)")
                } else {
                    print("Facebook Middle Name: Not exists")
                }
                
                // Facebook Last Name
                if let facebookLastName = data["last_name"] as? String {
                    print("Facebook Last Name: \(facebookLastName)")
                } else {
                    print("Facebook Last Name: Not exists")
                }
                
                // Facebook Name
                if let facebookName = data["name"] as? String {
                    print("Facebook Name: \(facebookName)")
                } else {
                    print("Facebook Name: Not exists")
                }
                
                // Facebook Profile Pic URL
                let facebookProfilePicURL = "https://graph.facebook.com/\(userId ?? "")/picture?type=large"
                print("Facebook Profile Pic URL: \(facebookProfilePicURL)")
                
                // Facebook Email
                if let facebookEmail = data["email"] as? String {
                    print("Facebook Email: \(facebookEmail)")
                } else {
                    print("Facebook Email: Not exists")
                }
                
                print("Facebook Access Token: \(token?.tokenString ?? "")")
                self.gotoHomeScreen()
            } else {
                print("Error: Trying to get user's info")
            }
        }
    }
}
