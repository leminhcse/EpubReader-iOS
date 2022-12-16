//
//  Constants.swift
//  EpubReader
//
//  Created by MacBook on 6/22/22.
//

struct Constants {

    //The API's base URL
    static let baseUrl = "https://minhdev2006.com/PHP_API"
    //"http://minhhdmbp152019/PHP_API"
    //"http://minhhdmbp152019/PHP_API/getbook.php"
    //"http://192.168.64.2/PHP_API/getbook.php"
    
    //The parameters (Queries) that we're gonna use
    struct Parameters {
        static let bookId = "bookId"
        static let userId = "userId"
        static let keySearch = "keySearch"
        static let email = "email"
        static let name = "name"
    }
    
    //The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    //The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
    }
    
    enum RemoteControlType : String {
        case remoteControlPreviousTrack = "remoteControlPreviousTrack"
        case remoteControlNextTrack = "remoteControlNextTrack"
    }
    
    enum audioViewType: String {
        case fullScreen = "fullScreen"
        case minimized = "minimized"
    }
    
    enum StatusDownloadAudio: Int {
        case inProgress = 1
        case finish = 2
        case notDownloaded = 3
    }
}
