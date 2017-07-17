//
//  FBPreparationEditCell.swift
//  FormulaBuilderCS
//
//  Created by Rui Caneira on 3/26/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

class FBPreparationEditCell: FBBaseTableViewCell {
    
    @IBOutlet weak var placeHolderLbl: UILabel!
    @IBOutlet weak var methodNameTxt: UITextField!
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var title: UILabel!
    
    var indexPath : IndexPath?
    var displayAlternateHerb: DisplayedAlternateHerb?
    var displayPreparation: DisplayPreparation?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentText.delegate = self
        contentText.font = FBFont.SFUIText_Regalur17()
        methodNameTxt.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(alternateHerb: DisplayedAlternateHerb, profileViewType: ProfileViewType, indexPath: IndexPath) {
        self.displayAlternateHerb = alternateHerb
        self.indexPath = indexPath
        contentText.text = alternateHerb.preparation
        methodNameTxt.text = alternateHerb.name
        methodNameTxt.isUserInteractionEnabled = false
        if contentText.text != ""
        {
            placeHolderLbl.isHidden = true
        }
        if profileViewType == .view
        {
            
        }
        displayPreparation = nil
        FBHelper.setCellButtonImage(sender: addBtn, type: .expand, isSelected: alternateHerb.isSelected)
    }
    
    func configureMoreCell(preparation: DisplayPreparation, profileViewType: ProfileViewType, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.displayPreparation = preparation
        contentText.text = preparation.content
        methodNameTxt.text = preparation.name
        methodNameTxt.isUserInteractionEnabled = true
        if contentText.text != ""
        {
            placeHolderLbl.isHidden = true
        }
        displayAlternateHerb = nil
        FBHelper.setCellButtonImage(sender: addBtn, type: .expand, isSelected: preparation.isSelected)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        FBHelper.clickedCellButton(sender: sender, type: .expand)
        methodNameTxt.becomeFirstResponder()
        if let delegate = self.parentViewController as? FBProfileMoreViewController
        {
            if let _ = self.displayPreparation
            {
                self.displayPreparation?.isSelected = sender.isSelected
                delegate.expandPreparationCell(indexPath: indexPath!, preparation: self.displayPreparation!)
            }else if let _ = self.displayAlternateHerb{
                self.displayAlternateHerb?.isSelected = sender.isSelected
                delegate.expandCell(indexPath: indexPath!, alternateHerb: displayAlternateHerb!)
            }
            
        }
        
    }
}

extension FBPreparationEditCell: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        if let delegate = self.parentViewController as? FBProfileMoreViewController
        {
            if let _ = self.displayAlternateHerb {
                displayAlternateHerb?.preparation = textView.text
                delegate.addPreparationToAlternateHerb(indexPath: indexPath!, alternateHerb: self.displayAlternateHerb!)
            } else if let _ = self.displayPreparation {
                displayPreparation?.content = textView.text
            }
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == ""
        {
            placeHolderLbl.isHidden = false
        }else{
            placeHolderLbl.isHidden = true
        }
    }
}

///// UITextFieldDelegate
extension FBPreparationEditCell {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == methodNameTxt
        {
            if let _ = displayPreparation
            {
                displayPreparation?.name = textField.text!
            }
        }
    }
}
