//
//  RealmOutfit.swift
//  Habitica Database
//
//  Created by Phillip Thelen on 09.03.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models
import RealmSwift

class RealmOutfit: Object, OutfitProtocol {
    @objc dynamic var back: String?
    @objc dynamic var body: String?
    @objc dynamic var armor: String?
    @objc dynamic var eyewear: String?
    @objc dynamic var headAccessory: String?
    @objc dynamic var head: String?
    @objc dynamic var weapon: String?
    @objc dynamic var shield: String?
    
    @objc dynamic var id: String?
    override static func primaryKey() -> String {
        return "id"
    }
    
    convenience init(id: String?, type: String, outfit: OutfitProtocol) {
        self.init()
        self.id = (id ?? "")+type
        back = outfit.back
        body = outfit.body
        armor = outfit.armor
        eyewear = outfit.eyewear
        headAccessory = outfit.headAccessory
        head = outfit.head
        weapon = outfit.weapon
        shield = outfit.shield
    }
}
