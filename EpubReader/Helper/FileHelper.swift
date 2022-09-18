//
//  FileHelper.swift
//  EpubReader
//
//  Created by mac on 24/07/2022.
//

import UIKit
import Foundation

class FileHelper {
    static let shared = FileHelper()
    var documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                      in: .userDomainMask)[0]
    
    func getFilePath(pathComponent: PathComponent) -> URL {
        return self.documentsDirectory.appendingPathComponent(pathComponent.string,
                                                              isDirectory: pathComponent.isDirectory)
    }
    
    func getFileDownloadPathComponent(fileName: String) -> PathComponent {
        return PathComponent(fileName)
    }

}

struct PathComponent {
    let string: String
    let isDirectory: Bool
    init(_ string: String, isDirectory: Bool = false) {
        self.string = string
        self.isDirectory = isDirectory
    }
    
    func appendingPathComponent(_ pathComponent: String, isDirectory: Bool = false) -> PathComponent {
        return PathComponent(self.string + "/" + pathComponent, isDirectory: isDirectory)
    }
    
    @inlinable public static func + (lhs: PathComponent, rhs: PathComponent) -> PathComponent {
        return PathComponent(lhs.string + "/" + rhs.string, isDirectory: rhs.isDirectory)
    }
}
