//
//  FBCoreHelper.swift
//  FormulaBuilderCS
//
//  Created by a on 3/13/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

class FBCoreHelper: NSObject {
    class func generateChineseName(simplifiedChinese : String?, traditionalChinese : String?) -> String{
        var chineseName : String = traditionalChinese ?? ""
        let simplifiedChinese = simplifiedChinese ?? ""
        if (chineseName.characters.count > 0) {
            chineseName = chineseName + (simplifiedChinese.characters.count > 0 ? "(" + simplifiedChinese + ")" : "")
        } else {
            chineseName = simplifiedChinese
        }
        
        return chineseName
    }
    
    class func parseChineseName(chineseName : String) -> [String: String] {
        
        let s = chineseName.components(separatedBy: "(")
        guard s.count > 1 else {
            let parsedChineseName : [String : String] = ["Simplified" : chineseName, "Traditional" : ""]
            return parsedChineseName
        }
        
        let t = (s[1].components(separatedBy: ")"))[0]
        let parsedChineseName : [String : String] = ["Simplified" : s[0], "Traditional" : t]
        return parsedChineseName
    }
}
