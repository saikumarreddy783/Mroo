//
//  InAppRewardProtocol-Extensions.swift
//  Habitica
//
//  Created by Phillip Thelen on 07.02.20.
//  Copyright © 2020 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models

extension InAppRewardProtocol {
    
    var lockedReason: String? {
        if let text = unlockConditionText {
            return text
        } else if let reason = unlockConditionReason {
            if reason == "party invite" {
                return L10n.Quests.unlockInvite
            } else if reason == "login reward" {
                return L10n.Quests.unlockIncentive(unlockConditionIncentiveThreshold)
            }
        }
        if previous != nil {
            let number = key?.last?.wholeNumberValue
            return L10n.Quests.unlockPrevious((number ?? 1)-1)
        } else if level > 0 {
            return L10n.Quests.unlockLevel(level)
        }
        return nil
    }
    
    var shortLockedReason: String? {
        if let reason = unlockConditionReason {
            if reason == "party invite" {
                return L10n.Quests.unlockInviteShort
            } else if reason == "login reward" {
                return L10n.Quests.unlockIncentiveShort(unlockConditionIncentiveThreshold)
            }
        }
        if previous != nil {
            let number = key?.last?.wholeNumberValue
            return L10n.Quests.unlockPreviousShort((number ?? 1)-1)
        } else if level > 0 {
           return L10n.Quests.unlockLevelShort(level)
       }
        return nil
    }
}
