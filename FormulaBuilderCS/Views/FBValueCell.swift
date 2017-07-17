//
//  FBValueCell.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/21/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

class FBValueCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        clipsToBounds = true
    }

}
