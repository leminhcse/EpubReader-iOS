//
//  EpubReaderHelper.swift
//  EpubReader
//
//  Created by MacBook on 6/26/22.
//

import UIKit

class EpubReaderHelper: NSObject {

    static let shared = EpubReaderHelper()
    static let ReloadDataNotification = "ReloadDataNotification"
    static let ShowResultSearch = "ShowResultSearch"
    static let SignInSuccessfullyNotification = "SignInSuccessfullyNotification"
    static let SignInFailedNotification = "SignInFailedNotification"
    static let ReloadFavoriteSuccessfullyNotification = "ReloadFavoriteSuccessfullyNotification"
    static let ReloadFavoriteFailedNotification = "ReloadFavoriteFailedNotification"
    static let AddFavoriteSuccessNotification = "AddFavoriteSuccessNotification"
    static let RemoveFavoriteSuccessNotification = "RemoveFavoriteSuccessNotification"
    static let AddFavoriteFailedNotification = "AddFavoriteFailedNotification"
    static let RemoveFavoriteFailedNotification = "RemoveFavoriteFailedNotification"
    static let GetReadingBookSuccessNotification = "GetReadingBookSuccessNotification"
    static let GetReadingBookFailedNotification = "GetReadingBookFailedNotification"
    
    var user: User!
    var books = [Book]()
    var favoritedBooks = [Book]()
    var downloadBooks = [Book]()
    var readingBook = [ReadingBook]()
    var listAudio = [Audio]()
    var downloadAudio = [Audio]()
    
    private override init() {
        super.init()
        
        if let data = PersistenceHelper.loadUser(key: "User") as? User {
            self.user = data
        }
        
        if let data = PersistenceHelper.loadData(key: "favoritedBook") as? [Book] {
            favoritedBooks = Utilities.shared.importBookList(books: data)
        }
        
        if let data = PersistenceHelper.loadData(key: "downloadBook") as? [Book] {
            downloadBooks = Utilities.shared.importBookList(books: data)
        }
        
        if let data = PersistenceHelper.loadAudioData(key: "downloadAudio") as? [Audio] {
            downloadAudio = Utilities.shared.importAudioList(audioList: data)
        }
    }
}
