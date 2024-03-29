//
//  FBProfileMoreInteractor.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/11/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBProfileMoreInteractorInput
{
  func doSomething(request: FBProfileMore.Something.Request)
}

protocol FBProfileMoreInteractorOutput
{
  func presentSomething(response: FBProfileMore.Something.Response)
}

class FBProfileMoreInteractor: FBProfileMoreInteractorInput
{
  var output: FBProfileMoreInteractorOutput!
  var worker: FBProfileMoreWorker!
  
  
  
  func doSomething(request: FBProfileMore.Something.Request)
  {
    
    
    worker = FBProfileMoreWorker()
    worker.doSomeWork()
    
    
    
    let response = FBProfileMore.Something.Response()
    output.presentSomething(response: response)
  }
}
