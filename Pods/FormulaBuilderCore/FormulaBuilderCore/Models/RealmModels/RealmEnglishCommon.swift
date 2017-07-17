//
//  RealmEnglishCommon.swift
//  Pods
//
//  Created by Ty Sang on 2017-04-25.
//
//

import RealmSwift

public class RealmEnglishCommon: Object {
  
  public dynamic var id = ""
  public dynamic var name = ""
  
  override public static func primaryKey() -> String? {
    return "id"
  }
  
}
