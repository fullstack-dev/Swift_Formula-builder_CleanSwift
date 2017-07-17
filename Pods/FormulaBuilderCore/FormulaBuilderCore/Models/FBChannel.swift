//
//  FBChannel.swift
//  Pods
//
//  Created by Ty Sang on 2017-02-25.
//
//

import Foundation

public struct FBChannel: Equatable {
  
  public var id: String
  public var chineseName: String
  public var englishName: String
  public var iconName: String
}

public func ==(lhs: FBChannel, rhs: FBChannel) -> Bool{
  
  return lhs.id == rhs.id
}
