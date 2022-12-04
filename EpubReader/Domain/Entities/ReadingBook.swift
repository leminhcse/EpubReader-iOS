//
//  ReadingBook.swift
//  EpubReader
//
//  Created by mac on 04/12/2022.
//

import UIKit

class ReadingBook: NSObject, Codable {
    var book: Book? = nil
    var currentPage: Int = 0
}
