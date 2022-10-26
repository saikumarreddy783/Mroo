//
//  APIAuthenticationTimestamps.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 09.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models

class APIAuthenticationTimestamps: AuthenticationTimestampsProtocol, Decodable {
    var createdAt: Date?
    var loggedIn: Date?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created"
        case loggedIn = "loggedin"
    }
}
