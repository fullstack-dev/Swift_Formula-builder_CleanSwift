//
//  FBTitleCell.swift
//  FormulaBuilderCS
//
//  Created by Rui Caneira on 3/25/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

class FBTitleCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(value: String, autoComplete: Bool = false) {
        lblTitle.text = value
        self.backgroundColor = autoComplete ? FBColor.hexColor_F7F7F7() : UIColor.clear
    }
    
}
