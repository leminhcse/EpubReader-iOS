//
//  NetworkManager.swift
//  EpubReader
//
//  Created by mac on 24/07/2022.
//

import UIKit

protocol DownloadTask {
    func cancelTask()
    func cancelTask(createResumeData: Bool, resumeData: (Data?) -> Void)
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
}
