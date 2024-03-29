//
//  Utilities.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 14/08/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleLabelField(_ textfield:UILabel) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        // Remove border on text field
        //textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleFilledButtonSmall(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func styleNavBar(_ viewController : UIViewController) {
         if viewController.navigationController != nil {
             viewController.navigationController!.navigationBar.tintColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        }
    }
    
}
