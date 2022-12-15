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
    
    func getBookList(completion: ((Bool) -> Void)? = nil) {
        self.listBook.removeAll()
        if let data = PersistenceHelper.loadData(key: "Books") as? [Book] {
            self.listBook = Utilities.shared.importBookList(books: data)
            EpubReaderHelper.shared.books = self.listBook
            NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadDataNotification), object: nil)
            completion?(true)
        } else {
            ApiWebService.shared.getBooks()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { bookList in
                    if bookList.count > 0 {
                        PersistenceHelper.saveData(object: bookList, key: "Books")
                        self.listBook = Utilities.shared.importBookList(books: bookList)
                        EpubReaderHelper.shared.books = self.listBook
                        NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadDataNotification), object: nil)
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
                        completion?(false)
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
    
    func putToFavorites(book: Book, userId: String, completion: ((Bool) -> Void)? = nil) {
        if !Reachability.shared.isConnectedToNetwork {
            Utilities.shared.noConnectionAlert()
            completion?(false)
            return
        }
        
        EpubReaderHelper.shared.favoritedBooks.append(book)
        let parameters = ["bookId": book.id,
                          "userId": userId]
        AF.request(addFavoriteUrl, parameters: parameters).response { response in
            let success = response.response?.statusCode
            if success == 200 {
                print("Add success")
                PersistenceHelper.saveData(object: EpubReaderHelper.shared.favoritedBooks, key: "favoritedBook")
                NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadFavoriteSuccessfullyNotification), object: nil)
                completion?(true)
            } else {
                if Utilities.shared.isFavorited(bookId: book.id) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadFavoriteSuccessfullyNotification), object: nil)
                    completion?(true)
                } else {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.AddFavoriteFailedNotification), object: nil)
                    completion?(false)
                }
            }
        }
    }
    
    func removeFavorite(bookId: String, userId: String, completion: ((Bool) -> Void)? = nil) {
        if !Reachability.shared.isConnectedToNetwork {
            Utilities.shared.noConnectionAlert()
            completion?(false)
            return
        }
        
        EpubReaderHelper.shared.favoritedBooks.removeAll{ $0.id == bookId }
        let parameters = ["bookId": bookId,
                          "userId": userId]
        AF.request(removeFavotireUrl, parameters: parameters).response { response in
            let success = response.response?.statusCode
            if success == 200 {
                print("Remove success")
                EpubReaderHelper.shared.favoritedBooks.removeAll{ $0.id == bookId }
                PersistenceHelper.saveData(object: EpubReaderHelper.shared.favoritedBooks, key: "favoritedBook")
                NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadFavoriteSuccessfullyNotification), object: nil)
                completion?(true)
            } else {
                if !Utilities.shared.isFavorited(bookId: bookId) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadFavoriteSuccessfullyNotification), object: nil)
                    completion?(true)
                } else {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.RemoveFavoriteFailedNotification), object: nil)
                    completion?(false)
                }
            }
        }
    }
    
    func getReadingBook() {
        if EpubReaderHelper.shared.readingBook.count > 0 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.GetReadingBookSuccessNotification), object: nil)
        } else if let data = PersistenceHelper.loadReadingBook(key: "readingBook") as? [ReadingBook] {
            EpubReaderHelper.shared.readingBook = data
            NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.GetReadingBookSuccessNotification), object: nil)
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.GetReadingBookFailedNotification), object: nil)
        }
    }
    
    func putToReading(book: Book, currentPage: Int) {
        let readingBook = ReadingBook()
        readingBook.book = book
        readingBook.currentPage = currentPage
        
        if EpubReaderHelper.shared.readingBook.contains(where: {$0.book?.id == book.id}) {
            EpubReaderHelper.shared.readingBook.removeAll(where: {$0.book?.id == book.id })
            EpubReaderHelper.shared.readingBook.append(readingBook)
        } else {
            EpubReaderHelper.shared.readingBook.append(readingBook)
        }
        PersistenceHelper.saveReadingBook(object: EpubReaderHelper.shared.readingBook, key: "readingBook")
        NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.GetReadingBookSuccessNotification), object: nil)
    }
}
