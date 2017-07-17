//
//  RealmLatinName.swift
//  Pods
//
//  Created by Ty Sang on 2017-04-25.
//
//

import RealmSwift

public class RealmLatinName: Object {
  
  public dynamic var id = ""
  public dynamic var name = ""
  
  override public static func primaryKey() -> String? {
    return "id"
  }
  
}
