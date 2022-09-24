//
//  AudioViewModel.swift
//  EpubReader
//
//  Created by mac on 30/08/2022.
//

import Foundation
import RxSwift

class AudioViewModel: NSObject {
    
    var listAudio = [Audio]()
    private let disposeBag = DisposeBag()
    
    override init() {
        super.init()
    }
    
    func getAudioList(bookId: String) {
        self.listAudio.removeAll()
        if let data = PersistenceHelper.loadAudioData(key: "Audios") as? [Audio] {
            self.listAudio = Utilities.shared.importAudioList(audioList: data)
            NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadDataNotification), object: nil)
        } else {
            ApiWebService.shared.getAudioList(bookId: bookId)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { audioList in
                    print("List of Audio ", audioList)
                    if audioList.count > 0 {
                        PersistenceHelper.saveAudioData(object: audioList, key: "Audios")
                        self.listAudio = Utilities.shared.importAudioList(audioList: audioList)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: EpubReaderHelper.ReloadDataNotification),
                                                        object: nil)
                    }
                }, onError: { error in
                    switch error {
                    case ApiError.conflict:
                        print("Conflict error")
                    case ApiError.forbidden:
                        print("Forbidden error")
                    case ApiError.notFound:
                        print("Not found error")
                    default:
                        print("Unknown error:", error)
                    }
                })
                .disposed(by: disposeBag)
        }
    }
}
