//
//  FBCategoriesListModels.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/10/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import FormulaBuilderCore

struct FBCategoriesList {
    
    struct FetchCategories {
        
        struct Request {
            var type: CategoryType
        }
        
        struct Response {
            var categories: [FBCategory]
        }
        
        struct ViewModel {
            
            struct DisplayedCategory {
                var id: String
                var name: String
                var itemIDs: [String]
            }
            
            var displayedCategories: [DisplayedCategory]
        }
    }
}
