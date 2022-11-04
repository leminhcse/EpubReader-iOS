//
//  ApiRouter.swift
//  EpubReader
//
//  Created by MacBook on 6/22/22.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    
    //The endpoint name we'll call later
    case getUser(email: String, name: String)
    case getBooks
    case getAudioList(bookId: String)
    case getFavorites(userId: String)
    case getBookSearch(keySearch: String)
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        //Http method
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 60.0
        
        // Common Headers
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        
        if let parameters = parameters {
            do {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            } catch {
                print("Encoding fail")
            }
        }
        
        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpMethod
    //This returns the HttpMethod type. It's used to determine the type if several endpoints are peresent
    private var method: HTTPMethod {
        switch self {
        case .getBooks:
            return .get
        case .getAudioList:
            return .get
        case .getFavorites:
            return .get
        case .getBookSearch:
            return .get
        case .getUser:
            return .get
        }
    }
    
    //MARK: - Path
    //The path is the part following the base url
    private var path: String {
        switch self {
        case .getBooks:
            return "getbook.php"
        case .getAudioList:
            return "getAudioList.php"
        case .getFavorites:
            return "getFavorites.php"
        case .getBookSearch:
            return "getBookSearch.php"
        case .getUser:
            return "getUser.php"
        }
    }
    
    //MARK: - Parameters
    //This is the queries part, it's optional because an endpoint can be without parameters
    private var parameters: Parameters? {
        switch self {
        case .getBooks:
            return ["posts" : [Audio].self]
        case .getAudioList(let bookId):
            return [Constants.Parameters.bookId : bookId]
        case .getFavorites(let userId):
            return [Constants.Parameters.userId : userId]
        case .getBookSearch(let keySearch):
            return [Constants.Parameters.keySearch : keySearch]
        case .getUser(let email, let name):
            return [Constants.Parameters.email: email, Constants.Parameters.name: name]
        }
    }
}
