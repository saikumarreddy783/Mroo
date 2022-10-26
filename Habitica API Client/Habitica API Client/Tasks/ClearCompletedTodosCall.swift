//
//  ClearCompletedTodosCall.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 21.05.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models
import ReactiveSwift

public class ClearCompletedTodosCall: ResponseArrayCall<TaskProtocol, APITask> {
    public init() {
        super.init(httpMethod: .GET, endpoint: "tasks/clear-completed")
    }
}
