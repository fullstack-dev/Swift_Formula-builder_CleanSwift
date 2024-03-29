//
//  FBSpeciesInteractor.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/21/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBSpeciesInteractorInput
{
  func doSomething(request: FBSpecies.Something.Request)
}

protocol FBSpeciesInteractorOutput
{
  func presentSomething(response: FBSpecies.Something.Response)
}

class FBSpeciesInteractor: FBSpeciesInteractorInput
{
  var output: FBSpeciesInteractorOutput!
  var worker: FBSpeciesWorker!
  
  // MARK: - Business logic
  
  func doSomething(request: FBSpecies.Something.Request)
  {
    // NOTE: Create some Worker to do the work
    
    worker = FBSpeciesWorker()
    worker.doSomeWork()
    
    // NOTE: Pass the result to the Presenter
    
    let response = FBSpecies.Something.Response()
    output.presentSomething(response: response)
  }
}
