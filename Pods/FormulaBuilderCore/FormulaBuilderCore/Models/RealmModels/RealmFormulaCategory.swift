//
//  RealmFormulaCategory.swift
//  Pods
//
//  Created by Ty Sang on 2017-02-21.
//
//

import RealmSwift

public class RealmFormulaCategory: Object {
    
    public dynamic var id = ""
    public dynamic var name = ""
    public dynamic var timestamp = 0.0
    public dynamic var categoryType = 0 // 0:all 1:herb 2:formula
    public dynamic var readOnly = false
    
    public let formulas = List<RealmFormula>()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public func toCategory() -> FBCategory {
        
        return FBCategory(id: id,
                          timestamp: timestamp,
                          name: name,
                          categoryType: CategoryType(rawValue: categoryType)!,
                          itemIDs: formulas.map{ $0.id },
                          readOnly: readOnly)
    }
}
