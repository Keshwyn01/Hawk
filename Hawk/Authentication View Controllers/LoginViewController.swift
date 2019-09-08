//
//  LoginViewController.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 17/08/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up visual elements
        setUpElements()
        // Hide Keyboard when screen tapped
        self.hideKeyboardWhenTappedAround()
        
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        passwordTextField.isSecureTextEntry = true
        Utilities.styleFilledButton(loginButton)
        Utilities.styleNavBar(self)
        
    }

//  check if all fields are filled
    func validateFields() -> String? {
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
            
        }
        return nil
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            showError(error!)
            
        }
        
        else {
            
            let email = cleanField(emailTextField.text!)
            let password = cleanField(passwordTextField.text!)
            
//          create user
            Auth.auth().signIn(withEmail: email!, password: password!) { (result, err) in
                if err != nil {
//                  Couldn't sign in - show/ display error message
                    self.showError(err!.localizedDescription)
                }
                else {
                    SegueManager.transitionToNav2(self.view)
                    
                }
                
            }
            
        }
        
    }
    
    func showError(_ message:String) {
        errorLabel.text=message
        errorLabel.alpha=1
    }
    
    func cleanField(_ field: String) -> String? {
        let cleanVal=field.trimmingCharacters(in: .whitespacesAndNewlines)
        return cleanVal
    }
}

