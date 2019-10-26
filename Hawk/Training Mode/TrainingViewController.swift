//
//  TrainingViewController.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 03/09/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import UIKit
import os.log
import FirebaseAuth
import FirebaseFirestore


class TrainingViewController: UIViewController, TrainingSessionHandlerDelegate  {
    
    @IBOutlet weak var courtLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var trainingCondition: [String]? /// -- values set in training setup view controller and brought over
    var count = 0
    
    let user = Auth.auth().currentUser
    var mainCollectionName = "trainingNew"
    var collectionName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TrainingSessionHandler.shared.sessionHandlerDelegate = self
        updateTrainingConditions()
    }
    
    func saveFile(_ fileURL: URL) {
        var strokeData = ""
        
        do {
            strokeData = try String(contentsOfFile: fileURL.path)
        } catch {
            print(error.localizedDescription)
        }
        
        let docData = ["data" : strokeData]
        uploadData(docData)
    }
    
    func updateCount() {
        
        guard let stroke = trainingCondition?[0] else {
            return }
        
        DispatchQueue.main.async {
            self.count = self.count + 1
            self.categoryLabel.text = "\(stroke) count = \(self.count)"
        }
    }
    
    func uploadData(_ docData: [String : Any]) {
        
        DispatchQueue.main.async {
            guard let currentUser = self.user, let dataLocation = self.collectionName else {
                os_log("No user logged in")
                return
            }
            
            var strokeData = docData
            strokeData["UID"] = currentUser.uid
            strokeData["User Name"] = currentUser.displayName
            strokeData ["Court Type"] = self.courtLabel.text
            strokeData ["Weather"] = self.weatherLabel.text
            strokeData["Time"] = Timestamp(date: Date())
            
            let  db=Firestore.firestore()
            db.collection(self.mainCollectionName).document(dataLocation).collection("data").addDocument(data: strokeData) { (error) in
                if error != nil{
                    os_log("Error saving user data to database")
                }
            }
        }
    }
    
    func updateTrainingConditions() {
        
        guard let conditions = trainingCondition else {
            return
        }
        
        categoryLabel.text=conditions[0]
        courtLabel.text=conditions[1]
        weatherLabel.text=conditions[2]
        
        if conditions[0] == "Forehand Top Spin" {
            collectionName = "fts"
        }
        else if conditions[0] == "Backhand Top Spin" {
            collectionName = "bts"
        }
        else if conditions[0] == "Serve" {
            collectionName = "s"
        }
        else if conditions[0] == "Forehand Slice" {
            collectionName = "fs"
        }
        else if conditions[0] == "Backhand Slice" {
            collectionName = "bs"
        }
        else {
            os_log("Test mode");
            collectionName = "test"
        }
    }
}




