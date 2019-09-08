//
//  LoginViewController.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 16/08/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import UIKit
import FirebaseUI

class InitialViewController: UIViewController {


    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        setUpElements()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        
        // If a user is already logged in, go straight to home view controller
        let auth = FUIAuth.defaultAuthUI()!
                   
                   if auth.auth?.currentUser != nil {
                    SegueManager.transitionToNav2(self.view)
                }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
    }
    
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledButton(loginButton)
    }
    
}
