//
//  RetrieveGroupsCall.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 02.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models
import ReactiveSwift

public class RetrieveGroupsCall: ResponseArrayCall<GroupProtocol, APIGroup> {
    public init(_ groupType: String) {
        super.init(httpMethod: .GET, endpoint: "groups/?type=\(groupType)")
    }
}
