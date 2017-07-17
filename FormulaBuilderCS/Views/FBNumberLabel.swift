//
//  FBNumberLabel.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/8/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

let kDefaultNumberLabelWH: CGFloat = 23.9

class FBNumberLabel: UILabel {
    var width: NSLayoutConstraint!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        backgroundColor = FBColor.hexColor_63A020()
        textColor = UIColor.white
        font = FBFont.SFUIDisplay_Bold12()
        textAlignment = .center
        clipsToBounds = true
        alpha = 0.75
        layer.cornerRadius = kDefaultNumberLabelWH / 2
        
        // manaully add width & height constraint
        width = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: kDefaultNumberLabelWH)
        let height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: kDefaultNumberLabelWH)
        
        addConstraints([width, height])
    }
    
    override var text: String? {
        didSet {
            if let text = text {
                if Int(text)! >= 100 {
                    width.constant = FBHelper.widthOf(self)
                } else {
                    width.constant = kDefaultNumberLabelWH
                }
            }
        }
    }
}
