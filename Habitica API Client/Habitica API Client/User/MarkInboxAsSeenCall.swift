//
//  MarkInboxAsSeenCall.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 26.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models
import ReactiveSwift

public class MarkInboxAsSeenCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init() {
        super.init(httpMethod: .POST, endpoint: "user/mark-pms-read")
    }
}
