//
//  FBAppearance.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/8/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

class FBAppearance: NSObject {
    
    class func configureAppearance() {
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: FBFont.SFUIText_Semibold17(), NSForegroundColorAttributeName: FBColor.hexColor_030303()]
        
        // hide back button title
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -60), for: .default)
    }
}
