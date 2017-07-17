//
//  FBAlertHandler.swift
//  FormulaBuilder
//
//  Created by YI BIN FENG on 2017-01-18.
//
//

import UIKit

let kNameIsNil = "Name can't be nil"
let kHerbsIsNil = "At least one herb should be selected"
let kHerbNameExist = "A Herb already exists with that name, please pick another one"
let kItemIsNil = "At least one item should be selected"

class FBAlertHandler: NSObject {
    
    static let shared = FBAlertHandler()

    func showAlert(with controller: UIViewController, text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(with controller: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
