//
//  Recent.swift
//  Pods
//
//  Created by T. S. on 2017-01-14.
//
//

import RealmSwift

public class RealmRecent: Object {
  
  public dynamic var id = ""
  public dynamic var timestamp = 0.0
  public dynamic var recordID = ""
  public dynamic var recordType = 0 // 0:all 1:herb 2:formula
  
  override public static func primaryKey() -> String? {
    return "id"
  }
  
  
  public func toRecent() -> FBRecent {
    return FBRecent(id: id,
                    timestamp: timestamp,
                    recordID: recordID,
                    recordType: RecentRecordType(rawValue: recordType)!)
  }
}
