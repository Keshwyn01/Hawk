//
//  SegueManager.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 27/08/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import UIKit
import Foundation

class SegueManager{
    
    static func transitionToHome(_ view : UIView){
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController else {
            print("Could not instantiate view controller")
            return
            
        }
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    static func transitionToWorkout(_ view : UIView){
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let workoutViewController = mainStoryboard.instantiateViewController(withIdentifier: "WorkoutVC") as? ViewController else {
            print("Could not instantiate view controller")
            return

        }
        
        view.window?.rootViewController = workoutViewController
        view.window?.makeKeyAndVisible()

        }
    
    static func transitionToNav(_ view : UIView){
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let navViewController = mainStoryboard.instantiateViewController(withIdentifier: "Navigation") as? UINavigationController else {
            print("Could not instantiate view controller")
            return
            
        }
        
        view.window?.rootViewController = navViewController
        view.window?.makeKeyAndVisible()
    }
    
    static func transitionToNav2(_ view : UIView){
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let navViewController = mainStoryboard.instantiateViewController(withIdentifier: "Navigation-Home") as? UINavigationController else {
            print("Could not instantiate view controller")
            return
            
        }
        
        view.window?.rootViewController = navViewController
        view.window?.makeKeyAndVisible()
    }
    
}
