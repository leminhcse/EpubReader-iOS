//
//  RlmDownloadedAudioPath.swift
//  EpubReader
//
//  Created by mac on 06/09/2022.
//

import RealmSwift

final class RlmDownloadedAudioPath: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var localPathComponent: String = ""

    convenience init(id: String, localPathComponent: String) {
        self.init()
        self.id = id
        self.localPathComponent = localPathComponent
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
