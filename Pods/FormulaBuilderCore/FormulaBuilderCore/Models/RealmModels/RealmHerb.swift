//
//  Herb.swift
//  Pods
//
//  Created by T. S. on 2016-12-20.
//
//

import Foundation
import RealmSwift

public class RealmHerb: RealmObject {
  
  public dynamic var photo: NSData? = nil
  public let alternateHerbs = List<RealmAlternateHerb>()
  public let preparations    = List<RealmPreparation>()
  
  public func toHerb() -> FBHerb {
    
    return FBHerb(name: name,
                  id: id,
                  favorite: favorite,
                  readOnly: readOnly,
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
                  notes: notes.map{ $0.toNote() },
                  alternateHerbs: alternateHerbs.map{ $0.toAlternateHerb() },
                  preparations: preparations.map { $0.toPreparation() }
    )
    
  }
}



