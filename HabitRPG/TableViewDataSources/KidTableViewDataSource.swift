//
//  KidTableViewDataSource.swift
//  Habitica
//
//  Created by Surya Pratap Singh on 22/09/22.
//  Copyright © 2022 HabitRPG Inc. All rights reserved.
//

import UIKit
import Habitica_Models

class KidTableViewDataSource: TaskTableViewDataSource {
    
    init(predicate: NSPredicate) {
        super.init(predicate: predicate, taskType: TaskType.habit)
    }
    
    override func configure(cell: TaskTableViewCell, indexPath: IndexPath, task: TaskProtocol) {
        super.configure(cell: cell, indexPath: indexPath, task: task)
        if let habitCell = cell as? HabitTableViewCell {
            habitCell.plusTouched = {[weak self] in
                if !task.isValid {
                    return
                }
                self?.scoreTask(task: task, direction: .up, soundEffect: .habitPositive)
            }
            habitCell.minusTouched = {[weak self] in
                if !task.isValid {
                    return
                }
                self?.scoreTask(task: task, direction: .down, soundEffect: .habitNegative)
            }
        }
    }
    
    override func predicates(filterType: Int) -> [NSPredicate] {
        var predicates = super.predicates(filterType: filterType)
        switch filterType {
        case 1:
            predicates.append(NSPredicate(format: "value < 1"))
        case 2:
            predicates.append(NSPredicate(format: "value >= 1"))
        default:
            break
        }
        return predicates
    }
}
