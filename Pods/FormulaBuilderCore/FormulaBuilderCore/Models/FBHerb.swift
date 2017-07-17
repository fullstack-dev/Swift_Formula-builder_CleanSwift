//
//  Herb.swift
//  Pods
//
//  Created by T. S. on 2017-01-26.
//
//

import Foundation

public struct FBHerb: Equatable {
  
  public var name: String
  public var id: String
  public var favorite = false
  public var readOnly = false
  
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
  public var alternateHerbs  : [FBAlternateHerb]
  public var preparations    : [FBPreparation]
  
  public init(name: String,
              id: String,
              favorite: Bool,
              readOnly: Bool,
              pinyin: String?,
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
              notes           : [FBNote],
              alternateHerbs  : [FBAlternateHerb],
              preparations    : [FBPreparation]
    ){
    
    self.name               = name
    self.id                 = id
    self.favorite           = favorite
    self.readOnly           = readOnly
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
    self.alternateHerbs     = alternateHerbs
    self.preparations       = preparations
  }
  
}

public func ==(lhs: FBHerb, rhs: FBHerb) -> Bool {
  
  return lhs.id == rhs.id
}
