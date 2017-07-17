//
//  FBFormula.swift
//  Pods
//
//  Created by T. S. on 2016-12-20.
//
//

import RealmSwift

public class RealmFormula: RealmObject {
  
  public dynamic var textDate:                      String? = ""
  public dynamic var author:                        String? = ""
  public dynamic var preparedForm:                  String? = ""
  public dynamic var pinyinTon:                     String? = ""
  
  public let herbs = List<RealmHerb>()
  public let alternateHerbs = List<RealmAlternateHerb>()
  
  public func toFormula() -> FBFormula {
    
    return FBFormula(name: name,
                     id: id,
                     readOnly: readOnly,
                     favorite: favorite,
                     simplifiedChinese: simplifiedChinese,
                     traditionalChinese: traditionalChinese,
                     sourceTextEnglish: sourceTextEnglish,
                     sourceTextChinese: sourceTextChinese,
                     textDate: textDate,
                     author: author,
                     pinyinCode: pinyinCode,
                     pinyinTon: pinyinTon,
                     herbs: herbs.map{ $0.toHerb() },
                     alternateHerbs: alternateHerbs.map{ $0.toAlternateHerb()},
                     notes: notes.map{ $0.toNote() },
                     species: species.map{ $0.name },
                     flavours: flavours.map{ $0.name },
                     natures: natures.map{ $0.name },
                     channels: channels.map{ $0.toChannel() })
  }
}
