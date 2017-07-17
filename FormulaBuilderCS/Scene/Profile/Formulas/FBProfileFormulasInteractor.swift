//
//  FBProfileFormulasInteractor.swift
//  FormulaBuilderCS
//
//  Created by a on 2/19/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import FormulaBuilderCore

protocol FBProfileFormulasInteractorInput
{
    func fetchFormulas(request: FBProfileFormulas.FetchFormulas.Request, herbID: String)
    var formulas: [FBFormula]? { get }
}

protocol FBProfileFormulasInteractorOutput
{
    func presentFetchedFormulas(response: FBFormulaSearch.FetchFormulas.Response)
}

class FBProfileFormulasInteractor: FBProfileFormulasInteractorInput
{

    var output: FBProfileFormulasInteractorOutput!
    var formulas: [FBFormula]?
    // MARK: - Business logic

    func fetchFormulas(request: FBProfileFormulas.FetchFormulas.Request, herbID: String) {
        
        store.fetchFormulas(withHerbID: herbID) { (formulas) in
            self.formulas = formulas
            let response = FBFormulaSearch.FetchFormulas.Response(formulas: formulas)
            self.output.presentFetchedFormulas(response: response)
        }
    }
}
