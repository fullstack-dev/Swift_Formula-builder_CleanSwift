//
//  FBPreparationCell.swift
//  FormulaBuilderCS
//
//  Created by Rui Caneira on 3/23/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

class FBPreparationCell: FBBaseTableViewCell {

    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var detailName: UITextField!
    @IBOutlet weak var prepareName: UITextField!
    var indexPath : IndexPath?
    var displayAlternateHerb: DisplayedAlternateHerb?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(alternateHerb: DisplayedAlternateHerb, profileViewType: ProfileViewType, indexPath: IndexPath)
    {
        self.displayAlternateHerb = alternateHerb
        self.indexPath = indexPath
        contentLabel.text = alternateHerb.preparation
        prepareName.text = alternateHerb.name
        detailName.text = alternateHerb.traditionalChinese + "(" + alternateHerb.simplifiedChinese + ")"
    }
    func configureMoreCell(preparation: DisplayPreparation, profileViewType: ProfileViewType, indexPath: IndexPath)
    {
        self.indexPath = indexPath
        contentLabel.text = preparation.content
        prepareName.text = preparation.name
        detailName.isHidden = true
    }
}
