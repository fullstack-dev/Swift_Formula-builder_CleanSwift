//
//  RealmObject.swift
//  Pods
//
//  Created by Yanhui Sang on 2017-02-05.
//
//

import RealmSwift

public class RealmObject: Object {
  
  public dynamic var name = ""
  public dynamic var id = ""
  public dynamic var favorite = false
  public dynamic var readOnly = false
  
  public dynamic var pinyin:             String? = ""
  public dynamic var pinyinCode:         String? = ""
  public dynamic var simplifiedChinese:  String? = ""
  public dynamic var traditionalChinese: String? = ""
  public dynamic var preparation:        String? = ""
  public dynamic var sourceTextEnglish:  String? = ""
  public dynamic var sourceTextChinese:  String? = ""
  
  public let species         = List<RealmSpecies>()
  public let flavours        = List<RealmFlavour>()
  public let natures         = List<RealmNature>()
  public let channels        = List<RealmChannel>()
  public let notes           = List<RealmNote>()
  public let englishCommons  = List<RealmEnglishCommon>()
  public let latinNames      = List<RealmLatinName>()
  
  override public static func primaryKey() -> String? {
    return "id"
  }
}
