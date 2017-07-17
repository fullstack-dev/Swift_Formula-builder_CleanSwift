//
//  FBFormula.swift
//  Pods
//
//  Created by T. S. on 2017-01-27.
//
//

import Foundation

public struct FBFormula: Equatable {
  
  public var name: String
  public var id: String
  
  public var readOnly = false
  public var favorite = false

  
  public var simplifiedChinese:  String?
  public var traditionalChinese: String?
  public var sourceTextEnglish:  String?
  public var sourceTextChinese:  String?
  public var textDate: String?
  public var author: String?
  public var pinyinCode: String?
  public var pinyinTon: String?
  
  public var herbs           : [FBHerb]
  public var alternateHerbs  : [FBAlternateHerb]
  public var notes           : [FBNote]
  public var species         : [String]
  public var flavours        : [String]
  public var natures         : [String]
  public var channels        : [FBChannel]
  
  public init(name: String,
              id: String,
              readOnly: Bool,
              favorite: Bool,
              simplifiedChinese:  String?,
              traditionalChinese: String?,
              sourceTextEnglish:  String?,
              sourceTextChinese:  String?,
              textDate: String?,
              author: String?,
              pinyinCode: String?,
              pinyinTon: String?,
              herbs: [FBHerb],
              alternateHerbs: [FBAlternateHerb],
              notes: [FBNote],
              species: [String],
              flavours: [String],
              natures: [String],
              channels: [FBChannel]) {
    
    self.name                = name
    self.id                  = id
    self.readOnly            = readOnly
    self.favorite            = favorite
    self.simplifiedChinese   = simplifiedChinese
    self.traditionalChinese  = traditionalChinese
    self.sourceTextEnglish   = sourceTextEnglish
    self.sourceTextChinese   = sourceTextChinese
    self.textDate            = textDate
    self.author              = author
    self.pinyinCode          = pinyinCode
    self.pinyinTon           = pinyinTon
    self.herbs               = herbs
    self.alternateHerbs      = alternateHerbs
    self.notes               = notes
    self.species             = species
    self.flavours            = flavours
    self.natures             = natures
    self.channels            = channels
  }
  
}


public func ==(lhs: FBFormula, rhs: FBFormula) -> Bool{
  
  return lhs.id == rhs.id
}
