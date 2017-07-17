//
//  FBHistoryViewController.swift
//  FormulaBuilderCS
//
//  Created by YI BIN FENG on 2017-02-28.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBHistoryViewControllerInput
{
  func displaySomething(viewModel: FBHistory.Something.ViewModel)
}

protocol FBHistoryViewControllerOutput
{
  func doSomething(request: FBHistory.Something.Request)
}

class FBHistoryViewController: UIViewController, FBHistoryViewControllerInput
{
  var output: FBHistoryViewControllerOutput!
  var router: FBHistoryRouter!
  
  // MARK: - Object lifecycle
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    FBHistoryConfigurator.sharedInstance.configure(viewController: self)
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomethingOnLoad()
  }
  
  // MARK: - Event handling
  
  func doSomethingOnLoad()
  {
    // NOTE: Ask the Interactor to do some work
    
    let request = FBHistory.Something.Request()
    output.doSomething(request: request)
  }
  
  // MARK: - Display logic
  
  func displaySomething(viewModel: FBHistory.Something.ViewModel)
  {
    // NOTE: Display the result from the Presenter
    
    // nameTextField.text = viewModel.name
  }
}
