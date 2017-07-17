//
//  FBProfileInfoPresenter.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/11/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBProfileInfoPresenterInput
{
    func presentHerbs(response: FBProfileInfo.Object.Response)
    func presentFlavours(response: FBProfileInfo.Object.ResponseFlavours)
    func presentNatures(response: FBProfileInfo.Object.ResponseNatures)
}

protocol FBProfileInfoPresenterOutput: class
{
    func displayHerbs(viewModel: FBProfileInfo.Object.ViewModel)
    func displayNatures(viewModel: FBProfileInfo.Object.ViewModelItems)
    func displayFlavours(viewModel: FBProfileInfo.Object.ViewModelItems)
}

class FBProfileInfoPresenter: FBProfileInfoPresenterInput
{
    weak var output: FBProfileInfoPresenterOutput!
    
    func presentHerbs(response: FBProfileInfo.Object.Response) {
        
        let preparedFormHerbs = response.prepareFormHerbs
        var displayedHerbs = [DisplayedHerb]()
        
        for herb in preparedFormHerbs {
            if herb.id.isEmpty == false {
                let displayedHerb = DisplayedHerb(with: herb)
                displayedHerbs.append(displayedHerb)
            }
        }
        let viewModel = FBProfileInfo.Object.ViewModel(prepareFormHerbs: displayedHerbs)
        output.displayHerbs(viewModel: viewModel)
    }
    
    func presentNatures(response: FBProfileInfo.Object.ResponseNatures) {
        let viewModel = FBProfileInfo.Object.ViewModelItems(content: response.natures)
        output.displayNatures(viewModel: viewModel)
    }
    
    func presentFlavours(response: FBProfileInfo.Object.ResponseFlavours) {
        let viewModel = FBProfileInfo.Object.ViewModelItems(content: response.flavours)
        output.displayFlavours(viewModel: viewModel)
    }
}
