//
//  RealmAlternateHerb.swift
//  Pods
//
//  Created by Ty Sang on 2017-03-18.
//
//

import RealmSwift

public class RealmAlternateHerb: Object {
  
  public dynamic var name = ""
  public dynamic var id = ""
  public dynamic var readOnly = false
  public dynamic var herbName = ""
  public dynamic var herbID: String? = ""
  
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
  public let englishCommons   = List<RealmEnglishCommon>()
  public let latinNames       = List<RealmLatinName>()
  
  override public static func primaryKey() -> String? {
    return "id"
  }
  
  public func toAlternateHerb() -> FBAlternateHerb{
    
    return FBAlternateHerb(name: name,
                           id: id,
                           readOnly: readOnly,
                           herbName: herbName,
                           herbID: herbID,
                           pinyin: pinyin,
                           pinyinCode: pinyinCode,
                           simplifiedChinese: simplifiedChinese,
                           traditionalChinese: traditionalChinese,
                           preparation: preparation,
                           englishCommons: englishCommons.map{ $0.name },
                           latinNames: latinNames.map{ $0.name },
                           sourceTextEnglish: sourceTextEnglish,
                           sourceTextChinese: sourceTextChinese,
                           species: species.map{ $0.name },
                           flavours: flavours.map{ $0.name },
                           natures: natures.map{ $0.name },
                           channels: channels.map{ $0.toChannel() },
                           notes: notes.map{ $0.toNote() })
  }
}

