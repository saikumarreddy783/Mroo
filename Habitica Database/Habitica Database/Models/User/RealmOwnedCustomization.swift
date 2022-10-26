//
//  RealmOwnedCustomization.swift
//  Habitica Database
//
//  Created by Phillip Thelen on 23.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models
import RealmSwift

class RealmOwnedCustomization: Object, OwnedCustomizationProtocol {
    @objc dynamic var combinedKey: String?
    @objc dynamic var userID: String?
    @objc dynamic var key: String?
    @objc dynamic var type: String?
    @objc dynamic var group: String?
    @objc dynamic var isOwned: Bool = false
    
    override static func primaryKey() -> String {
        return "combinedKey"
    }
    
    convenience init(userID: String?, protocolObject: OwnedCustomizationProtocol) {
        self.init()
        self.userID = userID
        key = protocolObject.key
        type = protocolObject.type
        group = protocolObject.group
        combinedKey = "\(userID ?? "")\(key ?? "") + \(type ?? "") + \(group ?? "")"
        isOwned = protocolObject.isOwned
    }
}
