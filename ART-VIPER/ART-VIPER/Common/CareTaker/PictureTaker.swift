//
//  PictureTaker.swift
//  ART-VIPER
//
//  Created by Nguyen Minh Tam on 30/09/2022.
//

import UIKit
import RxSwift
import Photos

public struct PictureTaker {
    
    public static func save(_ image: UIImage) -> Observable<String> {
        return Observable.create { observer in
            var savedAssetId: String?
            PHPhotoLibrary.shared().performChanges {
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                savedAssetId = request.placeholderForCreatedAsset?.localIdentifier
            } completionHandler: { success, error in
                DispatchQueue.main.async {
                    if success, let id = savedAssetId {
                        observer.onNext(id)
                        observer.onCompleted()
                    } else {
                        observer.onError(error ?? Error.couldNotSavePhoto)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    public enum Error: String, Swift.Error {
        case couldNotSavePhoto
      }
    
}
