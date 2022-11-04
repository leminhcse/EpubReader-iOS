//
//  BookViewModel.swift
//  EpubReader
//
//  Created by MacBook on 6/5/22.
//

import Foundation
import RxSwift
import Alamofire

class BookViewModel: NSObject {
    
    var listBook = [Book]()
    var resultSearch = [Book]()
    
    private let disposeBag = DisposeBag()
    private let addFavoriteUrl = "http://minhhdmbp152019/PHP_API/addToFavorite.php"
    private let removeFavotireUrl = "http://minhhdmbp152019/PHP_API/removeFavorite.php"
    
    override init() {
        super.init()
    }
    
    func getBookList() {
        self.listBook.removeAll()
        if let data = PersistenceHelper.loadData(key: "Books") as? [Book] {
            self.listBook = Utilities.shared.importBookList(books: data)
            NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadDataNotification), object: nil)
        } else {
            ApiWebService.shared.getBooks()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { bookList in
                    if bookList.count > 0 {
                        PersistenceHelper.saveData(object: bookList, key: "Books")
                        self.listBook = Utilities.shared.importBookList(books: bookList)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadDataNotification), object: nil)
                    }
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
    }
    
    func getFavoritesBook(userId: String) {
        EpubReaderHelper.shared.favoritedBooks.removeAll()
        if let data = PersistenceHelper.loadData(key: "favoritedBook") as? [Book] {
            EpubReaderHelper.shared.favoritedBooks = Utilities.shared.importBookList(books: data)
            NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadFavoriteSuccessfullyNotification), object: nil)
        } else {
            ApiWebService.shared.getFavorites(userId: userId)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { bookList in
                    if bookList.count > 0 {
                        PersistenceHelper.saveData(object: bookList, key: "favoritedBook")
                        EpubReaderHelper.shared.favoritedBooks = Utilities.shared.importBookList(books: bookList)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadFavoriteSuccessfullyNotification), object: nil)
                    }
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
                    NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadFavoriteFailedNotification), object: nil)
                })
                .disposed(by: disposeBag)
        }
    }
    
    func getResultSearch(keySearch: String, completion: ((Bool) -> Void)? = nil) {
        self.resultSearch.removeAll()
        ApiWebService.shared.getResultSearch(keySearch: keySearch)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { bookList in
                if bookList.count > 0 {
                    self.resultSearch = Utilities.shared.importBookList(books: bookList)
                    completion?(true)
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
    
    func putToFavorites(book: Book, userId: String) {
        let parameters = ["bookId": book.id,
                          "userId": userId]
        AF.request(addFavoriteUrl, parameters: parameters).response { response in
            let success = response.response?.statusCode
            if success == 200 {
                print("Add success")
                EpubReaderHelper.shared.favoritedBooks.append(book)
                PersistenceHelper.saveData(object: EpubReaderHelper.shared.favoritedBooks, key: "favoritedBook")
                NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadFavoriteSuccessfullyNotification), object: nil)
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.AddFavoriteFailedNotification), object: nil)
            }
        }
    }
    
    func removeFavorite(bookId: String, userId: String) {
        let parameters = ["bookId": bookId,
                          "userId": userId]
        AF.request(removeFavotireUrl, parameters: parameters).response { response in
            let success = response.response?.statusCode
            if success == 200 {
                print("Remove success")
                EpubReaderHelper.shared.favoritedBooks.removeAll{ $0.id == bookId }
                PersistenceHelper.saveData(object: EpubReaderHelper.shared.favoritedBooks, key: "favoritedBook")
                NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadFavoriteSuccessfullyNotification), object: nil)
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.RemoveFavoriteFailedNotification), object: nil)
            }
        }
    }
}
