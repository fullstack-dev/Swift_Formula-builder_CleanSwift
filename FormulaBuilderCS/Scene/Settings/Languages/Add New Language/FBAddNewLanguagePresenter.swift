//
//  FBAddNewLanguagePresenter.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/17/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBAddNewLanguagePresenterInput
{
  func presentSomething(response: FBAddNewLanguage.Something.Response)
}

protocol FBAddNewLanguagePresenterOutput: class
{
  func displaySomething(viewModel: FBAddNewLanguage.Something.ViewModel)
}

class FBAddNewLanguagePresenter: FBAddNewLanguagePresenterInput
{
  weak var output: FBAddNewLanguagePresenterOutput!
  
  // MARK: - Presentation logic
  
  func presentSomething(response: FBAddNewLanguage.Something.Response)
  {
    // NOTE: Format the response from the Interactor and pass the result back to the View Controller
    
    let viewModel = FBAddNewLanguage.Something.ViewModel()
    output.displaySomething(viewModel: viewModel)
  }
}
