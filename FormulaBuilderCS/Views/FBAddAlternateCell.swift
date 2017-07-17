//
//  FBAddAlternateCell.swift
//  FormulaBuilderCS
//
//  Created by Rui Caneira on 3/22/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

class FBAddAlternateCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    var vcdelegate: UIViewController? = nil
    var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func action(_ sender: Any) {
        if let profileInfoVC = vcdelegate as? FBProfileInfoViewController {
            profileInfoVC.addAlternateNameAction(indexpath: indexPath)
            
        } else if let profileMoreVC = vcdelegate as? FBProfileMoreViewController {
            profileMoreVC.addPreparation(indexpath: indexPath)
            
        }
        
    }
}
