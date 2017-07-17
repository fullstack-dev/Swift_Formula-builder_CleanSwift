//
//  RealmChannel.swift
//  Pods
//
//  Created by Ty Sang on 2017-02-21.
//
//

import RealmSwift

public class RealmChannel: Object {
  
  public dynamic var id = ""
  public dynamic var iconName = ""
  public dynamic var chineseName = ""
  public dynamic var englishName = ""
  public dynamic var readOnly = true
  
  override public static func primaryKey() -> String? {
    return "id"
  }
  
  public func toChannel() -> FBChannel {
    
    return FBChannel(id: id, chineseName: chineseName, englishName: englishName, iconName: iconName)
  }
}
