//
//  FBTableView.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/14/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

class FBTableView: UITableView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        rowHeight = kRowHeight
        separatorStyle = .none
    }

}
