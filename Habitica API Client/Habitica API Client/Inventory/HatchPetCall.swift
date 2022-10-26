//
//  HatchPetCall.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 13.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models
import ReactiveSwift

public class HatchPetCall: ResponseObjectCall<UserItemsProtocol, APIUserItems> {
    public init(egg: String, potion: String) {
        super.init(httpMethod: .POST, endpoint: "user/hatch/\(egg)/\(potion)", postData: nil)
    }
}
