//
//  HRPGHabitTableViewCell.swift
//  Habitica
//
//  Created by Phillip Thelen on 09/03/2017.
//  Copyright © 2017 HabitRPG Inc. All rights reserved.
//

import UIKit
import Habitica_Models

class HabitTableViewCell: TaskTableViewCell {

    // swiftlint:disable:next private_outlet
    @IBOutlet weak var plusButton: HabitButton!
    // swiftlint:disable:next private_outlet
    @IBOutlet weak var minusButton: HabitButton!

    @objc var plusTouched: (() -> Void)?
    @objc var minusTouched: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentStartEdge = plusButton.edge.end
        contentEndEdge = minusButton.edge.start
    }
    
    override func configure(task: TaskProtocol) {
        super.configure(task: task)
        plusButton.configure(task: task, isNegative: false)
        minusButton.configure(task: task, isNegative: true)
        plusButton.action = {[weak self] in
            self?.scoreUp()
        }
        minusButton.action = {[weak self] in
            self?.scoreDown()
        }
        
        if !task.up && !task.down {
            titleLabel.textColor = ThemeService.shared.theme.quadTextColor
            subtitleLabel.textColor = ThemeService.shared.theme.quadTextColor
        }
    }
    
    override func applyAccessibility(_ task: TaskProtocol) {
        super.applyAccessibility(task)
        var customActions = [UIAccessibilityCustomAction]()
        if task.up {
            customActions.append(UIAccessibilityCustomAction(name: L10n.Accessibility.scoreHabitUp, target: self, selector: #selector(scoreUp)))
        }
        if task.down {
            customActions.append(UIAccessibilityCustomAction(name: L10n.Accessibility.scoreHabitDown, target: self, selector: #selector(scoreDown)))
        }
        accessibilityCustomActions = customActions
    }
    
    override func layoutContentStartEdge() {
        plusButton.pin.width(40).start()
    }
    
    override func layoutContentEndEdge() {
        minusButton.pin.width(40).end()
        contentEndEdge = minusButton.edge.start
        super.layoutContentEndEdge()
    }
    
    override func layout() {
        super.layout()
        plusButton.pin.top().bottom().start()
        plusButton.updateLayout()
        minusButton.pin.top().bottom().end()
        minusButton.updateLayout()
    }
    
    @objc
    func scoreUp() {
        if let action = plusTouched {
            action()
        }
    }
    
    @objc
    func scoreDown() {
        if let action = minusTouched {
            action()
        }
    }
}
