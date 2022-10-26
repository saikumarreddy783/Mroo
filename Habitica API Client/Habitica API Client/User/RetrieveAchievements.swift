//
//  RetrieveAchievements.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 11.07.19.
//  Copyright © 2019 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models
import ReactiveSwift

public class RetrieveAchievementsCall: ResponseObjectCall<AchievementListProtocol, APIAchievementList> {
    public init(userID: String) {
        super.init(httpMethod: .GET, endpoint: "members/\(userID)/achievements")
    }
}
