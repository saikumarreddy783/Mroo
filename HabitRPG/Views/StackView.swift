//
//  StackView.swift
//  Habitica
//
//  Created by Phillip Thelen on 10.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import UIKit

@IBDesignable
class StackView: UIStackView {
    @IBInspectable private var color: UIColor?
    override var backgroundColor: UIColor? {
        get { return color }
        set {
            color = newValue
            self.setNeedsLayout()
        }
    }
    
    override var cornerRadius: CGFloat {
        get {
            backgroundLayer.cornerRadius
        }
        set {
            backgroundLayer.cornerRadius = newValue
        }
    }
    
    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: backgroundLayer.cornerRadius).cgPath
        backgroundLayer.fillColor = self.backgroundColor?.cgColor
    }
}
