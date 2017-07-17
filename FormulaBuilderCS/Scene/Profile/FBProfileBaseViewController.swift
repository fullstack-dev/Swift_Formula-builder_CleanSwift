//
//  FBProfileBaseViewController.swift
//  FormulaBuilderCS
//
//  Created by a on 2/20/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

class FBProfileBaseViewController: UIViewController {

    var profileMainViewController: FBProfileViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupInputAccessoryViewsForTextFields(txtFields : [UITextField]) {
        let keyboardDismissBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "keyboardDismiss") , style: .done, target: self, action: #selector(keyboardDismissBtnTapped(_:)))
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let toolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.setItems([flexibleSpace, keyboardDismissBtn], animated: false)
        
        for txtField in txtFields {
            txtField.inputAccessoryView = toolbar
        }
    }
    
    func keyboardDismissBtnTapped(_ sender: Any) {
        self.view.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches.first?.location(in: nil) ?? "asdf")
    }
}
