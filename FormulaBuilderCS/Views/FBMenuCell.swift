//
//  FBMenuCell.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/15/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

class FBMenuCell: FBBaseTableViewCell {

    @IBOutlet weak var topLine0: UIView!
    @IBOutlet weak var topLine1: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var arrow: UIImageView!
    func configure(with text: String) {
        
        textLabel?.text = text
        
        if text == "Home" {
            imageView?.image = UIImage(named: "home")
            option0()
        } else if text == "Advanced Search" {
            imageView?.image = UIImage(named: "advanced_search")
            option0()
        } else if text == "Single Herbs" {
            imageView?.image = UIImage(named: "herb_green")
            option1()
        } else if text == "Categories" {
            option2()
        } else if text == "Add New Herbs" || text == "Add New Formula" {
            option3()
        } else if text == "Formulas" {
            imageView?.image = UIImage(named: "formula_green")
            option1()
        } else if text == "Favorites" {
            imageView?.image = UIImage(named: "favorite_green")
            option0()
        } else if text == "Recent Search" {
            imageView?.image = UIImage(named: "recent_search")
            option0()
        } else if text == "Settings" {
            imageView?.image = UIImage(named: "settings")
            option0()
        } else if text == "References" {
            option4()
        }
    }

    func option0() {
        topLine0.isHidden = false
        topLine1.isHidden = true
        bottomLine.isHidden = false
        contentView.backgroundColor = UIColor.white
        arrow.isHidden = false
        textLabel?.textColor = FBColor.hexColor_030303()
    }
    
    func option1() {
        topLine0.isHidden = false
        topLine1.isHidden = true
        bottomLine.isHidden = true
        contentView.backgroundColor = UIColor.white
        arrow.isHidden = true
        textLabel?.textColor = FBColor.hexColor_030303()
    }
    
    func option2() {
        topLine0.isHidden = true
        topLine1.isHidden = false
        bottomLine.isHidden = true
        contentView.backgroundColor = UIColor.white
        arrow.isHidden = false
        textLabel?.textColor = FBColor.hexColor_030303()
        imageView?.image = UIImage(named: "transparent")
    }
    
    func option3() {
        topLine0.isHidden = true
        topLine1.isHidden = false
        bottomLine.isHidden = false
        contentView.backgroundColor = UIColor.white
        arrow.isHidden = false
        textLabel?.textColor = FBColor.hexColor_030303()
        imageView?.image = UIImage(named: "transparent")
    }
    
    func option4() {
        topLine0.isHidden = true
        topLine1.isHidden = true
        bottomLine.isHidden = true
        contentView.backgroundColor = FBColor.hexColor_F7F7F7()
        arrow.isHidden = true
        textLabel?.textColor = FBColor.hexColor_9B9B9B()
        imageView?.image = UIImage(named: "transparent")
    }
}
