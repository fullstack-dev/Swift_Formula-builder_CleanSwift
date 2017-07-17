//
//  FBFormulaSearchPresenter.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/3/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBFormulaSearchPresenterInput {
    func presentFetchedFormulas(response: FBFormulaSearch.FetchFormulas.Response)
}

protocol FBFormulaSearchPresenterOutput: class {
    func displayFetchedFormulas(_ viewModel: FBFormulaSearch.FetchFormulas.ViewModel)
}

class FBFormulaSearchPresenter: FBFormulaSearchPresenterInput {
    weak var output: FBFormulaSearchPresenterOutput!
  
    func presentFetchedFormulas(response: FBFormulaSearch.FetchFormulas.Response) {
        
//        var displayedFormulas: [FBFormulaSearch.FetchFormulas.ViewModel.DisplayedFormula] = []
        
        var displayedFormulas = [DisplayedFormula]()
        
        for formula in response.formulas {
//            let displayFormula = FBFormulaSearch.FetchFormulas.ViewModel.DisplayedFormula(id: formula.id,
//                                                                                          name: formula.name.capitalized,
//                                                                                          simplifiedChinese: formula.simplifiedChinese,
//                                                                                          isLocked: false,
//                                                                                          isCompared: true,
//                                                                                          isFavorited: formula.favorite,
//                                                                                          herbsCount: formula.herbs.count)
//            displayedFormulas.append(displayFormula)
            
            
            let displayFormula = DisplayedFormula(with: formula)
            displayedFormulas.append(displayFormula)
            
        }
        
        let viewModel = FBFormulaSearch.FetchFormulas.ViewModel(displayedFormulas: displayedFormulas)
        output.displayFetchedFormulas(viewModel)
    }
}
