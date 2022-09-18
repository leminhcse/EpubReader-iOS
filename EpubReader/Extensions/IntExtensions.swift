//
//  IntExtensions.swift
//  EpubReader
//
//  Created by mac on 20/08/2022.
//

import UIKit

extension Int {
    
    func durationFormatted() -> String {
        if self >= 3600 {
            let hours:Int = (self / 3600)
            let minutes:Int = (self % 3600) / 60
            let rseconds: Int = (self % 3600) % 60
            if hours > 0 {
                return String(format: "%i:%02i:%02i", hours, minutes, rseconds)
            } else {
                return String(format: "%02i:%02i", minutes, rseconds)
            }
        } else if self >= 60 {
            let minutes:Int = self / 60
            let rseconds: Int = (self % 60) % 60
            return NSString(format: "%i:%02d",minutes,rseconds) as String
        } else {
            return NSString(format: "0:%02d", self) as String
        }
    }
}
