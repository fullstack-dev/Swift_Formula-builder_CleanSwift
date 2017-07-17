//
//  FBAddToFormulaInteractor.swift
//  FormulaBuilderCS
//
//  Created by YI BIN FENG on 2017-02-27.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBAddToFormulaInteractorInput
{
  func doSomething(request: FBAddToFormula.Something.Request)
    var herbSearchViewController: FBHerbSearchViewController! { set get }
}

protocol FBAddToFormulaInteractorOutput
{
  func presentSomething(response: FBAddToFormula.Something.Response)
}

class FBAddToFormulaInteractor: FBAddToFormulaInteractorInput
{
  var output: FBAddToFormulaInteractorOutput!
  var worker: FBAddToFormulaWorker!
    var herbSearchViewController: FBHerbSearchViewController!
  
  // MARK: - Business logic
  
  func doSomething(request: FBAddToFormula.Something.Request)
  {
    // NOTE: Create some Worker to do the work
    
    worker = FBAddToFormulaWorker()
    worker.doSomeWork()
    
    // NOTE: Pass the result to the Presenter
    
    let response = FBAddToFormula.Something.Response()
    output.presentSomething(response: response)
  }
}
