//
//  FBInitialDatabaseManager.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/8/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit
import PKHUD
import FormulaBuilderCore

class FBInitialDatabaseManager: NSObject {

    class func installInitialDatabase(completion: @escaping ((Bool) -> Swift.Void)) {
        
        let isInitialDatabaseInstalled = UserDefaults.standard.object(forKey: "InitialDatabase")
        
        if isInitialDatabaseInstalled == nil {
            
            HUD.show(.label("Initializing database.\n\nThis may take a moment"))
            
            if UserDefaults.standard.object(forKey: kSelectedLanguage) == nil {
                UserDefaults.standard.set("English", forKey: kSelectedLanguage)
            }
            
            Timer.scheduledTimer(withTimeInterval: kDuration, repeats: false, block: { timer in
                
                UserDefaults.standard.set(true, forKey: "InitialDatabase")
                
                HUD.hide(animated: true)
                
                completion(true)
            })
            
        } else {
            
            completion(false)
        }
    }
}
