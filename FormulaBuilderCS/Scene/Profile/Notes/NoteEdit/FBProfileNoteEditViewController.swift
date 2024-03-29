//
//  FBProfileNoteEditViewController.swift
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

protocol FBProfileNoteEditViewControllerInput {
    func displaySomething(viewModel: FBProfileNoteEdit.AddNote.ViewModel)
}

protocol FBProfileNoteEditViewControllerOutput {
    func addNoteToHerbFormula(request: FBProfileNoteEdit.AddNote.Request, errorCallback: @escaping (_ error: FBStoreError?) -> Void)
    func updateNoteToHerbFormula(request: FBProfileNoteEdit.UpdateNote.Request, errorCallback: @escaping (_ error: FBStoreError?) -> Void)
}

class FBProfileNoteEditViewController: FBProfileBaseViewController, FBProfileNoteEditViewControllerInput {
    var output: FBProfileNoteEditViewControllerOutput!
    var router: FBProfileNoteEditRouter!

    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var noteInputTextView: UITextView!
    @IBOutlet weak var lbcTextViewBottomMarginConstraint: NSLayoutConstraint!
    
    // MARK: - Object lifecycle
    var selectedNote : DisplayedNote?
    var accessaryTextFieldInTitle : UITextField?

    override func awakeFromNib() {
        super.awakeFromNib()
        FBProfileNoteEditConfigurator.sharedInstance.configure(viewController: self)
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        triggerKeyboardNotifications()
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }

    // MARK: - Display logic
    func displaySomething(viewModel: FBProfileNoteEdit.AddNote.ViewModel) {}
    
    fileprivate func configureView() {
        if (selectedNote != nil) {
            self.cancelBtn.isHidden = true
            self.backBtn.isHidden = false
            self.editBtn.isHidden = false
            
            txtTitle.text = selectedNote!.noteObj!.title
            let date = NSDate(timeIntervalSince1970: (selectedNote?.noteObj?.createdTimestamp)!)
            lblSubTitle.text = "Created " + Date.dateToStringHumanReadableDate(date: date as Date) + " at " + Date.dateToStringTime(date: date as Date);
            noteInputTextView.text = selectedNote!.noteObj!.content
            
            if (profileMainViewController?.profileViewType == .createHerb || profileMainViewController?.profileViewType == .createFormula || profileMainViewController?.profileViewType == .view) {
                saveBtn.isHidden = true
                noteInputTextView.isEditable = false
            }
        } else {
            
            self.cancelBtn.isHidden = false
            self.backBtn.isHidden = true
            self.editBtn.isHidden = true
            
            txtTitle.text = "Note Title"
            lblSubTitle.text = "Created Just Now"
        }
        
        txtTitle.delegate = self
        setupInputAccessoryViews()
    }
    
    func createNote(note: FBNote) {
        guard profileMainViewController?.profileViewType != .createHerb else {
            self.profileMainViewController?.herb?.notes.append(note)
            self.cancelBtnTapped("closing")
            return
        }
        
        guard profileMainViewController?.profileViewType != .createFormula else {
            self.profileMainViewController?.formula?.notes.append(note)
            self.cancelBtnTapped("closing")
            return
        }
        
        var request :FBProfileNoteEdit.AddNote.Request?
        if (self.profileMainViewController?.herb != nil) {
            request = FBProfileNoteEdit.AddNote.Request(note: note, toType: .herb, toID: self.profileMainViewController!.herb!.id)
        } else {
            request = FBProfileNoteEdit.AddNote.Request(note: note, toType: .formula, toID: self.profileMainViewController!.formula!.id)
        }
        
        output.addNoteToHerbFormula(request: request!) { (error) in
            if (error != nil) {
                FBAlertHandler.shared.showAlert(with: self, text: error!.localizedDescription)
            } else {
                self.cancelBtnTapped("closing")
            }
        }
    }
    
    func updateNote(note: FBNote) {
        guard profileMainViewController?.profileViewType != .createHerb else {
            self.cancelBtnTapped("closing")
            return
        }
        
        guard profileMainViewController?.profileViewType != .createFormula else {
            self.cancelBtnTapped("closing")
            return
        }
        
        var request :FBProfileNoteEdit.UpdateNote.Request?
        request = FBProfileNoteEdit.UpdateNote.Request(note: note)
        
        output.updateNoteToHerbFormula(request: request!) { (error) in
            if (error != nil) {
                FBAlertHandler.shared.showAlert(with: self, text: error!.localizedDescription)
            } else {
                self.cancelBtnTapped("closing")
            }
        }
    }
    
    //Keyboard for New Note
    fileprivate func setupInputAccessoryViews() {
        let keyboardDismissBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "keyboardDismiss") , style: .done, target: self, action: #selector(keyboardDismissBtnTapped(_:)))
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.setItems([flexibleSpace, keyboardDismissBtn], animated: true)
        noteInputTextView.inputAccessoryView = toolbar
        
        if (accessaryTextFieldInTitle == nil) {
            accessaryTextFieldInTitle = UITextField(frame: CGRect(x: 12, y: 6, width: UIScreen.main.bounds.width - 24, height: 32))
            accessaryTextFieldInTitle?.borderStyle = .roundedRect
            accessaryTextFieldInTitle?.clearButtonMode = .always
            accessaryTextFieldInTitle?.spellCheckingType = .no
            accessaryTextFieldInTitle?.autocorrectionType = .no
            accessaryTextFieldInTitle?.delegate = self
        }
        
        accessaryTextFieldInTitle?.text = txtTitle.text
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        customView.addSubview(accessaryTextFieldInTitle!)
        customView.backgroundColor = FBColor.hexColor_FAFAFA()
        txtTitle.inputAccessoryView = customView
        txtTitle.becomeFirstResponder()
    }
}

// MARK: Action Helper
extension FBProfileNoteEditViewController {
    func triggerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification : Notification) {
        if let keyboardSize = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect {
            lbcTextViewBottomMarginConstraint.constant = keyboardSize.height
        }
        
        if (txtTitle.isFirstResponder) {
            accessaryTextFieldInTitle?.becomeFirstResponder()
        }
    }
    
    func keyboardWillHide(notification : Notification) {
        lbcTextViewBottomMarginConstraint.constant = 8
    }
    
    func keyboardCancelBtnTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        self.cancelBtn.isHidden = false
        self.saveBtn.isHidden = false
        self.backBtn.isHidden = true
        self.editBtn.isHidden = true
    }
    
    func keyboardSaveBtnTapped(_ sender: Any) {
        self.cancelBtn.isHidden = false
        self.saveBtn.isHidden = false
        self.backBtn.isHidden = true
        self.editBtn.isHidden = true
        self.view.endEditing(true)
    }
}

// MARK: Button Handler
extension FBProfileNoteEditViewController {
    @IBAction func saveBtnTapped(_ sender: Any) {
        let title = txtTitle.text!
        let createdDate = NSDate().timeIntervalSince1970
        
        let contentText = noteInputTextView.text!
        
        if (title.characters.count > 0) {
            if (selectedNote != nil) {
                selectedNote!.noteObj!.title = title
                selectedNote!.noteObj!.content = contentText
                
                updateNote(note: selectedNote!.noteObj!)
            } else {
                let note = FBNote(id: "", title: title, content: contentText, createdTimestamp: createdDate, modifiedTimestamp: 0)
                print(note)
                createNote(note: note)
            }
            
        } else {
            FBAlertHandler.shared.showAlert(with: self, text: "Please specify the note title.")
        }
        
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        noteInputTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func editBtnTapped(_ sender: Any) {
        self.cancelBtn.isHidden = false
        self.saveBtn.isHidden = false
        self.backBtn.isHidden = true
        self.editBtn.isHidden = true
        
        noteInputTextView.isEditable = true
        
        setupInputAccessoryViews()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        noteInputTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func cameraBtnTapped(_ sender: Any) {
        
    }
    
    override func keyboardDismissBtnTapped(_ sender: Any) {
        noteInputTextView.resignFirstResponder()
        
        self.cancelBtn.isHidden = false
        self.backBtn.isHidden = true
        self.editBtn.isHidden = true
    }
}

// MARK: UITextFieldDelegate
extension FBProfileNoteEditViewController : UITextFieldDelegate {
    func textFieldDidChange(_ textField: UITextField) {
        self.cancelBtn.isHidden = true
        self.saveBtn.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accessaryTextFieldInTitle {
            txtTitle.text = accessaryTextFieldInTitle?.text
        }
        
        return true
    }
}
