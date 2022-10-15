//
//  User.swift
//  ART-VIPER
//
//  Created by Nguyen Minh Tam on 15/10/2022.
//

import UIKit
import RealmSwift

class User: Object {
    // MARK: - Properties
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String?
    @objc dynamic var gender: String?
    
    // MARK: - Class cycle
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
