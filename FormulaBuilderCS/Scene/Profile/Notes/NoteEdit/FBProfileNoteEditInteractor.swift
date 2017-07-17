//
//  FBProfileNoteEditInteractor.swift
//  FormulaBuilderCS
//
//  Created by a on 2/19/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import FormulaBuilderCore

protocol FBProfileNoteEditInteractorInput {
    func addNoteToHerbFormula(request: FBProfileNoteEdit.AddNote.Request, errorCallback: @escaping (_ error: FBStoreError?) -> Void)
    func updateNoteToHerbFormula(request: FBProfileNoteEdit.UpdateNote.Request, errorCallback: @escaping (_ error: FBStoreError?) -> Void)
}

protocol FBProfileNoteEditInteractorOutput {
  func presentSomething(response: FBProfileNoteEdit.AddNote.Response)
}

class FBProfileNoteEditInteractor: FBProfileNoteEditInteractorInput {
    var output: FBProfileNoteEditInteractorOutput!
    var worker: FBProfileNoteEditWorker!
    
    func addNoteToHerbFormula(request: FBProfileNoteEdit.AddNote.Request, errorCallback: @escaping (FBStoreError?) -> Void) {
        store.addNote(to: request.toType, toID: request.toID, with: request.note) { (error) in
                errorCallback(error)
        }
    }
    
    func updateNoteToHerbFormula(request: FBProfileNoteEdit.UpdateNote.Request, errorCallback: @escaping (FBStoreError?) -> Void) {
        store.updateNote(request.note) { (error) in
                errorCallback(error)
        }
    }
}
