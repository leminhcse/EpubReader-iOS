//
//  UserViewModel.swift
//  EpubReader
//
//  Created by mac on 30/09/2022.
//

import UIKit
import RxSwift
import Alamofire

class UserViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    private let putUserUrl = "https://minhdev2006.com/PHP_API/addUser.php"
    
    override init() {
        super.init()
    }
    
    func putUser(user: User) {
        let parameters = ["email": user.email,
                          "name": user.name,
                          "avatar": user.avatar,
                          "access_token": user.access_token,
                          "type": user.type,
                          "isPurchased": user.isPurchased]
        AF.request(putUserUrl, parameters: parameters).response { response in
            let success = response.response?.statusCode
            if success == 200 {
                self.getUser(email: user.email, name: user.name)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: EpubReaderHelper.SignInFailedNotification), object: nil)
            }
        }
    }
    
    func getUser(email: String, name: String) {
        ApiWebService.shared.getUser(email: email, name: name)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { list in
                print("Get user success")
                let user = User()
                for item in list {
                    user.id = item.id
                    user.email = item.email
                    user.name = item.name
                    user.access_token = item.access_token
                    user.avatar = item.avatar
                    user.isPurchased = item.isPurchased
                    user.type = item.type
                }
                PersistenceHelper.saveUser(object: user, key: "User")
                EpubReaderHelper.shared.user = user
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: EpubReaderHelper.SignInSuccessfullyNotification), object: nil)
            }, onError: { error in
                switch error {
                case ApiError.conflict:
                    print("Conflict error")
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func isUserExists(email: String, name: String, completion: ((Bool) -> Void)? = nil) {
        ApiWebService.shared.getUser(email: email, name: name)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { list in
                print("Get user success")
                if list.count > 0 {
                    let user = User()
                    for item in list {
                        user.id = item.id
                        user.email = item.email
                        user.name = item.name
                        user.access_token = item.access_token
                        user.avatar = item.avatar
                        user.isPurchased = item.isPurchased
                        user.type = item.type
                    }
                    PersistenceHelper.saveUser(object: user, key: "User")
                    EpubReaderHelper.shared.user = user
                    completion?(true)
                } else {
                    completion?(false)
                }
            }, onError: { error in
                switch error {
                case ApiError.conflict:
                    print("Conflict error")
                    completion?(false)
                case ApiError.forbidden:
                    print("Forbidden error")
                    completion?(false)
                case ApiError.notFound:
                    print("Not found error")
                    completion?(false)
                default:
                    print("Unknown error:", error)
                    completion?(false)
                }
            })
            .disposed(by: disposeBag)
    }
}
