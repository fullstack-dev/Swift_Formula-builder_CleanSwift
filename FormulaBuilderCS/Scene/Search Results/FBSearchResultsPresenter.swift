//
//  FBSearchResultsPresenter.swift
//  FormulaBuilderCS
//
//  Created by YI BIN FENG on 2017-02-28.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBSearchResultsPresenterInput {
    func presentFetchedResults(response: FBSearchResults.Something.Response)
}

protocol FBSearchResultsPresenterOutput: class {
    func displayResults(viewModel: FBSearchResults.Something.ViewModel)
}

class FBSearchResultsPresenter: FBSearchResultsPresenterInput {
    weak var output: FBSearchResultsPresenterOutput!

    func presentFetchedResults(response: FBSearchResults.Something.Response) {
        let viewModel = FBSearchResults.Something.ViewModel()
        output.displayResults(viewModel: viewModel)
    }
}
