//
//  FBTextCell.swift
//  FormulaBuilderCS
//
//  Created by a on 2/19/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit
protocol FBTextCellDelegate: class {
    func textFieldBeginEdit(txtField: UITextField, indexPath: IndexPath)
    func textFieldEditing(txtField: UITextField, indexPath: IndexPath)
    func keyboardDismissOnTextCell(txtField: UITextField)
}
class FBTextCell: FBBaseTableViewCell {
    
    weak var cellDelegate: FBTextCellDelegate?
    var alternateHerb:DisplayedAlternateHerb?
    var delagete: FBProfileInfoViewController?
    var indexPath: IndexPath?
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var editPanel: UIView!
    @IBOutlet weak var txtContent: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        txtContent.addTarget(self, action: #selector(textfieldDidBegin(_:)), for: .editingDidBegin)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func desiredHeight() -> CGFloat {
        return 72
    }
    
    func configureTextCell(indexPath: IndexPath, strTitle: String, strSubTitle: String, strPlaceholder: String, profileType: ProfileViewType, isEnglish: Bool = true) {
        self.indexPath = indexPath
        
        title.textColor = FBColor.hexColor_B4B4B4()
        title.font = FBFont.SFUIText_Semibold14()
        title.text = strTitle
        
        if (profileType == .view) {
            subTitle.textColor = FBColor.hexColor_4A4A4A()
            subTitle.font = isEnglish ? FBFont.SFUIText_Regalur17() : FBFont.PingFangSC_Regular17()
            subTitle.text = strSubTitle
        } else {
            editPanel.isHidden = false
            txtContent.textColor = FBColor.hexColor_4A4A4A()
            txtContent.font = isEnglish ? FBFont.SFUIText_Regalur17() : FBFont.PingFangSC_Regular17()
            txtContent.text = strSubTitle
            txtContent.placeholder = strPlaceholder
            setupInputAccessoryViewsForTextFields(txtFields: [txtContent])
        }
    }
    
    func configureMoreCell(indexPath: IndexPath, strTitle: String, strSubTitle: String, strPlaceholder: String, profileType: ProfileViewType, isEnglish: Bool = true) {
        title.textColor = FBColor.hexColor_4A4A4A()
        title.font = FBFont.SFUIText_Regalur17()
        title.text = strTitle
        
        if (profileType == .view) {
            subTitle.textColor = FBColor.hexColor_4A4A4A()
            subTitle.font = isEnglish ? FBFont.SFUIText_Regalur17() : FBFont.PingFangSC_Regular17()
            subTitle.text = strSubTitle
        } else {
            editPanel.isHidden = false
            txtContent.textColor = FBColor.hexColor_4A4A4A()
            txtContent.font = isEnglish ? FBFont.SFUIText_Regalur17() : FBFont.PingFangSC_Regular17()
            txtContent.text = strSubTitle
            txtContent.placeholder = strPlaceholder
            setupInputAccessoryViewsForTextFields(txtFields: [txtContent])
        }
    }
}

extension FBTextCell {
    func setupInputAccessoryViewsForTextFields(txtFields : [UITextField]) {
        let keyboardDismissBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "keyboardDismiss") , style: .done, target: self, action: #selector(keyboardDismissBtnTapped(_:)))
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let toolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.setItems([flexibleSpace, keyboardDismissBtn], animated: true)
        
        for txtField in txtFields {
            txtField.inputAccessoryView = toolbar
        }
    }
    
    func keyboardDismissBtnTapped(_ sender: Any) {
        self.contentView.endEditing(true)
        cellDelegate?.keyboardDismissOnTextCell(txtField: txtContent)
    }
}

extension FBTextCell {
    @IBAction func addBtnTapped(_ sender: Any) {
        let btn = sender as! UIButton
        if (!txtContent.isFirstResponder) {
            txtContent.becomeFirstResponder()
            btn.setImage(UIImage(named: "profile_add_selected") , for: .normal)
        } else {
            txtContent.text = ""
            let _ = txtContent.resignFirstResponder()
            btn.setImage(UIImage(named: "profile_add") , for: .normal)
        }
    }
    
    @IBAction func textfieldDidChanged(_ sender: UITextField) {
        if (cellDelegate != nil) {
            cellDelegate?.textFieldEditing(txtField: sender, indexPath: self.indexPath!)
        }
    }
    
    @IBAction func textfieldDidBegin(_ sender: UITextField) {
        if (cellDelegate != nil) {
            cellDelegate?.textFieldBeginEdit(txtField: sender, indexPath: self.indexPath!)
        }
    }
}
