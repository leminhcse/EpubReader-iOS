//
//  PersistenceHelper.swift
//  EpubReader
//
//  Created by mac on 08/09/2022.
//

import UIKit

final class PersistenceHelper: NSObject {

    class private func documentsDirectory() -> NSString {
        return FileHelper.shared.documentsDirectory.path as NSString
    }
    
//    class func saveData(object: AnyObject, key: String) {
//        let file = documentsDirectory().appendingPathComponent(key)
//        NSKeyedArchiver.archiveRootObject(object, toFile: file)
//    }
    
    class func saveData(object: AnyObject, key: String) {
        //UserDefaults.standard.set(object, forKey: key)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Couldn't write file")
        }
    }
    
    class func loadData(key: String) -> AnyObject? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        guard let mydata = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)) as? AnyObject else {
            return nil
        }
        return mydata
//        let file = documentsDirectory().appendingPathComponent(key)
//        let result = NSKeyedUnarchiver.unarchiveObject(withFile: file)
//        return result as AnyObject?
    }
}
