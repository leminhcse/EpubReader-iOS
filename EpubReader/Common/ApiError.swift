//
//  ApiError.swift
//  EpubReader
//
//  Created by MacBook on 6/22/22.
//

import UIKit

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}
