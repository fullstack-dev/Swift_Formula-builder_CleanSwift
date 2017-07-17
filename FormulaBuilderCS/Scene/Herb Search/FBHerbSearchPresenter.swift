//
//  FBHerbSearchPresenter.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/3/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBHerbSearchPresenterInput {
    func presentFetchedHerbs(response: FBHerbSearch.FetchHerbs.Response)
}

protocol FBHerbSearchPresenterOutput: class {
    func displayFetchedHerbs(viewModel: FBHerbSearch.FetchHerbs.ViewModel)
}

class FBHerbSearchPresenter: FBHerbSearchPresenterInput {
    weak var output: FBHerbSearchPresenterOutput!

    func presentFetchedHerbs(response: FBHerbSearch.FetchHerbs.Response) {
        
        var displayedHerbs = [DisplayedHerb]()
        
        for herb in response.herbs {
            if herb.name.isEmpty == false && herb.id.isEmpty == false {
                let displayedHerb = DisplayedHerb(with: herb)
                displayedHerbs.append(displayedHerb)
            }
        }

        let viewModel = FBHerbSearch.FetchHerbs.ViewModel(displayedHerbs: displayedHerbs)
        output.displayFetchedHerbs(viewModel: viewModel)
    }
}
