//
//  HRPGShopSectionHeaderCollectionReusableView.swift
//  Habitica
//
//  Created by Elliot Schrock on 8/1/17.
//  Copyright © 2017 HabitRPG Inc. All rights reserved.
//

import UIKit

class HRPGShopSectionHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gearCategoryButton: UIView!
    @IBOutlet weak var gearCategoryLabel: UILabel!
    @IBOutlet weak var dropdownIconView: UIImageView!
    @IBOutlet weak var otherClassDisclaimer: UILabel!
    
    var onGearCategoryLabelTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gearCategoryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gearCategoryLabelTapped)))
        dropdownIconView.image = #imageLiteral(resourceName: "carret_down").withRenderingMode(.alwaysTemplate)
    }
    
    @objc
    private func gearCategoryLabelTapped() {
        if let action = onGearCategoryLabelTapped {
            action()
        }
    }
}
