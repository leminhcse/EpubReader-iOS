//
//  UIImageExtension.swift
//  EpubReader
//
//  Created by MacBook on 6/26/22.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func kf_setImage(url: URL, completion: @escaping(Result<RetrieveImageResult, KingfisherError>) -> Void = { _ in }) {
        self.kf.cancelDownloadTask()
        self.kf.setImage(
            with: url,
            placeholder: nil,
            options: nil, completionHandler:  { result in
                completion(result)
        })
    }

}
