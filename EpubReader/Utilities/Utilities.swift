//
//  Utilities.swift
//  EpubReader
//
//  Created by MacBook on 6/26/22.
//

import UIKit
import Whisper
import FBSDKLoginKit

class Utilities: NSObject {
    
    static let shared = Utilities()
    
    var isNoInternetDisplaying = false

    private override init() {
        super.init()
    }
    
    func importBookList(books: [Book]) -> [Book] {
        var listBook = [Book]()
        for item in books {
            listBook.append(Book(id: item.id,
                                 title: item.title,
                                 composer: item.composer,
                                 description: item.description,
                                 thumbnail: item.thumbnail,
                                 year: item.year,
                                 type: item.type,
                                 epub_source: item.epub_source))
        }
        return listBook
    }
    
    func importAudioList(audioList: [Audio]) -> [Audio] {
        var listAudio = [Audio]()
        for item in audioList {
            listAudio.append(Audio(id: item.id,
                                   title: item.title,
                                   fileAudio: item.fileAudio,
                                   book_id: item.book_id))
        }
        return listAudio
    }
    
    func getCloudFileUrl(fileName: String) -> String {
        if !fileName.contains("http") {
            return fileName
        }
        return fileName
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getDocumentFilePath(fileName: String) -> URL {
        let documentPath = getDocumentsDirectory()
        let filePath = documentPath.appendingPathComponent(fileName)
        
        return filePath
    }
    
    func getFileExist(fileName: String) -> String {
        let filePath = getDocumentFilePath(fileName: fileName)
        let fileManger = FileManager.default
        
        if fileManger.fileExists(atPath: filePath.path) {
            print("FILE: \(fileName) is AVAILABLE")
            return filePath.path
        } else {
            print("FILE: \(fileName) NOT AVAILABLE")
            return ""
        }
    }
    
    func delete(fileName : String) -> Bool {
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filePath = docDir.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(atPath: filePath.absoluteString)
            print("File deleted")
            return true
        } catch {
            print("Error")
        }
        return false
    }
    
    func deteleAllDownloads() {
        if EpubReaderHelper.shared.downloadBooks.count > 0 {
            for book in EpubReaderHelper.shared.downloadBooks {
                if let bookUrl = URL(string: book.epub_source) {
                    let fileName = bookUrl.lastPathComponent
                    let path: String = Utilities.shared.getFileExist(fileName: fileName)
                    if path != "" {
                        try? FileManager.default.removeItem(atPath: path)
                        EpubReaderHelper.shared.downloadBooks.removeAll(where: { $0.id == book.id})
                        PersistenceHelper.saveData(object: EpubReaderHelper.shared.downloadBooks, key: "downloadBook")
                    }
                }
            }
        }
        if EpubReaderHelper.shared.downloadAudio.count > 0 {
            for audio in EpubReaderHelper.shared.downloadAudio {
                if let itemPath = DatabaseHelper.getFilePath(id: audio.id), FileManager.default.fileExists(atPath: itemPath) {
                    try? FileManager.default.removeItem(atPath: itemPath)
                    EpubReaderHelper.shared.downloadAudio.removeAll(where: {$0.id == audio.id})
                    PersistenceHelper.saveAudioData(object: EpubReaderHelper.shared.downloadAudio, key: "downloadAudio")
                }
            }
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.RemoveBookSuccessNotification), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.RemoveAudioSuccessNotification), object: nil)
    }
    
    func noConnectionAlert() {
        guard self.isNoInternetDisplaying == false else {
            print("No Internet Connection is showing")
            return
        }
        
        DispatchQueue.main.async {
            if let topController = UIApplication.topViewController() {
                if let navigationController = topController.navigationController {
                    _ = Reachability.shared.connectivity.status.errorMessage
                    //let message = Message(title: errorMessage, backgroundColor: UIColor.lightGray.withAlphaComponent(0.9))
                    
                    self.isNoInternetDisplaying = true
                    //Whisper.show(whisper: message, to: navigationController, action: .present)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                        hide(whisperFrom: navigationController, after: 0)
                        self.isNoInternetDisplaying = false
                    })
                }
                else {
                    let banner = BannerNotification.noInternetConnection.banner
                    banner.didDismissBlock = { () -> Void in
                        self.isNoInternetDisplaying = false
                    }
                    self.isNoInternetDisplaying = true
                    banner.show(duration: 5.0)
                }
            }
        }
    }
    
    func showAlertDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    func showLoginDialog() {
        let alert = UIAlertController(title: "Yêu cầu Đăng Nhập",
                                      message: "Bạn phải đăng nhập để có thể sử dụng tính năng này.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Đồng ý", style: .default) { action in
            let viewController = SignInViewController()
            viewController.modalPresentationStyle = .overCurrentContext
            if let topController = UIApplication.topViewController() {
                DispatchQueue.main.async {
                    topController.present(viewController, animated: true, completion: nil)
                }
            }
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Hủy bỏ", style: .cancel)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    func showMoreOptions(book: Book) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if #available(iOS 13.0, *) {
            alert.view.tintColor = UIColor.primaryTextColor(traitCollection: UITraitCollection.current)
        } else {
            alert.view.tintColor = UIColor.color(with: .primaryItem)
        }
        alert.popoverPresentationController?.permittedArrowDirections = []

        if Utilities.shared.isFavorited(bookId: book.id) {
            let favouritesAction = UIAlertAction(title: "Xóa khỏi Yêu thích", style: .default) { action in
                if EpubReaderHelper.shared.user == nil {
                    Utilities.shared.showLoginDialog()
                    return
                }
                let bookViewModel = BookViewModel()
                bookViewModel.removeFavorite(bookId: book.id, userId: EpubReaderHelper.shared.user.id) { success in
                    BannerNotification.removedFromFavourites.present()
                }
            }
            alert.addAction(favouritesAction)
        } else {
            let favouritesAction = UIAlertAction(title: "Thêm vào Yêu thích", style: .default) { action in
                if EpubReaderHelper.shared.user == nil {
                    Utilities.shared.showLoginDialog()
                    return
                }
                let bookViewModel = BookViewModel()
                bookViewModel.putToFavorites(book: book, userId: EpubReaderHelper.shared.user.id) { success in
                    BannerNotification.addedToFavourites.present()
                }
            }
            alert.addAction(favouritesAction)
        }
    
        if let bookUrl = URL(string: book.epub_source) {
            let fileName = bookUrl.lastPathComponent
            let path: String = Utilities.shared.getFileExist(fileName: fileName)
            if path != "" {
                let downloadAction = UIAlertAction(title: "Xóa sách", style: .default) { action in
                    try? FileManager.default.removeItem(atPath: path)
                    DispatchQueue.main.async {
                        BannerNotification.downloadDeleted(title: book.title).present()
                        EpubReaderHelper.shared.downloadBooks.removeAll(where: { $0.id == book.id})
                        PersistenceHelper.saveData(object: EpubReaderHelper.shared.downloadBooks, key: "downloadBook")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.RemoveBookSuccessNotification), object: nil)
                    }
                }
                alert.addAction(downloadAction)
            } else {
                let downloadAction = UIAlertAction(title: "Tải sách", style: .default) { action in
                    if !Reachability.shared.isConnectedToNetwork {
                        Utilities.shared.noConnectionAlert()
                        return
                    }
                    if !book.epub_source.contains("http") {
                        Utilities.shared.showAlertDialog(title: "", message: "Không thể tải, đã xảy ra lỗi!")
                    } else {
                        ApiWebService.shared.downloadFile(url: bookUrl) { success in
                            print("download")
                            if success {
                                DispatchQueue.main.async {
                                    BannerNotification.downloadSuccessful(title: book.title).present()
                                    EpubReaderHelper.shared.downloadBooks.append(book)
                                    PersistenceHelper.saveData(object: EpubReaderHelper.shared.downloadBooks, key: "downloadBook")
                                }
                            } else {
                                DispatchQueue.main.async {
                                    Utilities.shared.showAlertDialog(title: "", message: "Download không thành công, vui lòng kiểm tra kết nối internet!")
                                }
                            }
                        }
                    }
                }
                alert.addAction(downloadAction)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func openAudioPlayer(audio: Audio, thumbnail: String) {
        AudioPlayer.shared.sound = nil
        AudioPlayer.shared.play(audio: audio, thumbnail: thumbnail)
        AudioPlayer.shared.isPaused = false
    }
    
    func showFullScreenAudio() {
        let viewController = FullScreenAudioPlayerViewController()
        let device = UIDevice.current
        if device.userInterfaceIdiom == .phone {
            let value = NSNumber(value: UIInterfaceOrientation.portrait.rawValue)
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
        if let topController = UIApplication.topViewController() {
            DispatchQueue.main.async {
                topController.present(viewController, animated: true, completion: nil)
            }
        }
    }

    func isFacebookSignedIn() -> Bool {
        let accessToken = AccessToken.current
        let isLoggedIn = accessToken != nil && !(accessToken?.isExpired ?? false)
        return isLoggedIn
    }
    
    func isFavorited(bookId: String) -> Bool {
        for item in EpubReaderHelper.shared.favoritedBooks {
            if item.id == bookId {
                return true
            }
        }
        return false
    }
}
