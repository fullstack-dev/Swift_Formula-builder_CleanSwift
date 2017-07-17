//
//  FBAlternateNameViewCell.swift
//  FormulaBuilderCS
//
//  Created by Rui Caneira on 3/26/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

class FBAlternateNameViewCell: FBBaseTableViewCell {

    @IBOutlet weak var prepView: UIView!
    @IBOutlet weak var detailName: UITextField!
    @IBOutlet weak var alternateName: UITextField!
    var displayAlternateHerb: DisplayedAlternateHerb?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(alternateHerb: DisplayedAlternateHerb)
    {
        self.displayAlternateHerb = alternateHerb
        alternateName.text = alternateHerb.name
        detailName.text = alternateHerb.traditionalChinese + "(" + alternateHerb.simplifiedChinese + ")"
        if alternateHerb.description == ""
        {
            prepView.isHidden = true
        }
    }
    
    @IBAction func prepBtnAction(_ sender: Any) {
        if let delegate = parentViewController as? FBProfileInfoViewController
        {
            delegate.navigateAction(alternateHerb: displayAlternateHerb!)
        }
    }
}
