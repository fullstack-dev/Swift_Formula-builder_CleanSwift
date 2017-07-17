//
//  AlternateNameCell.swift
//  FormulaBuilderCS
//
//  Created by Rui Caneira on 3/22/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit
import FormulaBuilderCore

class FBAlternateNameCell: FBBaseTableViewCell {
    
    var indexPath: IndexPath? = nil
    var displayAlternateHerb: DisplayedAlternateHerb?
    @IBOutlet weak var btnExpendable: UIButton!
    @IBOutlet weak var alternateName: UITextField!
    @IBOutlet weak var traditionalName: UITextField!
    @IBOutlet weak var simplifiedName: UITextField!
    @IBOutlet weak var propertyView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        alternateName.delegate = self
        traditionalName.delegate = self
        simplifiedName.delegate = self
        
        // Initialization code
        
    }
    func configureCell(displayAlternateName: DisplayedAlternateHerb)
    {
        self.displayAlternateHerb = displayAlternateName
        alternateName.text = displayAlternateName.name
        simplifiedName.text = displayAlternateName.simplifiedChinese
        traditionalName.text = displayAlternateName.traditionalChinese
    }
    @IBAction func action(_ sender: Any) {
        if let delegate = parentViewController as? FBProfileInfoViewController
        {
            delegate.showDeleteWarning(indexPath: indexPath!)
        }
    }
    @IBAction func expandAction(_ sender: UIButton) {
        displayAlternateHerb?.is_expandable = !(displayAlternateHerb?.is_expandable)!
//        propertyView.isHidden = !propertyView.isHidden
//        if (displayAlternateHerb?.is_expandable)!
//        {
//            btnExpendable.setBackgroundImage(UIImage(named: "profile_add"), for: .normal)
//        }else{
//            btnExpendable.setBackgroundImage(UIImage(named: "profile_min"), for: .normal)
//        }
        if let delegate = parentViewController as? FBProfileInfoViewController
        {
            delegate.expandAlternateNameAction(indexPath: indexPath!, alternateHerb: displayAlternateHerb!)
        }
    }
}

extension FBAlternateNameCell {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case alternateName:
            displayAlternateHerb?.name = alternateName.text!
            break
        case traditionalName:
            displayAlternateHerb?.traditionalChinese = alternateName.text!
            break
        case simplifiedName:
            displayAlternateHerb?.simplifiedChinese = alternateName.text!
            break
        default:
            break
        }
    }
}
