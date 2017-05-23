//
//  EvaluateButton.swift
//  Examples
//
//  Created by Alex Cristea on 23/05/2017.
//  Copyright © 2017 Alex Cristea. All rights reserved.
//

import UIKit

@IBDesignable
class EvaluateButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            super.isHighlighted = newValue
            setupLayout()
        }
    }
    func setupLayout() {
        
        layer.borderWidth = 1
        layer.cornerRadius = 10
        
        if let color = titleColor(for: .normal) {
            layer.borderColor = color.cgColor
        }
    }
}
