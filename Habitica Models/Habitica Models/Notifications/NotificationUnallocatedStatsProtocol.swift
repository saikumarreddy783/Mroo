//
//  HabiticaNotificationUnallocatedStatsProtocol.swift
//  Habitica Models
//
//  Created by Phillip Thelen on 23.04.19.
//  Copyright © 2019 HabitRPG Inc. All rights reserved.
//

import Foundation

public protocol NotificationUnallocatedStatsProtocol: NotificationProtocol {
    var points: Int { get set }
}
