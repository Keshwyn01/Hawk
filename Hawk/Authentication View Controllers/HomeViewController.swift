//
//  LoginViewController.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 14/08/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseFirestore



class HomeViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var trainButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpElements()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)

    }
    
/*
    @IBAction func startButtonTapped(_ sender: Any) {
//      create an Auth object
        let auth = FUIAuth.defaultAuthUI()
        
//      verify if user is logged in
        if auth?.auth?.currentUser != nil {
            SegueManager.transitionToPlay(self.view)
        }
//      if no user, transition to navigation and thus to login section
        else {
            SegueManager.transitionToNav(self.view)
        }
    }
*/
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        let auth = FUIAuth.defaultAuthUI()!
        
        if auth.auth?.currentUser != nil {
            do {
                try auth.signOut()
                SegueManager.transitionToNav(self.view)
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
            SegueManager.transitionToNav(self.view)
        }
        
    }
    
    func setUpElements() {
        
        Utilities.styleFilledButtonSmall(logoutButton)
        Utilities.styleFilledButton(startButton)
        Utilities.styleFilledButton(trainButton)
//      Check if there is a user logged in
        let user = Auth.auth().currentUser
        if user != nil {
            guard let displayName = user?.displayName else{
                return
            }
            textLabel!.text = "Hello \(displayName)"
        }
    }
        
}

