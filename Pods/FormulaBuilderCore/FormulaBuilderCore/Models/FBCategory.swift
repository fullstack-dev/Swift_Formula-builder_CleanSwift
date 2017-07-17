//
//  Category.swift
//  Pods
//
//  Created by T. S. on 2017-01-30.
//
//

public struct FBCategory: Equatable {
  
  public var id: String
  public var timestamp: Double
  public var name: String
  public var categoryType: CategoryType // 0:all 1:herb 2:formula
  public var readOnly = false
  
  public var itemIDs: [String] // Array of itemIDs
  
  public init(id: String, timestamp: Double, name: String, categoryType: CategoryType, itemIDs: [String], readOnly: Bool) {
  
    self.id           = id
    self.timestamp    = timestamp
    self.name         = name
    self.categoryType = categoryType
    self.itemIDs        = itemIDs
    self.readOnly     = readOnly
  }
}

public func ==(lhs: FBCategory, rhs: FBCategory) -> Bool{
  
  return lhs.id == rhs.id
}
