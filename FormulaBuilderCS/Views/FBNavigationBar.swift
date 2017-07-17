//
//  FBNavigationBar.swift
//  FormulaBuilderCS
//
//  Created by a on 4/21/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

class FBNavigationBar: UINavigationBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var ease : Bool = false
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let v : UIView? =  super.hitTest(point, with: event)
        guard v != nil else {
            ease = true
            return nil
        }
        
        if (ease) {
            ease = false
            return nil
        }
        
        return v
    }
}
