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
    
    func noConnectionAlert() {
        guard self.isNoInternetDisplaying == false else {
            print("No Internet Connection is showing")
            return
        }
        
        DispatchQueue.main.async {
        
            if let topController = UIApplication.topViewController() {
                if let navigationController = topController.navigationController {
                    let errorMessage = Reachability.shared.connectivity.status.errorMessage
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
