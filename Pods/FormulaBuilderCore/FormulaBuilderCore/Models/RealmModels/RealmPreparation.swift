//
//  RealmPreparation.swift
//  Pods
//
//  Created by Ty Sang on 2017-03-25.
//
//

import RealmSwift

public class RealmPreparation: Object {
  
  public dynamic var id = ""
  public dynamic var name: String? = ""
  public dynamic var content: String? = ""
  
  override public static func primaryKey() -> String? {
    return "id"
  }
  
  public func toPreparation() -> FBPreparation {
    
    return FBPreparation(id: id, name: name, content: content)
  }
}
