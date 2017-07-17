//
//  FBCoreWorker.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/11/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit
import FormulaBuilderCore

public enum FetchFilter {
    case all
    case favorite
    case notFavorite
}

public enum CategoryType {
    case herb
    case formula
}

class FBCoreWorker: NSObject {

    static let shared = FBCoreWorker()
    
    func favoriteStatusChanged(with id: String, type: String) {
        if type == "Formula" {
            store.changeFavorite(.formula, id) { error in
                print(error ?? "")
            }
        } else {
            store.changeFavorite(.herb, id) { error in
                print(error ?? "")
            }
        }
    }
    
    func createCategory(name: String, itemIDs: [String], type: CategoryType, completion: @escaping (_ category: FBCategoriesList.FetchCategories.ViewModel.DisplayedCategory?, _ error: FBStoreError?) -> Void) {
        
        var categoryType = FormulaBuilderCore.CategoryType.herb
        if type == .formula {
            categoryType = FormulaBuilderCore.CategoryType.formula
        }
                
        let category = FBCategory.init(id: "", timestamp: Date.timeIntervalSinceReferenceDate, name: name.capitalized, categoryType: categoryType, itemIDs: itemIDs, readOnly: false)
        
        store.saveCategory(.create, category) { fbCategory, error in
            
            var displayedCategory: FBCategoriesList.FetchCategories.ViewModel.DisplayedCategory?
            
            if fbCategory != nil {
                var itemIDs = [String]()
                
                for item in fbCategory!.itemIDs {
                    itemIDs.append(item)
                }
                
                displayedCategory = FBCategoriesList.FetchCategories.ViewModel.DisplayedCategory(id: fbCategory!.id, name: fbCategory!.name, itemIDs: itemIDs)
            }
            
            completion(displayedCategory, error)
        }
    }
    
    func updateCategory(category: FBCategoriesList.FetchCategories.ViewModel.DisplayedCategory, type: CategoryType, completion: @escaping (_ category: FBCategoriesList.FetchCategories.ViewModel.DisplayedCategory?, _ error: FBStoreError?) -> Void) {
        
        var categoryType = FormulaBuilderCore.CategoryType.herb
        if type == .formula {
            categoryType = FormulaBuilderCore.CategoryType.formula
        }
        
        let fbCategory = FBCategory.init(id: category.id, timestamp: Date.timeIntervalSinceReferenceDate, name: category.name.capitalized, categoryType: categoryType, itemIDs: category.itemIDs, readOnly: false)

        store.saveCategory(.update, fbCategory) { fbCategory, error in
            var displayedCategory: FBCategoriesList.FetchCategories.ViewModel.DisplayedCategory?
            
            if fbCategory != nil {
                displayedCategory = FBCategoriesList.FetchCategories.ViewModel.DisplayedCategory(id: fbCategory!.id, name: fbCategory!.name, itemIDs: fbCategory!.itemIDs)
            }
            
            completion(displayedCategory, error)
        }
    }
    
    func deleteCategory(id: String, type: CategoryType, completion: @escaping (_ error: FBStoreError?) -> Void) {
        
        if type == CategoryType.herb {
            store.deleteHerbCategory(categoryID: id, completionHandler: { error in
                completion(error)
            })
        } else {
            store.deleteFormulaCategory(categoryID: id) { error in
                completion(error)
            }
        }
    }
    
    func deleteAlternateHerb(id: String, completion: @escaping (_ error: FBStoreError?) -> Void) {
//            store.deleteAlternateHerb(withID: id) { error in
//                completion(error)
//            }
    }
    
    func getChannels(completion: @escaping (_ channels: [String]) -> Void) {
        store.allChannels { channels in
            //completion(channels)
        }
    }
    
    func getSpecies(completion: @escaping (_ species: [String]) -> Void) {
        store.allSpecies { species in
            completion(species)
        }
    }
    
    func getFlavour(completion: @escaping (_ flavour: [String]) -> Void) {
        store.allFlavours { flavour in
            completion(flavour)
        }
    }
    
    func getNatures(completion: @escaping (_ natures: [String]) -> Void) {
        store.allNatures { natures in
            completion(natures)
        }
    }
    
    func saveSearchedText(_ text: String?, type: CategoryType) {
        
        if text == nil {
            return
        }
        
        if text!.characters.count < 2 {
            return
        }
        
        var recordType = FormulaBuilderCore.RecentRecordType.herb
        if type == CategoryType.formula {
            recordType = FormulaBuilderCore.RecentRecordType.formula
        }
        
        let recent = FBRecent.init(id: "", timestamp: NSDate.timeIntervalSinceReferenceDate, recordID: text!, recordType: recordType)
        
        store.createRecentRecord(recent) {_ in}
    }
    
    func getRecents(type: CategoryType, completion: @escaping (_ recents: [FBRecent]) -> Void) {
        var recordType = FormulaBuilderCore.RecentRecordType.herb
        if type == CategoryType.formula {
            recordType = FormulaBuilderCore.RecentRecordType.formula
        }
        
        store.fetchRecentRecords(withType: recordType) { recents in
            completion(recents)
        }
    }

}
