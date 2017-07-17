//
//  Note.swift
//  Pods
//
//  Created by T. S. on 2017-01-26.
//
//

import Foundation

public struct FBNote: Equatable {
  
  public var id               : String
  public var title            : String
  public var content          : String
  public var createdTimestamp : Double
  public var modifiedTimestamp: Double
  
  public init(id: String, title:String, content: String, createdTimestamp : Double, modifiedTimestamp: Double) {
    self.id = id
    self.title = title
    self.content = content
    self.createdTimestamp = createdTimestamp
    self.modifiedTimestamp = modifiedTimestamp
  }
}

public func ==(lhs: FBNote, rhs: FBNote) -> Bool {
  
  return lhs.id == rhs.id
}
