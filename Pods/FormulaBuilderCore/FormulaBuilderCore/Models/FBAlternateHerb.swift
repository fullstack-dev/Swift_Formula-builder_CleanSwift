//
//  FBAlternateItem.swift
//  Pods
//
//  Created by Ty Sang on 2017-03-18.
//
//

import Foundation

public struct FBAlternateHerb: Equatable {
  
  public var id: String?
  public var name: String
  public var readOnly = false
  public var herbName: String
  public var herbID: String?
  
  public var pinyin:             String?
  public var pinyinCode:         String?
  public var simplifiedChinese:  String?
  public var traditionalChinese: String?
  public var preparation:        String?
  
  public var sourceTextEnglish:  String?
  public var sourceTextChinese:  String?
  
  public var species         : [String]
  public var flavours        : [String]
  public var natures         : [String]
  public var englishCommons  : [String]
  public var latinNames      : [String]
  public var channels        : [FBChannel]
  public var notes           : [FBNote]

  
  public init(name:               String,
              id:                 String?,
              readOnly:           Bool,
              herbName:           String,
              herbID:             String?,
              pinyin:             String?,
              pinyinCode:         String?,
              simplifiedChinese:  String?,
              traditionalChinese: String?,
              preparation:        String?,
              englishCommons:     [String],
              latinNames:         [String],
              sourceTextEnglish:  String?,
              sourceTextChinese:  String?,
              species         : [String],
              flavours        : [String],
              natures         : [String],
              channels        : [FBChannel],
              notes           : [FBNote]
    ){
    
    self.name               = name
    self.id                 = id
    self.readOnly           = readOnly
    self.herbName           = herbName
    self.herbID             = herbID
    self.pinyin             = pinyin
    self.pinyinCode         = pinyinCode
    self.simplifiedChinese  = simplifiedChinese
    self.traditionalChinese = traditionalChinese
    self.preparation        = preparation
    self.englishCommons     = englishCommons
    self.latinNames         = latinNames
    self.sourceTextEnglish  = sourceTextEnglish
    self.sourceTextChinese  = sourceTextChinese
    self.species            = species
    self.flavours           = flavours
    self.natures            = natures
    self.channels           = channels
    self.notes              = notes
    
    
  }

}
  
  
  public func ==(lhs: FBAlternateHerb, rhs: FBAlternateHerb) -> Bool{
    
    return lhs.id == rhs.id && lhs.name == rhs.name
  }
