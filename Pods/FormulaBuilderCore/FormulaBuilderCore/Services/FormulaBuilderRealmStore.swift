//
//  FormulaBuilderStore.swift
//  Pods
//
//  Created by T. S. on 2016-12-20.
//
//

import Foundation
import RealmSwift
import SwiftyJSON

public class FormulaBuilderRealmStore: PlumFlowerStoreProtocol {

  public static let store = FormulaBuilderRealmStore()
  
  var userRealm: Realm!
  
  public init() {
    
    let systemRealmURL = Realm.Configuration.defaultConfiguration.fileURL!.deletingLastPathComponent().appendingPathComponent("userData.realm")
//    print(systemRealmURL.absoluteString)
    if FileManager().fileExists(atPath: systemRealmURL.path) {
      let config = Realm.Configuration(fileURL: systemRealmURL , readOnly: false)
      userRealm = try! Realm(configuration: config)
    } else {
      let bundle = Bundle(for: FormulaBuilderRealmStore.self)
      let fPath = bundle.path(forResource: "FBCore", ofType: "bundle")
      let fBundle = Bundle(path: fPath!)!
      let url = fBundle.url(forResource: "system", withExtension:"realm")!
      
        do {
          try FileManager().copyItem(at: url, to: systemRealmURL)
          let config = Realm.Configuration(fileURL: systemRealmURL , readOnly: false)
          userRealm = try! Realm(configuration: config)
        } catch (let error) {
          print(error)
        }

     // FOR generating system realm
//      userRealm = try! Realm()
//      generateRealm()
    }
  }
  
  // MARK: Common
  
  private func deleteObject<T: Object>(ofType type: T.Type, withID id: String, completionHandler: @escaping (FBStoreError?) -> Void) {
    
    if let deleteObject = userRealm.object(ofType: type, forPrimaryKey: id) {
      
      do {
        try userRealm.write {
          userRealm.delete(deleteObject)
          completionHandler(nil)
        }
      } catch {
        completionHandler(FBStoreError.deleteError("Delete \(type.className()) error with id \(id)"))
      }
    } else {
      completionHandler(FBStoreError.deleteError("Object not exist"))
    }
  }
  
  
  public func deleteAll(completionHandler: (_ success: Bool) -> Void) {
    do {
      try userRealm.write {
        userRealm.deleteAll()
        completionHandler(true)
      }
    } catch {
      completionHandler(false)
    }
  }
  
  //  MARK: Advanced Search
  public func herbAdvancedSearch(latinName latinNameString: String?, species speciesArray: [String]?, flavours flavoursArray: [String]?, natures naturesArray:[String]?, sourceText sourceTextString: String?, channelIDs channelIDsArray:[String]?, completionHandler: @escaping (_ results: [String]) -> Void) {
    
    var formatPatterns = [String]()
    var keys = [String]()
    
    if latinNameString != nil && !latinNameString!.isEmpty {
      formatPatterns.append("latinNames.name CONTAINS %@")
      keys.append(latinNameString!)
    }
    
    if speciesArray != nil && speciesArray!.count > 0 {
      
      for s in speciesArray!{
        formatPatterns.append("%@ IN species.name")
        keys.append(s)
      }
    }
    
    if flavoursArray != nil && flavoursArray!.count > 0 {
      
      for f in flavoursArray!{
        formatPatterns.append("%@ IN flavours.name")
        keys.append(f)
      }
    }
    
    if naturesArray != nil && naturesArray!.count > 0 {
      
      for n in naturesArray!{
        formatPatterns.append("%@ IN natures.name")
        keys.append(n)
      }
    }
    
    if sourceTextString != nil && !sourceTextString!.isEmpty {
      formatPatterns.append("(sourceTextChinese CONTAINS %@ || sourceTextEnglish CONTAINS %@)")
      keys.append(sourceTextString!)
      keys.append(sourceTextString!)
    }
    
    if channelIDsArray != nil && channelIDsArray!.count > 0 {
      
      for channelID in channelIDsArray!{
        formatPatterns.append("ANY channels.id = %@")
        keys.append(channelID)
      }
    }
    
    var formatString = ""
    for (index, pattern) in formatPatterns.enumerated() {
      
      formatString += pattern
      
      if index < formatPatterns.count - 1 {
        formatString += " && "
      }
    }
    
    print("Format String: \(formatString)")
    print("Keys: \(keys)")
    
    if formatPatterns.count == 0 || keys.count == 0 {
      
      let allHerbs = userRealm.objects(RealmHerb.self)
      completionHandler(allHerbs.map{ $0.toHerb().id })
      
    } else {
      
      let predicate = NSPredicate(format: formatString, argumentArray: keys)
      let userResults = userRealm.objects(RealmHerb.self).filter(predicate)
      completionHandler(userResults.map{ $0.toHerb().id })
      
    }
  }
  
  public func formulaAdvancedSearch(pinyin pinyin: String?, chineseName chineseName: String?, sourceText sourceText: String?, author author: String?, completionHandler: @escaping (_ results: [String]) -> Void) {
  
    var formatPatterns = [String]()
    var keys = [String]()
    
    if pinyin != nil && !pinyin!.isEmpty {
      formatPatterns.append("name CONTAINS %@")
      keys.append(pinyin!)
    }
    
    if chineseName != nil && !chineseName!.isEmpty {
      formatPatterns.append("simplifiedChinese CONTAINS %@ || traditionalChinese CONTAINS %@")
      keys.append(chineseName!)
      keys.append(chineseName!)
    }
    
    if sourceText != nil && !sourceText!.isEmpty {
      formatPatterns.append("sourceTextEnglish CONTAINS %@ || sourceTextChinese CONTAINS %@")
      keys.append(sourceText!)
      keys.append(sourceText!)
    }
    
    if author != nil && !author!.isEmpty {
      formatPatterns.append("author CONTAINS %@")
      keys.append(author!)
    }
    
    var formatString = ""
    for (index, pattern) in formatPatterns.enumerated() {
      
      formatString += pattern
      
      if index < formatPatterns.count - 1 {
        formatString += " && "
      }
    }
    
    print("Format String: \(formatString)")
    print("Keys: \(keys)")
    
    if formatPatterns.count == 0 || keys.count == 0 {
      
      let allHerbs = userRealm.objects(RealmFormula.self)
      completionHandler(allHerbs.map{ $0.toFormula().id })
      
    } else {
      
      let predicate = NSPredicate(format: formatString, argumentArray: keys)
      let userResults = userRealm.objects(RealmFormula.self).filter(predicate)
      completionHandler(userResults.map{ $0.toFormula().id })
      
    }
  }
  
  private func generateRealm() {
    
    // generate channels
    
    let bundle = Bundle(for: FormulaBuilderRealmStore.self)
    let fPath = bundle.path(forResource: "FBCore", ofType: "bundle")
    let fBundle = Bundle(path: fPath!)!
    
    let path = fBundle.path(forResource: "Channels", ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
    let channelJSON = JSON(data: data)
    
    for channelJSON in channelJSON.arrayValue {
    
      let channel = RealmChannel()
      channel.id = NSUUID().uuidString
      channel.chineseName = channelJSON["chinese"].stringValue
      channel.englishName = channelJSON["english"].stringValue
      channel.iconName = channelJSON["icon"].stringValue
      
      try! userRealm.write {
        userRealm.add(channel)
      }
    }
    
    
    if let path = fBundle.path(forResource: "Herbs", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        let herbsJSON = JSON(data: data)
        if herbsJSON != JSON.null {
          for herbJSON in herbsJSON.arrayValue {
            
            var speciesArray = [String]()
            for species in herbJSON["species"].arrayObject! {
              
              if let speciesString = species as? String, speciesString != ""{
                speciesArray.append(speciesString)
              }
            }
            
            var flavoursArray = [String]()
            for flavour in herbJSON["flavours"].arrayValue {
              
              if let flavourString = flavour.string, flavourString != "" {
                flavoursArray.append(flavourString)
              }
            }
            
            var naturesArray = [String]()
            for nature in herbJSON["natures"].arrayValue {
              
              if let natureString = nature.string, natureString != "" {
                naturesArray.append(natureString)
              }
            }
            
            var englishCommonsArray = [String]()
            for englishCommon in herbJSON["englishCommons"].arrayValue {
              
              if let englishCommonString = englishCommon.string, englishCommonString != "" {
                englishCommonsArray.append(englishCommonString)
              }
            }
            
            var latinNamesArray = [String]()
            for latinName in herbJSON["latinNames"].arrayValue {
              
              if let latinNameString = latinName.string, latinNameString != "" {
                latinNamesArray.append(latinNameString)
              }
            }
            
            var preparationsArray = [FBPreparation]()
            for preparation in herbJSON["preparations"].arrayValue {
              if let preparationString = preparation.string, preparationString != "" {
                
                let preparation = FBPreparation(id: NSUUID().uuidString, name: nil, content: preparationString)
                preparationsArray.append(preparation)
              }
            }
            
            

            var channelsArray = [FBChannel]()
            for englishChannel in herbJSON["englishChannels"].arrayValue {
              
              if let channelString = englishChannel.string, channelString != "" {
                
                let results = userRealm.objects(RealmChannel.self).filter("englishName = %@", channelString)
                
                if results.count > 0 {
                  
                  channelsArray.append(results.first!.toChannel())
                }
              }
            }
            
            // Alternate Herb
            if herbJSON["alternateName"].stringValue != "" {
              
              let preparation = preparationsArray.count > 0 ? preparationsArray.first!.content : nil
              let alternateHerb = FBAlternateHerb(name: herbJSON["alternateName"].stringValue,
                                                  id: nil,
                                                  readOnly: true,
                                                  herbName: herbJSON["herbName"].stringValue,
                                                  herbID: nil,
                                                  pinyin: herbJSON["herbPinyin"].string,
                                                  pinyinCode: herbJSON["herbPinyin"].string,
                                                  simplifiedChinese: herbJSON["simplifiedChinese"].string,
                                                  traditionalChinese: herbJSON["traditionalChinese"].string,
                                                  preparation: preparation,
                                                  englishCommons: englishCommonsArray,
                                                  latinNames: latinNamesArray,
                                                  sourceTextEnglish: herbJSON["sourceTextEnglish"].string,
                                                  sourceTextChinese: herbJSON["sourceTextChinese"].string,
                                                  species: speciesArray,
                                                  flavours: flavoursArray,
                                                  natures: naturesArray,
                                                  channels: channelsArray,
                                                  notes: [])
              
              saveAlternateHerb(alternateHerb, completionHandler: { (_, _) in
                
              })
              
            } else {
              
              let herb = FBHerb(name: herbJSON["herbName"].stringValue,
                                id: "",
                                favorite: false,
                                readOnly: true,
                                pinyin: herbJSON["herbPinyin"].string,
                                pinyinCode: herbJSON["herbPinyin"].string,
                                simplifiedChinese: herbJSON["simplifiedChinese"].string,
                                traditionalChinese: herbJSON["traditionalChinese"].string,
                                preparation: herbJSON["preparation"].string,
                                englishCommons: englishCommonsArray,
                                latinNames: latinNamesArray,
                                sourceTextEnglish: herbJSON["sourceTextEnglish"].string,
                                sourceTextChinese: herbJSON["sourceTextChinese"].string,
                                species: speciesArray,
                                flavours: flavoursArray,
                                natures: naturesArray,
                                channels: channelsArray,
                                notes: [],
                                alternateHerbs: [],
                                preparations: preparationsArray)
              
              
              
              saveHerb(.create, herb, completionHandler: { (error) in
                
              })
            }
            
            
          }
        } else {
          print("Could not get json from file, make sure that file contains valid json.")
        }
      } catch let error {
        print(error.localizedDescription)
      }
    } else {
      print("Invalid filename/path.")
    }
    
    self.fetchHerbs(withFilter: .all, completionHandler: { (herbs) in
        
        let category = FBCategory(id: "", timestamp: NSDate().timeIntervalSinceNow, name: "All Herbs", categoryType: .herb, itemIDs: herbs.map { $0.id }, readOnly: true)
        self.saveCategory(.create, category) { (error) in
            
        }
    })
    
    self.fetchAlternateHerbs { (alternateHerbs) in
      
      for alternateHerb in alternateHerbs {
        
        self.searchHerb(keyword: alternateHerb.herbName, completionHandler: { (herbs) in
          
          var updateHerb = herbs.first!
          updateHerb.alternateHerbs.append(alternateHerb)
          self.saveHerb(.update, updateHerb, completionHandler: { (error) in
            
          })
        })
      }
    }
    
    if let path = fBundle.path(forResource: "Formulas", ofType: "json") {
      
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        let formulasJSON = JSON(data: data)
        
        if formulasJSON != JSON.null {
          fetchHerbs(withFilter: .all, completionHandler: { (herbs) in
            
            for formulaJSON in formulasJSON.arrayValue {
              
              var herbsArray = [FBHerb]()
              var alternateHerbsArray = [FBAlternateHerb]()
              
              for herbName in formulaJSON["herbs"].arrayObject! {
                
                if (herbName as! String) != "" {
                  
                  let results = herbs.filter({ (item) -> Bool in
                    return item.name.lowercased() == (herbName as! String).lowercased() && item.name != ""
                  })
                  
                  if results.count == 0 {
                    
                    self.fetchAlternateHerbs(completionHandler: { (alternateHerbs) in
                      
                      let alternateHerbResults = alternateHerbs.filter({ (alternateHerb) -> Bool in
                        
                        return alternateHerb.name.lowercased() == (herbName as! String).lowercased()
                      })
                      
                      if alternateHerbResults.count > 0 {
                        alternateHerbsArray.append(alternateHerbResults.first!)
                      } else {
                        // not exist
                      }
                    })
                    
                  } else {
                    herbsArray.append(results.first!)
                  }
                }
              }
              let formulaName = formulaJSON["formula"].stringValue
              
              let formula = FBFormula(name: formulaName,
                                      id: "",
                                      readOnly: true,
                                      favorite: false,
                                      simplifiedChinese: formulaJSON["simplifiedChinese"].string,
                                      traditionalChinese: formulaJSON["traditionalChinese"].string,
                                      sourceTextEnglish: formulaJSON["sourceTextEnglish"].string,
                                      sourceTextChinese: formulaJSON["sourceTextTraditionalChinese"].string,
                                      textDate: formulaJSON["textDate"].string,
                                      author: formulaJSON["author"].string,
                                      pinyinCode: formulaJSON["pinyinCode"].string,
                                      pinyinTon: formulaJSON["pinyinTones"].string,
                                      herbs: herbsArray,
                                      alternateHerbs: alternateHerbsArray,
                                      notes: [],
                                      species: [],
                                      flavours: [],
                                      natures:[],
                                      channels:[]
              )
              
              self.saveFormula(.create, formula, completionHandler: { (error) in

              })
            }
          })
          
        } else {
          print("Could not get json from file, make sure that file contains valid json.")
        }
      } catch let error {
        print(error.localizedDescription)
      }
    } else {
      print("Invalid filename/path.")
    }

    self.fetchFormulas(withFilter: .all, completionHandler: { (formulas) in
        
        let category = FBCategory(id: "", timestamp: NSDate().timeIntervalSinceNow, name: "All Formulas", categoryType: .formula, itemIDs: formulas.map{ $0.id }, readOnly: true)
        self.saveCategory(.create, category) { (error) in
            
        }
    })
  }

  
  // iCloud
  public func iCloudSync(completionHandler: @escaping (_ success: Bool, _ error: FBStoreError?) -> Void) {
    
    let realmURL = userRealm.configuration.fileURL!
    
    print(realmURL)
    
    let fileManager = FileManager.default
    
    var ubiquityURL = fileManager.url(forUbiquityContainerIdentifier:nil)
    
    if ubiquityURL != nil {
      
      ubiquityURL = ubiquityURL?.appendingPathComponent("Documents/userData.realm")
      
      do {
        try fileManager.setUbiquitous(true, itemAt: realmURL, destinationURL: ubiquityURL!)
        completionHandler(true, nil)
      } catch (let error) {
        
        print("Save fails: \(error)")
        completionHandler(false, FBStoreError.syncError("Sync Error"))
      }
      
    } else {
      
      completionHandler(false, FBStoreError.syncError("Unable to access iCloud Account"))
    }
  }
  
  // MARK: Update Favorite
  public func changeFavorite(_ toType: ToType, _ id: String, completionHandler: @escaping (_ error: FBStoreError?) -> Void) {
    
    if toType == .herb {
      
      let herb = userRealm.object(ofType: RealmHerb.self, forPrimaryKey: id)!
      do {
        try userRealm.write {
          herb.favorite = !herb.favorite
          completionHandler(nil)
        }
      } catch {
        completionHandler(FBStoreError.updateError("Update Favorite Error"))
      }
    } else {
      
      let formula = userRealm.object(ofType: RealmFormula.self, forPrimaryKey: id)!
      do {
        try userRealm.write {
          formula.favorite = !formula.favorite
          completionHandler(nil)
        }
      } catch {
        completionHandler(FBStoreError.updateError("Update Favorite Error"))
      }
    }
  }
  
  // MARK: Herbs
  /**
   Fetch all Herbs
   @param nil
   @return Array of Herbs
   */
  public func fetchHerbs(withFilter filter: FetchFilter, completionHandler: @escaping (_ herbs: [FBHerb]) -> Void) {
    
    let herbs = userRealm.objects(RealmHerb.self)
    
    
    switch filter {
    case .all:
      completionHandler(herbs.map{ $0.toHerb() })
      
    case .favorite:
      let results = herbs.filter({ (herb) -> Bool in
        
        return herb.favorite
      })
      
      completionHandler(results.map{ $0.toHerb() })
      
    case .notFavorite:
      let results = herbs.filter({ (herb) -> Bool in
        
        return !herb.favorite
      })
      
      completionHandler(results.map{ $0.toHerb() })
    }
    
  }
  
  /**
   Fetch single Herb
   @param herbID (String)
   @return Array of Herbs
   */
  public func fetchHerb(withID: String, completionHandler: @escaping (FBHerb?, FBStoreError?) -> Void) {
    
    if let herb = userRealm.object(ofType: RealmHerb.self, forPrimaryKey: withID) {
      completionHandler(herb.toHerb(), nil)
    } else {
      completionHandler(nil, FBStoreError.fetchError("Fetch herb error with id \(withID)"))
    }
  }
  
  /**
   Save herb
   @param Herb
   @return FBStoreError?
   */
  public func saveHerb(_ saveType: SaveType, _ herb: FBHerb, completionHandler: @escaping (FBStoreError?) -> Void) {
    
    let newHerb = RealmHerb()
    newHerb.name = herb.name
    newHerb.id = saveType == .create ? NSUUID().uuidString : herb.id
    newHerb.readOnly = herb.readOnly
    newHerb.favorite = herb.favorite
    newHerb.pinyin = herb.pinyin
    newHerb.pinyinCode = herb.pinyinCode
    newHerb.simplifiedChinese = herb.simplifiedChinese
    newHerb.traditionalChinese = herb.traditionalChinese
    newHerb.preparation = herb.preparation
    newHerb.sourceTextChinese = herb.sourceTextChinese
    newHerb.sourceTextEnglish = herb.sourceTextEnglish
    
    let spcies          = List<RealmSpecies>()
    let flavours        = List<RealmFlavour>()
    let natures         = List<RealmNature>()
    let channels        = List<RealmChannel>()
    let notes           = List<RealmNote>()
    let alternateHerbs  = List<RealmAlternateHerb>()
    let preparations    = List<RealmPreparation>()
    let englishCommons  = List<RealmEnglishCommon>()
    let latinNames      = List<RealmLatinName>()
    
    for name in herb.species {
      
      let results = userRealm.objects(RealmSpecies.self).filter("name = %@", name)
      
      if results.count > 0{
        
        spcies.append(results.first!)
      } else {
        let newSpcies = RealmSpecies()
        newSpcies.id = NSUUID().uuidString
        newSpcies.name = name
        spcies.append(newSpcies)
      }
    }
    
    for name in herb.flavours {
      
      let results = userRealm.objects(RealmFlavour.self).filter("name = %@", name)
      
      if results.count > 0{
        
        flavours.append(results.first!)
      } else {
        let newFlavour = RealmFlavour()
        newFlavour.id = NSUUID().uuidString
        newFlavour.name = name
        flavours.append(newFlavour)
      }
    }
    
    
    
    for preparation in herb.preparations {
      if let p_id = preparation.id, let result = userRealm.object(ofType: RealmPreparation.self, forPrimaryKey: p_id) {
        
        preparations.append(result)
      } else {
        let newPreparation = RealmPreparation()
        newPreparation.id = preparation.id ?? NSUUID().uuidString
        newPreparation.name = preparation.name
        newPreparation.content = preparation.content
        preparations.append(newPreparation)
      }
    }
    
    for name in herb.natures {
      
      let results = userRealm.objects(RealmNature.self).filter("name = %@", name)
      
      if results.count > 0{
        
        natures.append(results.first!)
      } else {
        let newNature = RealmNature()
        newNature.id = NSUUID().uuidString
        newNature.name = name
        natures.append(newNature)
      }
    }
    
    for channel in herb.channels {
      
      let results = userRealm.objects(RealmChannel.self).filter("id = %@", channel.id)
      
      if results.count > 0{
        
        channels.append(results.first!)
      } else {
        
      }
    }
    
    for englishCommon in herb.englishCommons {
      let results = userRealm.objects(RealmEnglishCommon.self).filter("name = %@", englishCommon)
      
      if results.count > 0 {
        englishCommons.append(results.first!)
      } else {
        let newEnglishCommon = RealmEnglishCommon()
        newEnglishCommon.id = NSUUID().uuidString
        newEnglishCommon.name = englishCommon
        englishCommons.append(newEnglishCommon)
      }
    }
    
    for latinName in herb.latinNames {
      let results = userRealm.objects(RealmLatinName.self).filter("name = %@", latinName)
      
      if results.count > 0 {
        latinNames.append(results.first!)
      } else {
        let newLatinName = RealmLatinName()
        newLatinName.id = NSUUID().uuidString
        newLatinName.name = latinName
        latinNames.append(newLatinName)
      }
    }
    

    
    for note in herb.notes {
      
      if let existNote = userRealm.object(ofType: RealmNote.self, forPrimaryKey: note.id) {
        
        notes.append(existNote)
      } else {
        // should not reach
      }
    }
    
    for alternateHerb in herb.alternateHerbs {
      
      self.saveAlternateHerb(alternateHerb, completionHandler: { (alternateHerb, error) in
        
        if alternateHerb != nil {
          
          alternateHerbs.append(alternateHerb!)
        }
      })
      
    }
    
    newHerb.species.append(objectsIn: spcies)
    newHerb.flavours.append(objectsIn: flavours)
    newHerb.natures.append(objectsIn: natures)
    newHerb.channels.append(objectsIn: channels)
    newHerb.notes.append(objectsIn: notes)
    newHerb.alternateHerbs.append(objectsIn: alternateHerbs)
    newHerb.preparations.append(objectsIn: preparations)
    newHerb.englishCommons.append(objectsIn: englishCommons)
    newHerb.latinNames.append(objectsIn: latinNames)
    
    do {
      try userRealm.write {
        
        userRealm.add(newHerb, update: true)
        completionHandler(nil)
      }
    } catch {
      completionHandler(FBStoreError.createError("Save Herb error with id \(newHerb.id)"))
    }
    
  }
  
  /**
   Delete herb
   @param Herb
   @return FBStoreError?
   */
  public func deleteHerb(withID id: String, completionHandler: @escaping (FBStoreError?) -> Void) {
    
    deleteObject(ofType: RealmHerb.self, withID: id) { (error) in
      completionHandler(error)
    }
  }
  
  /**
   Search herb
   @param keyword (String)
   @return FBStoreError?
   */
  
  public func searchHerb(keyword: String, completionHandler: @escaping ([FBHerb]) -> Void) {
    
    let herbs = userRealm.objects(RealmHerb.self).filter("name CONTAINS %@", keyword)
    completionHandler(herbs.toArray().map{ $0.toHerb() })
  }
  
  // MARK: FBAlternateHerb
  public func fetchAlternateHerbs(completionHandler: @escaping (_ alternateHerbs: [FBAlternateHerb]) -> Void) {
    
    let alternateHerbs = userRealm.objects(RealmAlternateHerb.self)
    completionHandler(alternateHerbs.map{ $0.toAlternateHerb()})
  }
  
  public func saveAlternateHerb(_ alternateHerb: FBAlternateHerb, completionHandler: @escaping (_ alternateHerb: RealmAlternateHerb?, _ error: FBStoreError?) -> Void) {
    
    let newAlternateHerb = RealmAlternateHerb()
    newAlternateHerb.name = alternateHerb.name
    newAlternateHerb.id = alternateHerb.id ?? NSUUID().uuidString
    newAlternateHerb.herbName = alternateHerb.herbName
    newAlternateHerb.herbID = alternateHerb.herbID
    newAlternateHerb.readOnly = alternateHerb.readOnly
    newAlternateHerb.pinyin = alternateHerb.pinyin
    newAlternateHerb.pinyinCode = alternateHerb.pinyinCode
    newAlternateHerb.simplifiedChinese = alternateHerb.simplifiedChinese
    newAlternateHerb.traditionalChinese = alternateHerb.traditionalChinese
    newAlternateHerb.preparation = alternateHerb.preparation
    newAlternateHerb.sourceTextChinese = alternateHerb.sourceTextChinese
    newAlternateHerb.sourceTextEnglish = alternateHerb.sourceTextEnglish
    
    let spcies          = List<RealmSpecies>()
    let flavours        = List<RealmFlavour>()
    let natures         = List<RealmNature>()
    let channels        = List<RealmChannel>()
    let englishCommons  = List<RealmEnglishCommon>()
    let latinNames      = List<RealmLatinName>()
    
    for name in alternateHerb.species {
      
      let results = userRealm.objects(RealmSpecies.self).filter("name = %@", name)
      
      if results.count > 0{
        
        spcies.append(results.first!)
      } else {
        let newSpcies = RealmSpecies()
        newSpcies.id = NSUUID().uuidString
        newSpcies.name = name
        spcies.append(newSpcies)
      }
    }
    
    for name in alternateHerb.flavours {
      
      let results = userRealm.objects(RealmFlavour.self).filter("name = %@", name)
      
      if results.count > 0{
        
        flavours.append(results.first!)
      } else {
        let newFlavour = RealmFlavour()
        newFlavour.id = NSUUID().uuidString
        newFlavour.name = name
        flavours.append(newFlavour)
      }
    }
    
    for name in alternateHerb.natures {
      
      let results = userRealm.objects(RealmNature.self).filter("name = %@", name)
      
      if results.count > 0{
        
        natures.append(results.first!)
      } else {
        let newNature = RealmNature()
        newNature.id = NSUUID().uuidString
        newNature.name = name
        natures.append(newNature)
      }
    }
    
    for channel in alternateHerb.channels {
      
      let results = userRealm.objects(RealmChannel.self).filter("id = %@", channel.id)
      
      if results.count > 0{
        
        channels.append(results.first!)
      } else {
        
      }
    }
    
    for englishCommon in alternateHerb.englishCommons {
      let results = userRealm.objects(RealmEnglishCommon.self).filter("name = %@", englishCommon)
      
      if results.count > 0 {
        englishCommons.append(results.first!)
      } else {
        let newEnglishCommon = RealmEnglishCommon()
        newEnglishCommon.id = NSUUID().uuidString
        newEnglishCommon.name = englishCommon
        englishCommons.append(newEnglishCommon)
      }
    }
    
    for latinName in alternateHerb.latinNames {
      let results = userRealm.objects(RealmLatinName.self).filter("name = %@", latinName)
      
      if results.count > 0 {
        latinNames.append(results.first!)
      } else {
        let newLatinName = RealmLatinName()
        newLatinName.id = NSUUID().uuidString
        newLatinName.name = latinName
        latinNames.append(newLatinName)
      }
    }

    
    newAlternateHerb.species.append(objectsIn: spcies)
    newAlternateHerb.flavours.append(objectsIn: flavours)
    newAlternateHerb.natures.append(objectsIn: natures)
    newAlternateHerb.channels.append(objectsIn: channels)
    newAlternateHerb.englishCommons.append(objectsIn: englishCommons)
    newAlternateHerb.latinNames.append(objectsIn: latinNames)
    do {
      try userRealm.write {
        
        userRealm.add(newAlternateHerb, update: true)
        completionHandler(newAlternateHerb, nil)
      }
    } catch {
      completionHandler(nil, FBStoreError.createError("Save Herb error with id \(newAlternateHerb.id)"))
    }
  }
  
  public func deleteAlternateHerb(withID id: String, completionHandler: @escaping (FBStoreError?) -> Void) {
    
    deleteObject(ofType: RealmAlternateHerb.self, withID: id) { (error) in
      completionHandler(error)
    }
  }
  
  // MARK: FBFormulas
  
  /**
   Fetch all formulas
   @param nil
   @return FBStoreError?
   */
  
  public func fetchFormulas(withFilter filter: FetchFilter, completionHandler: @escaping ([FBFormula]) -> Void) {
    
    let formulas = userRealm.objects(RealmFormula.self)
    
    switch filter {
    case .all:
      completionHandler(formulas.map{ $0.toFormula() })
      
    case .favorite:
      let results = formulas.filter({ (formula) -> Bool in
        
        return formula.favorite
      })
      
      completionHandler(results.map{ $0.toFormula() })
      
    case .notFavorite:
      let results = formulas.filter({ (formula) -> Bool in
        
        return !formula.favorite
      })
      
      completionHandler(results.map{ $0.toFormula() })
    }
    
  }
  
  /**
   Fetch all formulas base on HerbID
   @param nil
   @return FBStoreError?
   */
  public func fetchFormulas(withHerbID herbID: String, completionHandler: @escaping (_ formulas: [FBFormula]) -> Void) {
    
    let formulas = userRealm.objects(RealmFormula.self)
    
    let results = formulas.filter({ (formula) -> Bool in
      return formula.herbs.contains(where: { (herb) -> Bool in
        herb.id == herbID
      })
    })
    completionHandler(results.map{ $0.toFormula() })
    
  }
  
  /**
   Fetch single formula
   @param formulaID (String)
   @return FBStoreError?
   */
  public func fetchFormula(withID id: String, _ completionHandler: @escaping (FBFormula?, FBStoreError?) -> Void) {
    if let formula = userRealm.object(ofType: RealmFormula.self, forPrimaryKey: id) {
      completionHandler(formula.toFormula(), nil)
    } else {
      completionHandler(nil, FBStoreError.fetchError("Fetch formula error"))
    }
  }
  
  /**
   Save formula
   @param formula
   @return FBStoreError?
   */
  public func saveFormula(_ saveType: SaveType, _ formula: FBFormula, completionHandler: @escaping (FBStoreError?) -> Void) {
    
    let newFormula = RealmFormula()
    newFormula.name = formula.name
    newFormula.id   = saveType == .create ? NSUUID().uuidString : formula.id
    newFormula.readOnly = formula.readOnly
    newFormula.favorite = formula.favorite
    newFormula.simplifiedChinese = formula.simplifiedChinese
    newFormula.traditionalChinese = formula.traditionalChinese
    newFormula.sourceTextEnglish = formula.sourceTextEnglish
    newFormula.sourceTextChinese = formula.sourceTextChinese
    newFormula.textDate          = formula.textDate
    newFormula.author            = formula.author
    newFormula.pinyinCode        = formula.pinyinCode
    newFormula.pinyinTon         = formula.pinyinTon
    
    if formula.herbs.count > 0 {
      for herb in formula.herbs {
        //  If the herb exist in the systems
        if let herb = userRealm.object(ofType: RealmHerb.self, forPrimaryKey: herb.id) {
          newFormula.herbs.append(herb)
        } else {
          // Herb has to exist in the system before adding to the formula
        }
      }
    }
    
    if formula.alternateHerbs.count > 0 {
      for alternateHerb in formula.alternateHerbs {
        //  If the herb exist in the systems
        if let result = userRealm.object(ofType: RealmAlternateHerb.self, forPrimaryKey: alternateHerb.id) {
          newFormula.alternateHerbs.append(result)
        } else {
          // Herb has to exist in the system before adding to the formula
        }
      }
    }
    
    let spcies          = List<RealmSpecies>()
    let flavours        = List<RealmFlavour>()
    let natures         = List<RealmNature>()
    let channels        = List<RealmChannel>()
    let notes           = List<RealmNote>()
    
    
    for name in formula.species {
      
      let results = userRealm.objects(RealmSpecies.self).filter("name = %@", name)
      
      if results.count > 0{
        
        spcies.append(results.first!)
      } else {
        let newSpcies = RealmSpecies()
        newSpcies.id = NSUUID().uuidString
        newSpcies.name = name
        spcies.append(newSpcies)
      }
    }
    
    for name in formula.flavours {
      
      let results = userRealm.objects(RealmFlavour.self).filter("name = %@", name)
      
      if results.count > 0{
        
        flavours.append(results.first!)
      } else {
        let newFlavour = RealmFlavour()
        newFlavour.id = NSUUID().uuidString
        newFlavour.name = name
        flavours.append(newFlavour)
      }
    }
    
    for name in formula.natures {
      
      let results = userRealm.objects(RealmNature.self).filter("name = %@", name)
      
      if results.count > 0{
        
        natures.append(results.first!)
      } else {
        let newNature = RealmNature()
        newNature.id = NSUUID().uuidString
        newNature.name = name
        natures.append(newNature)
      }
    }
    
    for channel in formula.channels {
      
      let results = userRealm.objects(RealmChannel.self).filter("id = %@", channel.id)
      
      if results.count > 0{
        
        channels.append(results.first!)
      }
    }
    
    for note in formula.notes {
      
      if let existNote = userRealm.object(ofType: RealmNote.self, forPrimaryKey: note.id) {
        
        notes.append(existNote)
      } else {
        // should not reach
      }
    }
    
    newFormula.species.append(objectsIn: spcies)
    newFormula.flavours.append(objectsIn: flavours)
    newFormula.natures.append(objectsIn: natures)
    newFormula.channels.append(objectsIn: channels)
    newFormula.notes.append(objectsIn: notes)
    
    do {
      try userRealm.write {
        userRealm.add(newFormula, update: true)
        completionHandler(nil)
      }
    } catch {
      completionHandler(FBStoreError.createError("Save Formula error with id \(formula.id)"))
    }
  }
  
  /**
   Delete formula
   @param FBFormula
   @return FBStoreError?
   */
  public func deleteFormula(withID id: String, completionHandler: @escaping (FBStoreError?) -> Void) {
    deleteObject(ofType: RealmFormula.self, withID: id) { (error) in
      completionHandler(error)
    }
  }
  
  /**
   Search formula
   @param keyword (String)
   @return FBStoreError?
   */
  public func searchFormula(keyword: String, completionHandler: @escaping ([FBFormula]) -> Void) {
    
    let formulas = userRealm.objects(RealmFormula.self).filter("name CONTAINS %@", keyword)
    completionHandler(formulas.toArray().map{ $0.toFormula() })
  }
  
  
  // MARK: Recent
  public func fetchRecentRecords(withType type: RecentRecordType, completionHandler: @escaping (_ recents: [FBRecent]) -> Void) {
    
    let records = userRealm.objects(RealmRecent.self)
    
    
    switch type {
    case .all:
      completionHandler(records.map{ $0.toRecent() })
    case .herb:
      completionHandler(records.filter({ (recent) -> Bool in
        recent.recordType == RecentRecordType.herb.rawValue
      }).map{ $0.toRecent() })
    case .formula:
      completionHandler(records.filter({ (recent) -> Bool in
        recent.recordType == RecentRecordType.formula.rawValue
      }).map{ $0.toRecent() })
    }
    
  }
  
  public func createRecentRecord(_ recent: FBRecent, completionHandler: @escaping (_ error: FBStoreError?) -> Void) {
    
    let recentRecord = RealmRecent()
    recentRecord.timestamp = recent.timestamp
    recentRecord.id = NSUUID().uuidString
    recentRecord.recordID = recent.recordID
    recentRecord.recordType = recent.recordType.rawValue
    
    do {
      try userRealm.write {
        userRealm.add(recentRecord, update: true)
        completionHandler(nil)
      }
    } catch {
      completionHandler(FBStoreError.createError("Create Recent Item error with id \(recent.recordID)"))
    }
  }
  
  public func deleteRecentRecord(withID id: String, completionHandler: @escaping (_ error: FBStoreError?) -> Void) {
    deleteObject(ofType: RealmRecent.self, withID: id) { (error) in
      completionHandler(error)
    }
  }
  
  // MARK: Category
  public func fetchCategories(categoryType categroyType: CategoryType, completionHandler: @escaping (_ categories: [FBCategory]) -> Void) {
    
    if categroyType == CategoryType.herb {
      
      let categories = userRealm.objects(RealmHerbCategory.self)
      completionHandler(categories.map{ $0.toCategory() })
      
    } else {
      
      let categories = userRealm.objects(RealmFormulaCategory.self)
      completionHandler(categories.map{ $0.toCategory() })
    }
  }
  
  public func saveCategory(_ saveType: SaveType, _ category: FBCategory, completionHandler: @escaping (_ category: FBCategory?, _ error: FBStoreError?) -> Void) {
    
    if category.categoryType == CategoryType.herb {
      
      let newCategory = RealmHerbCategory()
      newCategory.name = category.name
      newCategory.id = saveType == .create ? NSUUID().uuidString : category.id
      newCategory.categoryType = category.categoryType.hashValue
      newCategory.readOnly = category.readOnly
      
      if category.itemIDs.count > 0 {
        
        for itemID in category.itemIDs {
          
          if let realmHerb = userRealm.object(ofType: RealmHerb.self, forPrimaryKey: itemID) {
            
            newCategory.herbs.append(realmHerb)
          } else {
            // shouldn't reach
          }
        }
      }
      
      do {
        try userRealm.write {
          userRealm.add(newCategory, update: true)
          completionHandler(newCategory.toCategory(), nil)
        }
      } catch {
        completionHandler(nil, FBStoreError.createError("Create HerbCategory error with id \(newCategory.id)"))
      }
      
    } else {
      
      let newCategory = RealmFormulaCategory()
      newCategory.name = category.name
      newCategory.id = saveType == .create ? NSUUID().uuidString : category.id
      newCategory.categoryType = category.categoryType.hashValue
      newCategory.readOnly = category.readOnly
      
      if category.itemIDs.count > 0 {
        
        for itemID in category.itemIDs {
          
          if let realmHerb = userRealm.object(ofType: RealmFormula.self, forPrimaryKey: itemID) {
            
            newCategory.formulas.append(realmHerb)
          } else {
            // shouldn't reach
          }
        }
      }
      do {
        try userRealm.write {
          userRealm.add(newCategory, update: true)
          completionHandler(newCategory.toCategory(), nil)
        }
      } catch {
        completionHandler(nil, FBStoreError.createError("Create HerbCategory error with id \(newCategory.id)"))
      }
    }
  }
 
  public func deleteHerbCategory(categoryID id: String, completionHandler: @escaping (_ error: FBStoreError?) -> Void) {
    deleteObject(ofType: RealmHerbCategory.self, withID: id, completionHandler: { (error) in
      completionHandler(error)
    })
  }
  public func deleteFormulaCategory(categoryID id: String, completionHandler: @escaping (_ error: FBStoreError?) -> Void) {
    deleteObject(ofType: RealmFormulaCategory.self, withID: id, completionHandler: { (error) in
      completionHandler(error)
    })
  }
  
  
  // MARK: Note
  public func fetchNotes(withID id: String, completionHandler: @escaping (_ notes: [FBNote]) -> Void) {
    
    let notes = userRealm.objects(RealmNote.self)
    completionHandler(notes.map{ $0.toNote() })
  }
  
  public func addNote(to toType: ToType, toID id: String, with note: FBNote, completionHandler: @escaping (_ error: FBStoreError?) -> Void) {
    let newNote = RealmNote()
    newNote.id = NSUUID().uuidString
    newNote.title = note.title
    newNote.content = note.content
    newNote.createdTimestamp = note.createdTimestamp
    
    if toType == .herb {
      
      var existHerb = userRealm.object(ofType: RealmHerb.self, forPrimaryKey: id)!.toHerb()
      existHerb.notes.append(newNote.toNote())
      
      do {
        try userRealm.write {
          userRealm.add(newNote, update: true)
          
        }
      } catch {
        completionHandler(FBStoreError.createError("Create Note error"))
      }
      
      
      self.saveHerb(.update, existHerb, completionHandler: { (error) in
        completionHandler(error)
      })
      
    } else {
      var existFormula = userRealm.object(ofType: RealmFormula.self, forPrimaryKey: id)!.toFormula()
      existFormula.notes.append(newNote.toNote())
      
      do {
        try userRealm.write {
          userRealm.add(newNote, update: true)
        }
      } catch {
        completionHandler(FBStoreError.createError("Create Note error"))
      }
      
      self.saveFormula(.update, existFormula, completionHandler: { (error) in
        completionHandler(error)
      })
    }
  }
  
  public func updateNote(_ note: FBNote, completionHandler: @escaping (_ error: FBStoreError?) -> Void) {
    let updateNote = RealmNote()
    updateNote.title = note.title
    updateNote.content = note.content
    updateNote.id = note.id
    updateNote.createdTimestamp = note.createdTimestamp
    updateNote.modifiedTimestamp = Date().timeIntervalSince1970
    do {
      try userRealm.write {
        userRealm.add(updateNote, update: true)
        completionHandler(nil)
      }
    } catch {
      completionHandler(FBStoreError.createError("Create note error with id \(updateNote.id)"))
    }
  }
  
  public func deleteNote(withID id: String, completionHandler: @escaping (_ error: FBStoreError?) -> Void) {
    deleteObject(ofType: RealmNote.self, withID: id) { (error) in
      completionHandler(error)
    }
  }
  public func searchNote(keyword key: String,  completionHandler: @escaping (_ notes: [FBNote]) -> Void) {
    let notes = userRealm.objects(RealmNote.self)
    let notesArray = notes.toArray()
    let resultsArray = notesArray.filter { (note) -> Bool in
      
      return note.content.contains(key)
    }
    completionHandler(resultsArray.map{ $0.toNote() })
  }
  
  
  public func allSpecies(completionHandler: @escaping (_ speciesArray: [String]) -> Void) {
    
    let spciesArray = userRealm.objects(RealmSpecies.self)
    completionHandler(spciesArray.map{ $0.name })
  }
  
  public func allFlavours(completionHandler: @escaping (_ flavoursArray: [String]) -> Void) {
    
    let flavoursArray = userRealm.objects(RealmFlavour.self)
    completionHandler(flavoursArray.map{ $0.name })
  }
  
  public func allNatures(completionHandler: @escaping (_ naturesArray: [String]) -> Void) {
    
    let naturesArray = userRealm.objects(RealmNature.self)
    completionHandler(naturesArray.map{ $0.name })
  }
  public func allChannels(completionHandler: @escaping (_ channelsArray: [FBChannel]) -> Void) {
    
    let channelsArray = userRealm.objects(RealmChannel.self)
    completionHandler(channelsArray.map{ $0.toChannel() })
  }
}

