//
//  RetrieveUser.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 07.03.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models
import ReactiveSwift

public class RetrieveUserCall: ResponseObjectCall<UserProtocol, APIUser> {
    public init() {
        super.init(httpMethod: .GET, endpoint: "user")
    }
}
