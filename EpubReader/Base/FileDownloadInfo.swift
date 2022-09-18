//
//  FileDownloadInfo.swift
//  EpubReader
//
//  Created by mac on 24/07/2022.
//

import UIKit
import RxSwift

class FileDownloadInfo: NSObject {
    public typealias ProgessViewUpdate = (_ to: Float) -> Void
    // Observables
    var downloadObs = BehaviorSubject<Float>(value: 0)
    var isDownloadCompleted = false
    var progress: Float = 0.0
        
    var downloadRequest: DownloadTask?
}
