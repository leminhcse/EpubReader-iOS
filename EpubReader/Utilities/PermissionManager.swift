//
//  PermissionManager.swift
//  EpubReader
//
//  Created by mac on 15/12/2022.
//

import Foundation
import FBSDKCoreKit
import AppTrackingTransparency

final class PermissionManager {

    static let shared = PermissionManager()
    
    func checkAndRequestPermission() {
        if (UIApplication.shared.applicationState != UIApplication.State.active) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.checkAndRequestPermission()
            }
        } else {
            requestTrackingPermission()
        }
    }
    
    func requestTrackingPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    Settings.shared.isAdvertiserTrackingEnabled = true
                    LocalNetworkPrivacy.shared.triggerLocalNetworkPrivacyAlert()
                default:
                    Settings.shared.isAdvertiserTrackingEnabled = false
                    LocalNetworkPrivacy.shared.triggerLocalNetworkPrivacyAlert()
                }
            }
        }
    }
}
