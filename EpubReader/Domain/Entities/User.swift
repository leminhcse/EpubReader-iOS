//
//  User.swift
//  EpubReader
//
//  Created by mac on 29/09/2022.
//

import UIKit

class User: NSObject, Codable {
    var id: String = ""
    var email: String = ""
    var name: String = ""
    var avatar: String = ""
    var type: String = "0"
    var access_token: String = ""
    var isPurchased: String = "0"
}
