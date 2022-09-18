//
//  Book.swift
//  EpubReader
//
//  Created by MacBook on 6/5/22.
//

import UIKit

struct Book: Codable {
    let id: String
    let title: String
    let composer: String
    let description: String
    let thumbnail: String
    let year: String
    let type: String
    let epub_source: String
}
