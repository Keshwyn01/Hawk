//
//  SignUpViewController.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 17/08/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // format view elements
        setUpElements()
        // implement keyboard tap dismiss functionality
        self.hideKeyboardWhenTappedAround()
    }
    
    func setUpElements(){
          // Hide error label
        errorLabel.alpha=0
          
          // Style Elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        passwordTextField.isSecureTextEntry = true
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleNavBar(self)
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
            // Validate the fields
            let error = validateFields()
            
            if error != nil {
                //there is something wrong with the fields
                showError(error!)
            }
            else {
                
            // create cleaned versions of data
                let firstName=firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let lastName=lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let email=emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let password=passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
                
            // Create the user
                Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // check for errors
                if err != nil {
                    // there was an error creating the user
                    self.showError(err!.localizedDescription)
                }
                else {
                    // User was create successfully, now store user first name and last name in Firestore
                    let  db=Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":firstName,"lastname":lastName, "uid":result!.user.uid]) { (error) in
                        
                        if error != nil{
//                          Show error message
                            self.showError("Error saving user data to database")
                            }
                        }
//                      Set display name as user first name
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = firstName
                        changeRequest?.commitChanges(completion: { (error) in
                             if error != nil  {
                                self.showError(error!.localizedDescription)
                            }
                        })
//                        If everything is successful transition to the home screen
                 
                    SegueManager.transitionToNav2(self.view)
                    //self.transitionToHome()
                    }
                }

            }
        }
        
    func showError(_ message:String) {
            
            errorLabel.text=message
            errorLabel.alpha=1
    }
        
      // check the fields and validate that the data is correct. if everything is correct, this method returns nil. Otherwise it returns the error message.
      func validateFields()-> String? {
          
          // Check that all fields are filled in
          if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
              lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ==  "" ||
              emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
              passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
              return "Please fill in all fields"
          }
          
          // Check if password is secure
        /*
          let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
          
          if FormUtilities.isPasswordValid(cleanedPassword) == false {
              
              return "Please make sure your password is at least 8 characters long, contains a special character and a number"
          } */
          
          return nil
      }

}


// extension added for keyboard dismiss when tapping the screen

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

