//
//  FBSaveToFormulaHelper.swift
//  FormulaBuilderCS
//
//  Created by YI BIN FENG on 2017-02-27.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

class FBSaveToFormulaHelper: NSObject {
    
    static let shared = FBSaveToFormulaHelper()
    
    func clearSavedHerbIDs() {
        UserDefaults.standard.set([], forKey: kAddToFormulaHerbIDs)
    }
    
    func getSavedHerbIDs() -> [String] {
        
        if let savedHerbIDs = UserDefaults.standard.object(forKey: kAddToFormulaHerbIDs) as? [String] {
            return savedHerbIDs
        }
        
        return []
    }
    
    func addHerbID(_ id: String) {
        
        if var savedHerbIDs = UserDefaults.standard.object(forKey: kAddToFormulaHerbIDs) as? [String] {
            if !savedHerbIDs.contains(id) {
                savedHerbIDs.append(id)
            }
            
            UserDefaults.standard.set(savedHerbIDs, forKey: kAddToFormulaHerbIDs)
        } else {
            UserDefaults.standard.set([id], forKey: kAddToFormulaHerbIDs)
        }
    }
    
    func removeHerbID(_ id: String) {
        
        if var savedHerbIDs = UserDefaults.standard.object(forKey: kAddToFormulaHerbIDs) as? [String] {
            if savedHerbIDs.contains(id) {
                savedHerbIDs.remove(at: savedHerbIDs.index(of: id)!)
            }
            
            UserDefaults.standard.set(savedHerbIDs, forKey: kAddToFormulaHerbIDs)
        } else {
            UserDefaults.standard.set([id], forKey: kAddToFormulaHerbIDs)
        }
    }

}
