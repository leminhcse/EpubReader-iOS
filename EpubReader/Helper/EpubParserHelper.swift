//
//  EpubParserHelper.swift
//  EpubReader
//
//  Created by mac on 24/07/2023.
//

import UIKit
import Foundation

class EpubParserHelper: NSObject {

    var url: URL
    var totalPages: Int = 0

    init(url: URL) {
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EpubParserHelper: XMLParserDelegate {
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes: [String: String]) {
        if elementName == "spine" {
            for attribute in attributes {
                if attribute.key == "totalPages" {
                    totalPages = Int(attribute.value) ?? 0
                }
            }
        }
    }
}
