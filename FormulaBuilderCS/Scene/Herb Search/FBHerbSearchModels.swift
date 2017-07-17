//
//  FBHerbSearchModels.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/3/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import FormulaBuilderCore

struct FBHerbSearch {
    
    struct FetchHerbs {
        struct Request {}
        
        struct Response {
            var herbs: [FBHerb]
        }
        
        struct ViewModel {
            var displayedHerbs = [DisplayedHerb]()
        }
    }
}

class DisplayedHerb: NSObject {
    var id = ""
    var name = ""
    var simplifiedChinese = ""
    var traditionalChinese = ""
    var englishName = ""
    var containsCount = 0
    var containsInComparedFormulas = false
    var alternateNames: [String] = []
    var addToFormula = false
    var isCompared = false
    var isFavorited = false
    var isSelected = false
    var readOnly = false
    let herbObj : FBHerb?
    
    init(with herb: FBHerb) {
        id = herb.id
        name = herb.name.capitalized
        simplifiedChinese = herb.simplifiedChinese ?? ""
        traditionalChinese = herb.traditionalChinese ?? ""
        englishName = herb.pinyin ?? ""
        isFavorited = herb.favorite
        readOnly = herb.readOnly
        for alternateName in herb.alternateHerbs
        {
            alternateNames.append(alternateName.name.capitalized)
        }
        herbObj = herb
    }
}

class DisplayedAlternateHerb: NSObject {
    var id : String? = nil
    var name = ""
    var simplifiedChinese = ""
    var traditionalChinese = ""
    var englishCommon : [String] = [String]()
    var latinName : [String] = [String]()
    var preparation = ""
    var is_expandable = true
    var readOnly = false
    var isSelected = false
    var alternateHerbObj : FBAlternateHerb? = nil
    init(with alternateherb: FBAlternateHerb) {
        if let alternateId = alternateherb.id
        {
            id = alternateId
        }
        name = alternateherb.name.capitalized
        simplifiedChinese = alternateherb.simplifiedChinese ?? ""
        traditionalChinese = alternateherb.traditionalChinese ?? ""
        englishCommon = alternateherb.englishCommons
        latinName = alternateherb.latinNames
        alternateHerbObj = alternateherb
        preparation = alternateherb.preparation ?? ""
        readOnly = alternateherb.readOnly
    }
    
    override init() {
        
    }
}