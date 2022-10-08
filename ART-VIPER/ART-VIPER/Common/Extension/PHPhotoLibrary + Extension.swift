//
//  PHPhotoLibrary + Extension.swift
//  ART-VIPER
//
//  Created by Nguyen Minh Tam on 06/10/2022.
//

import Foundation
import Photos
import RxSwift

extension PHPhotoLibrary {
  static var authorized: Observable<Bool> {
    return Observable.create { observer in
        DispatchQueue.main.async {
            if authorizationStatus() == .authorized {
                observer.onNext(true)
                observer.onCompleted()
            } else {
                observer.onNext(false)
                requestAuthorization(for: PHAccessLevel.readWrite) { newStatus in
                    observer.onNext(newStatus == .authorized)
                    observer.onCompleted()
                }
            }
        }
      return Disposables.create()
    }
  }
    
}
