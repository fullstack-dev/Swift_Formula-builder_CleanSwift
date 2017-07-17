//
//  Recent.swift
//  Pods
//
//  Created by T. S. on 2017-01-30.
//
//

public struct FBRecent: Equatable {
  
  public var id: String
  public var timestamp: Double
  public var recordID: String
  public var recordType: RecentRecordType // 0:all 1:herb 2:formula
  
  public init(id: String, timestamp: Double, recordID: String, recordType: RecentRecordType) {
    
    self.id = id
    self.timestamp  = timestamp
    self.recordID   = recordID
    self.recordType = recordType
  }
}

public func ==(lhs: FBRecent, rhs: FBRecent) -> Bool{
  
  return lhs.id == rhs.id
}
