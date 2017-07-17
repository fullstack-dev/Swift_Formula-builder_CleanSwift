//
//  Note.swift
//  Pods
//
//  Created by T. S. on 2017-01-19.
//
//

import RealmSwift

public class RealmNote: Object {
  
  public dynamic var id = ""
  public dynamic var title = ""
  public dynamic var content = ""
  public dynamic var createdTimestamp = 0.0
  public dynamic var modifiedTimestamp = 0.0
  
  override public static func primaryKey() -> String? {
    return "id"
  }
  
  
  public func toNote() -> FBNote {
    
    return FBNote(id: id,
                  title: title,
                  content: content,
                  createdTimestamp: createdTimestamp,
                  modifiedTimestamp: modifiedTimestamp)
  }
}
