//
//  FBCell.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/10/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

protocol FBCellDelegate: class {
    //    func selectedFormul(_ formula: DisplayedFormula)
    func addHerbToMyFormula(herb: DisplayedHerb?)
    func lockStatusChanged(herb: DisplayedHerb?, formula: DisplayedFormula?)
    func addFormulaToCompare(_ formula: DisplayedFormula)
    func addHerbToCompare(_ herb: DisplayedHerb)
    func favoriteStatusChanged(herb: DisplayedHerb?, formula: DisplayedFormula?)
}

class FBCell: FBBaseTableViewCell {
    
    weak var cellDelegate: FBCellDelegate?
    
    var herb: DisplayedHerb?
    var formula: DisplayedFormula?
    
    @IBOutlet weak var nameLabel: UILabel! // pin yin
    @IBOutlet weak var chineseNameLabel: UILabel! // simplified(traditional)
    @IBOutlet weak var englishNameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var nameLabelTrailingToNumberLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var nameLabelLeadingToContentView: NSLayoutConstraint!
    @IBOutlet weak var nameLabelTrailingToLockButtonLeading: NSLayoutConstraint!
    
    func configure(herb: DisplayedHerb) {
        self.herb = herb
        
        nameLabel.text = herb.name.capitalized
        chineseNameLabel.text = herb.simplifiedChinese + "(" + herb.traditionalChinese + ")"
        englishNameLabel.text = herb.englishName
        
        addButton.isHidden = true
        eyeButton.isHidden = false
        lockButton.isHidden = true
        numberLabel.isHidden = true
        
        contentView.removeConstraint(nameLabelTrailingToNumberLabelLeading)
        contentView.addConstraint(nameLabelTrailingToLockButtonLeading)
        
        //        FBHelper.setCellButtonImage(sender: addButton, type: .add, isSelected: herb.addToFormula)
        FBHelper.setCellButtonImage(sender: favoriteButton, type: .favorite, isSelected: herb.isFavorited)
        FBHelper.setCellButtonImage(sender: eyeButton, type: .eye, isSelected: herb.isCompared)
    }
    
    func configure(formula: DisplayedFormula) {
        self.formula = formula
        
        nameLabel.text = formula.name.capitalized
        chineseNameLabel.text = formula.simplifiedChinese + "(" + formula.traditionalChinese + ")"
        englishNameLabel.text = formula.englishName
        numberLabel.text = "\(formula.number)"
        
        FBHelper.setCellButtonImage(sender: addButton, type: .add, isSelected: formula.isSelected)
        FBHelper.setCellButtonImage(sender: eyeButton, type: .eye, isSelected: formula.isCompared)
        FBHelper.setCellButtonImage(sender: lockButton, type: .lock, isSelected: formula.isLocked)
        FBHelper.setCellButtonImage(sender: favoriteButton, type: .favorite, isSelected: formula.isFavorited)
    }
    
    @IBAction func cellButtonClicked(_ sender: UIButton) {
        if sender == eyeButton {
            FBHelper.clickedCellButton(sender: sender, type: .eye)
            if let _ = herb{
                herb?.isCompared = sender.isSelected
                herb?.isSelected = sender.isSelected
                cellDelegate?.addHerbToCompare(herb!)
            }else
            {
                formula?.isCompared = sender.isSelected
                cellDelegate?.addFormulaToCompare(formula!)
            }
            
        } else if sender == addButton {
            FBHelper.clickedCellButton(sender: sender, type: .add)
            formula?.isSelected = sender.isSelected
            
            if sender.isSelected {
                contentView.backgroundColor = FBColor.hexColor_F7FAF4()
            } else {
                contentView.backgroundColor = UIColor.white
            }
            
            if herb != nil {
                cellDelegate?.addHerbToMyFormula(herb: herb)
            } else {
                cellDelegate?.addFormulaToCompare(formula!)
            }
            
        } else if sender == lockButton {
            FBHelper.clickedCellButton(sender: sender, type: .lock)
            formula?.isLocked = sender.isSelected
            
            cellDelegate?.lockStatusChanged(herb: herb, formula: formula)
        } else  {
            FBHelper.clickedCellButton(sender: sender, type: .favorite)
            herb?.isFavorited = sender.isSelected
            formula?.isFavorited = sender.isSelected
            
            cellDelegate?.favoriteStatusChanged(herb: herb, formula: formula)
        }
        
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clearActionsheet() // remove actionCell view from cell
    }
}

