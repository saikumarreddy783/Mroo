//
//  APILocalAuthentication.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 09.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models

class APILocalAuthentication: LocalAuthenticationProtocol, Decodable {
    var email: String?
    var username: String?
    var lowerCaseUsername: String?
    var hasPassword: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case email
        case username
        case lowerCaseUsername
        case hasPassword = "has_password"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try? values.decode(String.self, forKey: .email)
        username = try? values.decode(String.self, forKey: .username)
        lowerCaseUsername = try? values.decode(String.self, forKey: .lowerCaseUsername)
        hasPassword = (try? values.decode(Bool.self, forKey: .hasPassword)) ?? false
    }
}
