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
    
    class func saveData(object: [Book], key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    class func loadData(key: String) -> AnyObject? {
        do {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return nil
            }
            let books = try JSONDecoder().decode([Book].self, from: data)
            return books as AnyObject
        } catch {
            print(error)
            return nil
        }
    }
    
    class func saveAudioData(object: [Audio], key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    class func loadAudioData(key: String) -> AnyObject? {
        do {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return nil
            }
            let books = try JSONDecoder().decode([Audio].self, from: data)
            return books as AnyObject
        } catch {
            print(error)
            return nil
        }
    }
    
    class func saveUser(object: User, key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    class func loadUser(key: String) -> AnyObject? {
        do {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return nil
            }
            let user = try JSONDecoder().decode(User.self, from: data)
            return user as AnyObject
        } catch {
            print(error)
            return nil
        }
    }
}
