//
//  KidTableViewController.swift
//  Habitica
//
//  Created by Surya Pratap Singh on 22/09/22.
//  Copyright © 2022 HabitRPG Inc. All rights reserved.
//

import UIKit

class KidTableViewController: TaskTableViewController {
    var lastLoggedPredicate: String?
    
    override func viewDidLoad() {
        readableName = L10n.Tasks.habit
        typeName = "habit"
        super.viewDidLoad()
        dataSource?.isKid = true
        dataSource?.emptyDataSource = TaskEmptyTableViewDataSource<EmptyTableViewCell>(tableView: tableView, cellIdentifier: "emptyCell", styleFunction: EmptyTableViewCell.habitsStyle)
                
        self.tutorialIdentifier = "habits"
        configureTitle("Kid")
    }
    
    override func createDataSource() {
        dataSource = KidTableViewDataSource(predicate: self.getPredicate())
    }
    
    override func getDefinitionFor(tutorial: String) -> [String] {
        if tutorial == tutorialIdentifier {
            return [L10n.Tutorials.habits1, L10n.Tutorials.habits2, L10n.Tutorials.habits3, L10n.Tutorials.habits4]
        }
        return super.getDefinitionFor(tutorial: tutorial)
    }
    
    override func getCellNibName() -> String {
        return "KidTableViewCell"
    }
    
    override func refresh() {
        super.refresh()
    }
}
