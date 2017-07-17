//
//  FBFormulaCell.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/8/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

protocol FBFormulaCellDelegate: class {
    func formulaLockStatusChanged(_ formula: DisplayedFormula)
}

class FBFormulaCell: FBBaseTableViewCell {
    // MARK: Properties
    
    weak var formulaCellDelegate: FBFormulaCellDelegate?
    var formula: DisplayedFormula!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chineseAndLatinLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var numberLabelWidth: FBNumberLabel!
    
    func configure(with formula: DisplayedFormula) {
        self.formula = formula
        
        nameLabel.text = formula.name.capitalized
        chineseAndLatinLabel.text = formula.simplifiedChinese
        numberLabel.text = "\(formula.number)"
        
        FBHelper.setCellButtonImage(sender: eyeButton, type: .eye, isSelected: formula.isCompared)
        FBHelper.setCellButtonImage(sender: lockButton, type: .lock, isSelected: formula.isLocked)
        FBHelper.setCellButtonImage(sender: favoriteButton, type: .favorite, isSelected: formula.isFavorited)
    }
    
    @IBAction func lockButtonClicked(_ sender: UIButton) {
        FBHelper.clickedCellButton(sender: lockButton, type: .lock)
        formula.isLocked = sender.isSelected
        
        formulaCellDelegate?.formulaLockStatusChanged(formula)
    }
    
}











