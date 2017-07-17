//
//  FBProfileNotesConfigurator.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/11/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension FBProfileNotesViewController: FBProfileNotesPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        router.passDataToNextScene(segue: segue)
    }
}

extension FBProfileNotesInteractor: FBProfileNotesViewControllerOutput {}
extension FBProfileNotesPresenter: FBProfileNotesInteractorOutput {}

class FBProfileNotesConfigurator {
    static let sharedInstance = FBProfileNotesConfigurator()
  
    private init() {}
  
    func configure(viewController: FBProfileNotesViewController) {
        let router = FBProfileNotesRouter()
        router.viewController = viewController

        let presenter = FBProfileNotesPresenter()
        presenter.output = viewController

        let interactor = FBProfileNotesInteractor()
        interactor.output = presenter

        viewController.output = interactor
        viewController.router = router
    }
}
