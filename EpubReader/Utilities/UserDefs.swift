//
//  UserDefs.swift
//  EpubReader
//
//  Created by mac on 19/11/2022.
//

import Foundation

class UserDefs {
    
    // User Setting for my profile
    public class var userSetting: [String: Any] {
        get {
            return UserDefaults.standard.dictionary(forKey: "userSetting") ?? [String: Any]()
        } set {
            UserDefaults.standard.set(newValue, forKey: "userSetting")
        }
    }
    
    // Flag for determine that app should show auto up next screen when video completed
    public class var isAutoPlay: Bool {
        get {
            if let autoPlay = userSetting["isAutoPlay"] as? Bool {
                return autoPlay
            }
            return false
        } set {
            userSetting["isAutoPlay"] = newValue
        }
    }
    
    // Flag for determine that app should continue audio In background
    public class var continueAudioInBackground: Bool {
        get {
            if let continueAudioInBackground = userSetting["continueAudioInBackground"] as? Bool {
                return continueAudioInBackground
            }
            return true
        } set {
            userSetting["continueAudioInBackground"] = newValue
        }
    }
    
    // Flag for determine that app allow audio from another apps
    public class var allowBackgroundAudio: Bool {
        get {
            if let allowBackgroundAudio = userSetting["allowBackgroundAudio"] as? Bool {
                return allowBackgroundAudio
            }
            return false
        } set {
            userSetting["allowBackgroundAudio"] = newValue
        }
    }
    
    // Flag for downloading only by wifi
    public class var isDownloadViaWifi: Bool {
        get {
            if let downloadViaWifi = userSetting["isDownloadViaWifi"] as? Bool {
                return downloadViaWifi
            }
            return true
        } set {
            userSetting["isDownloadViaWifi"] = newValue
        }
    }
    
    // Flag for dark mode
    public class var isDarkMode: Bool {
        get {
            if let isDarkMode = userSetting["isDarkMode"] as? Bool {
                return isDarkMode
            }
            return true
        } set {
            userSetting["isDarkMode"] = newValue
        }
    }
}
