//
//  InterfaceController.swift
//  Hawk WatchKit Extension
//
//  Created by Philip Mogull on 14/06/2019.
//  Copyright © 2019 Philip Mogull. All rights reserved.
//


import WatchKit
import Foundation
import Dispatch
import WatchConnectivity
import os.log
import HealthKit
import UIKit

class InterfaceController: WKInterfaceController, WorkoutManagerDelegate {
    // MARK: Properties
    
    let workoutManager = WorkoutManager()
    var active = false
    
    var gravityStr = ""
    var attitudeStr = ""
    var userAccelStr = ""
    var rotationRateStr = ""
    
    // MARK: Interface Properties
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var userAccelLabel: WKInterfaceLabel!
    
    override init() {
        super.init() 
//        os_log("Test Log")
        workoutManager.delegate = self
    }
    
    
    override func didDeactivate() {
        super.didDeactivate()
        active = false
    }
    
    
    
    
    
    @IBAction func start() {
        titleLabel.setText("RECORDING")
        workoutManager.startWorkout()
    }
    
    @IBAction func stop() {
        titleLabel.setText("Stopped Recording")
        workoutManager.stopWorkout()
    }
    // WorkoutManagerDelegate
    func didUpdateMotion(_ manager: WorkoutManager, gravityStr: String, rotationRateStr: String, userAccelStr: String, attitudeStr: String) {
        DispatchQueue.main.async {
            self.gravityStr = gravityStr
            self.userAccelStr = userAccelStr
            self.rotationRateStr = rotationRateStr
            self.attitudeStr = attitudeStr
            self.updateLabels();
        }
    }
    
    func updateLabels() {
        if active {
            //gravityLabel.setText(gravityStr)
            userAccelLabel.setText(userAccelStr)
            //rotationLabel.setText(rotationRateStr)
            //attitudeLabel//.setText(attitudeStr)
        }
    }
    
    
    //WATCHCONNECTIVITY
    
    private var session = WCSession.default
    
    //@IBOutlet weak var table: WKInterfaceTable!
    
    // MARK: - Items Table
    
    //private var items = [String]() {
    //    didSet {
    //        DispatchQueue.main.async {
    //            self.updateTable()
    //        }
    //    }
    //}
    
    func didCaptureStroke(_ strokeType: String) {
       
        
        guard session.activationState == .activated else {
            os_log("Session not active!")
            return
                }
        
        let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .medium
                let timeString = dateFormatter.string(from: Date())
        
        let data = ["data" : strokeType,
                    "time": timeString]
        session.transferUserInfo(data)
        
        os_log("Data Info Sent")
        
        
        if isReachable() {
           // session.sendMessage(["request" : strokeType], replyHandler: { (response) in
              //  os_log("Reply received")
           // }, errorHandler: { (error) in
             //   print("Error sending message: %@", error)
          //  })
        }else {
            print("iPhone is not reachable!!")
        }
        
    }
    
    
    /// Updating all contents of WKInterfaceTable
    private func updateTable() {
  //      table.setNumberOfRows(items.count, withRowType: "Row")
  //      for (i, item) in items.enumerated() {
  //          if let row = table.rowController(at: i) as? Row {
   //             row.lbl.setText(item)
    //        }
    //    }
    }
    
    func activateWatchConnectivity () {
        if isSuported() {
            session.delegate = self
            session.activate()
        }
        active = true
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
 
        }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // 2: Initialization of session and set as delegate this InterfaceController if it's supported

        updateLabels()
    }
    
    
    private func isSuported() -> Bool {
        return WCSession.isSupported()
    }
    
    private func isReachable() -> Bool {
        return session.isReachable
    }
    
    // 3. With our session property which allows implement a method for start communication
    // and manage the counterpart response
}


extension InterfaceController: WCSessionDelegate {
    
    // 4: Required stub for delegating session
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }
    
}
