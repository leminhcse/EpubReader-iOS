//
//  BookViewModel.swift
//  EpubReader
//
//  Created by MacBook on 6/5/22.
//

import Foundation
import RxSwift

class BookViewModel: NSObject {
    
    var listBook = [Book]()
    var favoritesBook = [Book]()
    var resultSearch = [Book]()
    private let disposeBag = DisposeBag()
    
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
        self.favoritesBook.removeAll()
        if let data = PersistenceHelper.loadData(key: "favoritedBook") as? [Book] {
            self.favoritesBook = Utilities.shared.importBookList(books: data)
            NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadDataNotification), object: nil)
        } else {
            ApiWebService.shared.getFavorites(userId: userId)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { bookList in
                    if bookList.count > 0 {
                        PersistenceHelper.saveData(object: bookList, key: "favoritedBook")
                        self.favoritesBook = Utilities.shared.importBookList(books: bookList)
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
    
    func getResultSearch(keySearch: String) {
        self.resultSearch.removeAll()
        ApiWebService.shared.getResultSearch(keySearch: keySearch)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { bookList in
                if bookList.count > 0 {
                    self.resultSearch = Utilities.shared.importBookList(books: bookList)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ShowResultSearch), object: nil)
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
