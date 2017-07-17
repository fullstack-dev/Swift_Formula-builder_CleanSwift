//
//  FBProfileAccordionViewTableHeaderView.swift
//  FormulaBuilderCS
//
//  Created by a on 2/20/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit
import FZAccordionTableView

class FBProfileAccordionViewTableHeaderView: FZAccordionTableViewHeaderView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var disclosure_Icon: UIImageView!

    static let kDefaultAccordionHeaderViewHeight: CGFloat = 48.0;
    static let kAccordionHeaderViewReuseIdentifier = "FBProfileAccordionViewTableHeaderView";
    
    func configureAccordionView(title: String, isEnabled: Bool = true) {
        lblTitle.textColor = isEnabled ? FBColor.hexColor_030303() : FBColor.hexColor_B4B4B4()
        lblTitle.text = title
            
        disclosure_Icon.isHidden = !isEnabled
    }
}
