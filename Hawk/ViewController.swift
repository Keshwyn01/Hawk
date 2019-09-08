//
//  ViewController.swift
//  Hawk
//
//  Created by Philip Mogull on 14/06/2019.
//  Copyright © 2019 Philip Mogull. All rights reserved.
//

import UIKit
import os.log



class ViewController: UIViewController, SessionHandlerDelegate {
    
    
    func updateLabel(_ message: String) {
        DispatchQueue.main.async {
            self.categoryStrokeType.text = message
            os_log("Message Recieved By iPhone")
        }

    }
    

    var squareBox: UILabel!
    var category: UIView!
    var categoryTopMarker:UILabel!
    var categoryStrokeType:UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        SessionHandler.shared.sessionHandlerDelegate = self
        
        addHeaderSubview()
        addCategorySubview()
        // Do any additional setup after loading the view.
    
        
    }
    
    func addCategorySubview() {
        category = UIView()
        category.backgroundColor = .blue
        view.addSubview(category)
        
        //BOX FOR CATEGORY DEFINITION
        category.translatesAutoresizingMaskIntoConstraints = false
        category.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        category.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        category.heightAnchor.constraint(equalToConstant: 100).isActive = true
        category.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        category.layer.cornerRadius = 5
        category.layer.masksToBounds = true
        
        //TOP TITLE VIEW DEFINITION
        categoryTopMarker = UILabel()
        categoryTopMarker.text = "Stroke Type"
        categoryTopMarker.textAlignment = .center
        categoryTopMarker.font = UIFont(name: "Avenir", size: 14)
        view.addSubview(categoryTopMarker)
        
        categoryTopMarker.translatesAutoresizingMaskIntoConstraints = false
        categoryTopMarker.bottomAnchor.constraint(equalTo: category.topAnchor, constant: -5).isActive = true
        categoryTopMarker.leftAnchor.constraint(equalTo: category.leftAnchor).isActive = true
        categoryTopMarker.rightAnchor.constraint(equalTo: category.rightAnchor).isActive = true
        
        //STROKE TYPE DEFINITION
        categoryStrokeType = UILabel()
        categoryStrokeType.text = "ST"
        categoryStrokeType.textColor = .white
        categoryStrokeType.font = UIFont(name: "Avenir", size: 24)
        categoryStrokeType.textAlignment = .center
        category.addSubview(categoryStrokeType)
        
        categoryStrokeType.translatesAutoresizingMaskIntoConstraints = false
        categoryStrokeType.centerXAnchor.constraint(equalTo: category.centerXAnchor).isActive = true
        categoryStrokeType.centerYAnchor.constraint(equalTo: category.centerYAnchor).isActive = true
    }
    
    
    func addHeaderSubview() {
        
        squareBox = UILabel()
        squareBox.backgroundColor = UIColor(displayP3Red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        squareBox.text = "Performance Tennis Tracking"
        squareBox.textAlignment = .center
        squareBox.font = UIFont(name: "Avenir-Light", size: 20)
        squareBox.textColor = .black
        view.addSubview(squareBox)
        
        
        squareBox.translatesAutoresizingMaskIntoConstraints = false
        squareBox.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        squareBox.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        squareBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        squareBox.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
    }


}

