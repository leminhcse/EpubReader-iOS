//
//  ApiWebService.swift
//  EpubReader
//
//  Created by MacBook on 6/7/22.
//

import RxSwift
import Alamofire
import SwiftyJSON

class ApiWebService {

    static let shared = ApiWebService()
    
    func getUser(email: String, name: String) -> Observable<[User]> {
        return request(ApiRouter.getUser(email: email, name: name))
    }
    
    func getBooks() -> Observable<[Book]> {
        return request(ApiRouter.getBooks)
    }
    
    func getAudioList(bookId: String) -> Observable<[Audio]> {
        return request(ApiRouter.getAudioList(bookId: bookId))
    }
    
    func getFavorites(userId: String) -> Observable<[Book]> {
        return request(ApiRouter.getFavorites(userId: userId))
    }
    
    func getResultSearch(keySearch: String) -> Observable<[Book]> {
        return request(ApiRouter.getBookSearch(keySearch: keySearch))
    }
    
    func downloadFile(url: URL, completion: ((Bool) -> Void)? = nil) {
        let fileName = url.lastPathComponent
        
        let destination: DownloadRequest.Destination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            documentsURL.appendPathComponent(fileName)
            return (documentsURL, [.removePreviousFile])
        }
        
        AF.download(url, to: destination).response { response in
            print(response)
            completion!(true)
        }
    }
    
    func downloadAudio(audio: Audio, url: URL) -> Observable<Float> {
        let downloadInfo = self.genericDownload(audio: audio, url: url, completion: { success in
            print("success")
        })
        return downloadInfo.downloadObs
    }
    
    func genericDownload(audio: Audio, url: URL, completion: ((Bool) -> Void)? = nil) -> FileDownloadInfo {
        let fileName = url.lastPathComponent
        let filePathComponent = FileHelper.shared.getFileDownloadPathComponent(fileName: fileName)
        let destination: DownloadRequest.Destination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

            documentsURL.appendPathComponent(fileName)
            return (documentsURL, [.removePreviousFile])
        }
        
        let downloadInfo = FileDownloadInfo()
        AF.download(url, to: destination)
            .downloadProgress { progress in
                print("downloadProgress \(progress.fractionCompleted)")
                downloadInfo.progress = Float(progress.fractionCompleted)
                downloadInfo.downloadObs.onNext(Float(progress.fractionCompleted))
            }
            .response { response in
                print(response)
                DatabaseHelper.savePath(id: audio.id, localPathComponent: filePathComponent.string)
                completion?(true)
                downloadInfo.downloadObs.onCompleted()
            }
        return downloadInfo
    }
    
    //MARK: - The request function to get results in an Observable
    private func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        //Create an RxSwift observable, which will be the one to call the request when subscribed to
        return Observable<T>.create { observer in
            //Trigger the HttpRequest using AlamoFire (AF)
            // let request = AF.request(urlConvertible).responseJSONDecodable { (response: DataResponse<T>) in
            let request = AF.request(urlConvertible).responseDecodable { (response: DataResponse<T, AFError>) in
                //Check the result from Alamofire's response and check if it's a success or a failure
                switch response.result {
                case .success(let value):
                    //Everything is fine, return the value in onNext
                    if let data = response.data {
                        let myjson = JSON(data)
                        for i in 0..<myjson.count {
                            let composer = myjson[i]["composer"].stringValue
                            print("my composer with  = \(composer)\n")
                        }
                    }
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    //Something went wrong, switch on the status code and return the error
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 409:
                        observer.onError(ApiError.conflict)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            
            //Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
