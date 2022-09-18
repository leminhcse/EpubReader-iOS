//
//  DatabaseHelper.swift
//  EpubReader
//
//  Created by mac on 06/09/2022.
//

import RealmSwift

final class DatabaseHelper {

    private static let databaseName = "book_data.realm"
    private static let userDataRealmUrl = Realm.Configuration.defaultConfiguration.fileURL!.deletingLastPathComponent().appendingPathComponent(databaseName)
    
    private static var realm: Realm {
        return try! Realm.init(fileURL: userDataRealmUrl)
    }
    
    class func savePath(id: String, localPathComponent: String) {
        let itemPath = RlmDownloadedAudioPath(id: id, localPathComponent: localPathComponent)
        try! realm.write {
            realm.add(itemPath, update: .all)
        }
    }
    
    class func getFilePath(id: String) -> String? {
        let localPathComponent: String? = realm.object(ofType: RlmDownloadedAudioPath.self, forPrimaryKey: id)?.localPathComponent
        if let localPathComponent = localPathComponent {
            return FileHelper.shared.getFilePath(pathComponent: PathComponent(localPathComponent)).path
        }
        return nil
    }
}
