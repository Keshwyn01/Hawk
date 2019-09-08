//
//  SignUpViewController.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 16/08/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseFirestore

class LoginPopUpViewController: UIViewController {


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func transitionToHome(){
       
        if #available(iOS 13.0, *) {
            let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
            view.window?.rootViewController = homeViewController
                      view.window?.makeKeyAndVisible()
        } else {
            
            // Fallback on earlier versions
            let homeViewController = HomeViewController()
            view.window?.rootViewController = homeViewController
                                  view.window?.makeKeyAndVisible()
            
        }
        
       }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
