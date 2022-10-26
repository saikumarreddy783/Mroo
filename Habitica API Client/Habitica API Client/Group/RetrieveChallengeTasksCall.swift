//
//  RetrieveChallengeTasksCall.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 12.06.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models
import ReactiveSwift

public class RetrieveChallengeTasksCall: ResponseArrayCall<TaskProtocol, APITask> {
    public init(challengeID: String) {
        super.init(httpMethod: .GET, endpoint: "tasks/challenge/\(challengeID)")
    }
}
