//
//  StatsView.swift
//  Habitica
//
//  Created by Phillip Thelen on 28.11.17.
//  Copyright © 2017 HabitRPG Inc. All rights reserved.
//

import UIKit

@IBDesignable
class StatsView: UIView, Themeable {
    
    @IBOutlet private weak var topBackground: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var totalValueLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet private weak var levelValueLabel: UILabel!
    @IBOutlet weak var equipmentLabel: UILabel!
    @IBOutlet private weak var equipmentValueLabel: UILabel!
    @IBOutlet weak var buffsLabel: UILabel!
    @IBOutlet private weak var buffsValueLabel: UILabel!
    @IBOutlet private weak var allocatedValueLabel: UILabel!
    @IBOutlet private weak var allocatedLabel: UILabel!
    @IBOutlet private weak var allocatedBackgroundView: UIView!
    @IBOutlet private weak var allocateButton: UIButton!
    
    private var containedView: UIView?
    
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    @IBInspectable var attributeBackgroundColor: UIColor? {
        didSet {
            topBackground.backgroundColor = attributeBackgroundColor
        }
    }
    @IBInspectable var attributeTextColor: UIColor?
    
    var totalValue: Int = 0 {
        didSet {
            totalValueLabel.text = String(totalValue)
        }
    }
    
    var levelValue: Int = 0 {
        didSet {
            levelValueLabel.text = String(levelValue)
        }
    }
    var equipmentValue: Int = 0 {
        didSet {
            equipmentValueLabel.text = String(equipmentValue)
        }
    }
    var buffValue: Int = 0 {
        didSet {
            buffsValueLabel.text = String(buffValue)
        }
    }
    var allocatedValue: Int = 0 {
        didSet {
            allocatedValueLabel.text = String(allocatedValue)
        }
    }
    
    var canAllocatePoints: Bool = false {
        didSet {
            allocateButton.isHidden = !canAllocatePoints
            let theme = ThemeService.shared.theme
            if canAllocatePoints {
                allocateButton.backgroundColor = theme.offsetBackgroundColor
                allocatedBackgroundView.backgroundColor = theme.offsetBackgroundColor
                if theme.isDark {
                    allocateButton.tintColor = .gray400
                    allocatedLabel.textColor = theme.primaryTextColor
                    allocatedValueLabel.textColor = theme.primaryTextColor
                } else {
                    allocateButton.tintColor = .purple500
                    allocatedValueLabel.textColor = attributeTextColor
                    allocatedLabel.textColor = attributeTextColor
                }
            } else {
                allocateButton.backgroundColor = theme.windowBackgroundColor
                allocatedBackgroundView.backgroundColor = theme.windowBackgroundColor
                allocatedLabel.textColor = theme.dimmedTextColor
                allocatedValueLabel.textColor = theme.primaryTextColor
            }
        }
    }
    
    var allocateAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 154, height: 36))
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Private Helper Methods
    
    private func setupView() {
        if let view = viewFromNibForClass() {
            containedView = view
            translatesAutoresizingMaskIntoConstraints = false
            
            view.frame = bounds
            addSubview(view)
            
            levelLabel.text = L10n.level
            equipmentLabel.text = L10n.Equipment.equipment
            buffsLabel.text = L10n.buffs
            allocatedLabel.text = L10n.allocated
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": view]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": view]))
            
            allocateButton.setImage(HabiticaIcons.imageOfAttributeAllocateButton, for: .normal)
            allocateButton.tintColor = UIColor(red: 0.529, green: 0.506, blue: 0.565, alpha: 1.000)
            
            setNeedsUpdateConstraints()
            updateConstraints()
            setNeedsLayout()
            layoutIfNeeded()
        }
        ThemeService.shared.addThemeable(themable: self)
    }
    
    func applyTheme(theme: Theme) {
        backgroundColor = theme.contentBackgroundColor
        containedView?.backgroundColor = theme.contentBackgroundColorDimmed
        levelLabel.textColor = theme.dimmedTextColor
        levelValueLabel.textColor = theme.primaryTextColor
        equipmentLabel.textColor = theme.dimmedTextColor
        equipmentValueLabel.textColor = theme.primaryTextColor
        buffsLabel.textColor = theme.dimmedTextColor
        buffsValueLabel.textColor = theme.primaryTextColor
        allocatedLabel.textColor = theme.dimmedTextColor
        allocatedValueLabel.textColor = theme.primaryTextColor
    }
    
    @IBAction func allocateButtonTapped(_ sender: Any) {
        allocateButton.backgroundColor = UIColor.gray500
        if let action = allocateAction {
            action()
        }
    }
}
