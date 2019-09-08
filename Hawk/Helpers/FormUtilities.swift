//
//  FormUtilities.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 17/08/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import Foundation
import UIKit

class FormUtilities {
    
    // Function to verify whether password is secure, i.e. contains the right characters, is long enouvh, etc
    static func isPasswordValid(_ password : String) -> Bool {
            
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
            return passwordTest.evaluate(with: password)
        }
    
}

