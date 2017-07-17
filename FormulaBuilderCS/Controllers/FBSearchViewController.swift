//
//  FBSearchViewController.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/13/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

class FBSearchViewController: UIViewController {

    var needFetch = true
    var allowsMultipleSelection = false
    var percentage: CGFloat = 0
    let trigger: CGFloat = 0.33
    var itemIDs = [String]()
    var filter = FetchFilter.all
    
    var resultIDs = [String]()

    var checkView: UIView?
    var crossView: UIView?
    var keyboardTitleLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var numberLabel: FBNumberLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    var category: FBCategoriesList.FetchCategories.ViewModel.DisplayedCategory?
    
    var nameTextField: UITextField?
    var keyboardToolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureKeyboardDismissToolbar()
        
        if allowsMultipleSelection || category != nil {

            nameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 44))
            nameTextField!.center = (navigationController?.navigationBar.center)!
            nameTextField!.textAlignment = .center
            nameTextField!.autocorrectionType = .no
            nameTextField!.returnKeyType = .done
            nameTextField!.autocapitalizationType = .words
            nameTextField!.font = FBFont.SFUIText_Regalur17()
            nameTextField!.delegate = self
            nameTextField!.placeholder = "Enter Category Name"
            nameTextField!.becomeFirstResponder()
            
            navigationItem.titleView = nameTextField
            
            if category != nil {
                rightBarButton?.title = "Edit"
                nameTextField?.isEnabled = false
                nameTextField?.text = category!.name
                
                if category!.name == "All Herbs" ||  category!.name == "All Formulas" {
                    rightBarButton?.tintColor = UIColor.clear
                    rightBarButton?.isEnabled = false
                }
            } else {
                rightBarButton?.title = "Save"
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { context in
            
            if UIDevice.current.orientation.isLandscape { // landscape mode
                self.keyboardToolbar.isHidden = true
            } else { // portrait mode
                self.keyboardToolbar.isHidden = false
            }
        }, completion: nil)
    }
    
    fileprivate func configureTableView() {
        tableView.register(UINib(nibName: "FBCell", bundle: nil), forCellReuseIdentifier: kCell)
    }
    
    func viewWithImageName(_ imageName: String) -> UIView {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        return imageView
    }
    
    func configureKeyboardDismissToolbar() {
        keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        let flexibelSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissKeyboard))
        
        keyboardTitleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        keyboardTitleLabel.textAlignment = .center
        keyboardTitleLabel.font = FBFont.SFUIText_Regalur17()
        keyboardTitleLabel.text = "Search Formulas"
        
        let labelItem = UIBarButtonItem.init(customView: keyboardTitleLabel)
        
        keyboardToolbar.items = [cancelButton, flexibelSpaceItem, labelItem, flexibelSpaceItem, cancelButton]
        keyboardToolbar.sizeToFit()
        
        searchBar.inputAccessoryView = keyboardToolbar
    }
    
    func preCheckFail() -> Bool {
        // 0. check name -> name can't be nil, name cant be same with others
        
        if (nameTextField?.text?.isEmpty)! {
            FBAlertHandler.shared.showAlert(with: self, text: kNameIsNil)
            return true
        } else if itemIDs.isEmpty {
            FBAlertHandler.shared.showAlert(with: self, text: kItemIsNil)
            return true
        }
        
        view.endEditing(true)
        
        return false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dismissVC() {
        if (self.navigationController != nil) {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension FBSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

