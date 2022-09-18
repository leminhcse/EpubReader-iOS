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
    
    private override init() {
        super.init()
    }
}
