//
//  FBBaseTableViewCell.swift
//  FormulaBuilderCS
//
//  Created by a on 3/1/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class FBBaseTableViewCell: MGSwipeTableCell {

    var parentViewController : UIViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FBBaseTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let btn = self.viewWithTag(textField.tag + 1) as? UIButton
        if btn != nil {
            btn?.setImage(UIImage(named: "profile_add_selected") , for: .normal)
        }
        return true
    }
}

