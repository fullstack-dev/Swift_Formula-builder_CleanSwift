//
//  PlumFlowerStoreProtocol.swift
//  Pods
//
//  Created by T. S. on 2017-01-20.
//
//

import SwiftyJSON
import RealmSwift

public protocol PlumFlowerStoreProtocol {
  
  // Common
  func deleteAll(completionHandler: (_ success: Bool) -> Void)
  func changeFavorite(_ toType: ToType, _ id: String, completionHandler: @escaping (_ error: FBStoreError?) -> Void)
  
  // Advanced Search
  func herbAdvancedSearch(latinName latinName: String?, species species: [String]?, flavours flavours: [String]?, natures natures:[String]?, sourceText sourceText: String?, channelIDs channelIDs:[String]?, completionHandler: @escaping (_ results: [String]) -> Void)
  func formulaAdvancedSearch(pinyin pinyin: String?, chineseName chineseName: String?, sourceText sourceText: String?, author author: String?, completionHandler: @escaping (_ results: [String]) -> Void)
  
  // iCloud
  func iCloudSync(completionHandler: @escaping (_ success: Bool, _ error: FBStoreError?) -> Void)
  
  // Herbs
  func fetchHerbs(withFilter filter: FetchFilter, completionHandler: @escaping (_ herbs: [FBHerb]) -> Void)
  func fetchHerb(withID id: String, completionHandler: @escaping (_ herb: FBHerb?, _ error: FBStoreError?) -> Void)
  func saveHerb(_ saveType: SaveType, _ herb: FBHerb, completionHandler: @escaping (_ error: FBStoreError?) -> Void)
  func deleteHerb(withID id: String, completionHandler: @escaping (_ error: FBStoreError?) -> Void)
  func searchHerb(keyword key: String, completionHandler: @escaping (_ herbs: [FBHerb]) -> Void)
  
  // AlternateHerb
  func fetchAlternateHerbs(completionHandler: @escaping (_ alternateHerbs: [FBAlternateHerb]) -> Void)
  func saveAlternateHerb(_ alternateHerb: FBAlternateHerb, completionHandler: @escaping (_ alternateHerb: RealmAlternateHerb?, _ error: FBStoreError?) -> Void)
  func deleteAlternateHerb(withID id: String, completionHandler: @escaping (FBStoreError?) -> Void)
  
  // FBFormula
  func fetchFormulas(withFilter filter: FetchFilter, completionHandler: @escaping (_ formulas: [FBFormula]) -> Void)
  func fetchFormulas(withHerbID herbID: String, completionHandler: @escaping (_ formulas: [FBFormula]) -> Void)
  func fetchFormula(withID id: String, _ completionHandler: @escaping (_ formula: FBFormula?, _ error: FBStoreError?) -> Void)
  func saveFormula(_ saveType: SaveType, _ formula: FBFormula, completionHandler: @escaping (_ error: FBStoreError?) -> Void)
  func deleteFormula(withID id: String, completionHandler: @escaping (_ error: FBStoreError?) -> Void)
  func searchFormula(keyword key: String,  completionHandler: @escaping (_ formulas: [FBFormula]) -> Void)
  
  // Recent
  func fetchRecentRecords(withType type: RecentRecordType, completionHandler: @escaping (_ recents: [FBRecent]) -> Void)
  func createRecentRecord(_ recent: FBRecent, completionHandler: @escaping (_ error: FBStoreError?) -> Void)
  func deleteRecentRecord(withID id: String, completionHandler: @escaping (_ error: FBStoreError?) -> Void)
  
  // Category
  func fetchCategories(categoryType: CategoryType, completionHandler: @escaping (_ categories: [FBCategory]) -> Void)
  func saveCategory(_ saveType: SaveType, _ category: FBCategory, completionHandler: @escaping (_ category: FBCategory?, _ error: FBStoreError?) -> Void)
  func deleteHerbCategory(categoryID id: String, completionHandler: @escaping (_ error: FBStoreError?) -> Void)
  func deleteFormulaCategory(categoryID id: String, completionHandler: @escaping (_ error: FBStoreError?) -> Void)

//  func searchCategory(keyword key: String,  completionHandler: @escaping (_ categories: [FBCategory]) -> Void)
  
  // Note
  func fetchNotes(withID id: String, completionHandler: @escaping (_ notes: [FBNote]) -> Void)
  func addNote(to toType: ToType, toID id: String, with note: FBNote, completionHandler: @escaping (_ error: FBStoreError?) -> Void)
  func updateNote(_ note: FBNote, completionHandler: @escaping (_ error: FBStoreError?) -> Void)
  func deleteNote(withID id: String, completionHandler: @escaping (_ error: FBStoreError?) -> Void)
  func searchNote(keyword key: String,  completionHandler: @escaping (_ notes: [FBNote]) -> Void)

  // Helper
  func allSpecies(completionHandler: @escaping (_ speciesArray: [String]) -> Void)
  func allFlavours(completionHandler: @escaping (_ flavoursArray: [String]) -> Void)
  func allNatures(completionHandler: @escaping (_ naturesArray: [String]) -> Void)
  func allChannels(completionHandler: @escaping (_ channelsArray: [FBChannel]) -> Void)
}

public enum FetchFilter {
  
  case all
  case favorite
  case notFavorite
}

public enum FBStoreResult<U>{
  case success(result: U)
  case failure(error: FBStoreError)
}

public enum FBStoreError: Equatable, Error{
  case fetchError(String)
  case createError(String)
  case updateError(String)
  case deleteError(String)
  case syncError(String)
}

public enum RecentRecordType: Int {
  case all = 0
  case herb = 1
  case formula = 2
}

public enum CategoryType: Int {
  case all = 0
  case herb = 1
  case formula = 2
}

public enum SaveType{
  case create, update
}

public enum ToType {
  case herb, formula
}

public func ==(lhs: FBStoreError, rhs: FBStoreError) -> Bool {
  
  switch (lhs, rhs) {
  case (.fetchError(let a), .fetchError(let b)) where a == b: return true
  case (.fetchError(let a), .fetchError(let b)) where a == b: return true
  case (.fetchError(let a), .fetchError(let b)) where a == b: return true
  case (.fetchError(let a), .fetchError(let b)) where a == b: return true
    
  default:
    return false
  }
}

