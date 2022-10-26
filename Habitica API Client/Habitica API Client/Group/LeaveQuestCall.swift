//
//  LeaveQuestCall.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 26.03.21.
//  Copyright © 2021 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models
import ReactiveSwift

public class LeaveQuestCall: ResponseObjectCall<EmptyResponseProtocol, APIEmptyResponse> {
    public init(groupID: String) {

        super.init(httpMethod: .POST, endpoint: "groups/\(groupID)/quest/leave", postData: nil)
    }
}
