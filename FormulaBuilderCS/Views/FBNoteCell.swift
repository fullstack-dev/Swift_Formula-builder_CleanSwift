//
//  FBNoteCell.swift
//  FormulaBuilderCS
//
//  Created by a on 2/19/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class FBNoteCell: MGSwipeTableCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblModifiedDate: UILabel!
    @IBOutlet weak var lbcModifiedDateLabelWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(note: DisplayedNote) {
        lblTitle.text = note.title
        lblContent.text = note.content
        lblDate.text = note.createdDate
        lblModifiedDate.text = note.modifiedDate
        
        lblModifiedDate.sizeToFit()
        lbcModifiedDateLabelWidth.constant = lblModifiedDate.frame.size.width
        
        contentView.backgroundColor = FBColor.hexColor_F7F7F7()
        self.contentView.layoutIfNeeded()
    }
    
}
