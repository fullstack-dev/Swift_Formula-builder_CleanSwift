//
//  Extensions.swift
//  Pods
//
//  Created by T. S. on 2017-01-09.
//
//

import Foundation
import RealmSwift
import SwiftyJSON

extension Results {
  
  func toArray() -> [T] {
  
    var tempArray = [T]()
    for i in 0..<count {
        tempArray.append(self[i])
      
    }
    return tempArray
  }
  
}

extension Object {
  
  public func json() -> JSON {
    
    let allProperties = self.objectSchema.properties
    
    var dict = [String: Any]()
    
    for property in allProperties {
      
      dict[property.name] = self.value(forKey: property.name)
    }
    return JSON(dict)
  }
}
