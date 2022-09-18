//
//  ItemDownloadHelper.swift
//  EpubReader
//
//  Created by mac on 24/07/2022.
//

import RxSwift

final class ItemDownloadHelper: NSObject {
    
    func getDownloadString(urlString: String) -> String {
        var downloadString = urlString
        if urlString.contains("http") {
            return downloadString
        }
        return downloadString
    }
}
