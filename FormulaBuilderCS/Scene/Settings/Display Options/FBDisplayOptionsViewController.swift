//
//  FBDisplayOptionsViewController.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/16/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBDisplayOptionsViewControllerInput {
    func displaySomething(viewModel: FBDisplayOptions.Something.ViewModel)
}

protocol FBDisplayOptionsViewControllerOutput {
    func doSomething(request: FBDisplayOptions.Something.Request)
    var options: [String] { get }
}

class FBDisplayOptionsViewController: UITableViewController, FBDisplayOptionsViewControllerInput {
    var output: FBDisplayOptionsViewControllerOutput!
    var router: FBDisplayOptionsRouter!
  
    var selectedTextField: UITextField!
    @IBOutlet var optionsPickerView: UIPickerView!
    @IBOutlet weak var primaryTextField: UITextField!
    @IBOutlet weak var secondaryTextField: UITextField!
    @IBOutlet weak var tetiaryField: UITextField!

    @IBOutlet var pickerView: UIView!
    @IBOutlet weak var pickerViewTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        FBDisplayOptionsConfigurator.sharedInstance.configure(viewController: self)
    }
  
  // MARK: - View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configurePicker()
        configueTableView()
    
        doSomethingOnLoad()
  }
    
    func configurePicker() {
        primaryTextField.inputView = pickerView
        secondaryTextField.inputView = pickerView
        tetiaryField.inputView = pickerView
    }
    
    func configueTableView() {
        let footerView = UIView.init(frame: CGRect(x: 0, y:0, width: UIScreen.main.bounds.size.width, height: 50))
        
        let line = UIView.init(frame: CGRect(x: 0, y:0, width: footerView.frame.size.width, height: 0.65))
        line.backgroundColor = UIColor.lightGray
        footerView.addSubview(line)
        
        let label = UILabel.init(frame: CGRect(x: 30, y:13, width: footerView.frame.size.width - 30, height: 37))
        label.text = "Select languages as primary, secondary and tetiary on the Herb Cell display."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = FBFont.SFUIText_Regalur14()
        label.textColor = FBColor.hexColor_9B9B9B()
        footerView.addSubview(label)
        
        tableView.tableFooterView = footerView
    }
  
    @IBAction func pickerViewDoneButtonClicked(_ sender: UIButton) {
        selectedTextField.resignFirstResponder()
    }
  
    func doSomethingOnLoad() {
        let request = FBDisplayOptions.Something.Request()
        output.doSomething(request: request)
    }

    func displaySomething(viewModel: FBDisplayOptions.Something.ViewModel) {}
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}



// MARK: UITextFieldDelegate

extension FBDisplayOptionsViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTextField = textField
        if textField == primaryTextField {
            pickerViewTitleLabel.text = "Primary Field"
        } else if textField == secondaryTextField {
            pickerViewTitleLabel.text = "Secondary Field"
        } else {
            pickerViewTitleLabel.text = "Tetiary Field"
        }
        return true
    }
}

// MARK: UIPickerViewDataSource

extension FBDisplayOptionsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return output.options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return output.options[row]
    }
}

// MARK: UIPickerViewDelegate

extension FBDisplayOptionsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTextField.text = output.options[row]
    }
}