//
//  OwnedMountProtocol.swift
//  Habitica Models
//
//  Created by Phillip Thelen on 16.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation

@objc
public protocol OwnedMountProtocol {
    var key: String? { get set }
    var owned: Bool { get set }
}
