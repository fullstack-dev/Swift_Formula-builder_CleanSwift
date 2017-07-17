//
//  FBSearchResultsRouter.swift
//  FormulaBuilderCS
//
//  Created by YI BIN FENG on 2017-02-28.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBSearchResultsRouterInput
{
  func navigateToSomewhere()
}

class FBSearchResultsRouter: FBSearchResultsRouterInput
{
  weak var viewController: FBSearchResultsViewController!

  func navigateToSomewhere(){

  }

  func passDataToNextScene(segue: UIStoryboardSegue) {

    if segue.identifier == "ShowSomewhereScene" {
      passDataToSomewhereScene(segue: segue)
    }
  }
  
  func passDataToSomewhereScene(segue: UIStoryboardSegue) {

  }
}
