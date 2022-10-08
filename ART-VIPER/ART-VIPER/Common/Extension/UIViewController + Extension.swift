//
//  UIViewController + Extension.swift
//  ART-VIPER
//
//  Created by Nguyen Minh Tam on 06/10/2022.
//

import UIKit
import RxSwift

extension UIViewController {
  func alert(title: String, text: String?) -> Completable {
    return Completable.create { [weak self] completable in
      let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "Close", style: .default, handler: {_ in
        completable(.completed)
      }))
      self?.present(alertVC, animated: true, completion: nil)
      return Disposables.create {
        //self?.dismiss(animated: true, completion: nil)
      }
    }
  }
}
