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

protocol InterfaceControllerDelegate: class {
    
    func setWindow(_ mode: String)
}

class InterfaceController: WKInterfaceController, WorkoutManagerDelegate {
    
    private var session = WCSession.default
    weak var delegate: InterfaceControllerDelegate?
    
    // MARK: Properties
    //let fm = FileManager.default
    let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    var urlList = [URL]()
    
    let workoutManager = WorkoutManager()
    
    var active = false
    
    var gravityStr = ""
    var attitudeStr = ""
    var userAccelStr = ""
    var rotationRateStr = ""
    var windowSize = [[100, 100], [80,80]]
    
    // MARK: Interface Properties
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var userAccelLabel: WKInterfaceLabel!
    @IBOutlet weak var modeLabel: WKInterfaceLabel!
    
    override init() {
        super.init()
        workoutManager.delegate = self
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        active = false
    }
    
    @IBAction func start() {
        
        print(self.workoutManager.motionManager.shotData.windowSize)
        if isReachable() {
            session.sendMessage(["request" : "version"], replyHandler: { (response) in
                guard let message = response["Mode"] else{return}
                let mode = message as! String
                if mode == "Train" {
                    self.workoutManager.motionManager.shotData.windowSize = self.windowSize[0];
                }
                else if mode == "Play" {
                    self.workoutManager.motionManager.shotData.windowSize = self.windowSize[1];
                }
                self.modeLabel.setText(mode)
                self.titleLabel.setText("Recording")
                print(self.workoutManager.motionManager.shotData.windowSize)
                print(self.workoutManager.motionManager.shotData.windowSize[0])
                print(self.workoutManager.motionManager.shotData.windowSize[1])
                //self.delegate?.setWindow("test")
            }, errorHandler: { (error) in
                print("Error sending message: %@", error)
            })
        } else {
            self.titleLabel.setText("iPhone Not Reachable")
        }
        
        workoutManager.startWorkout()
        // added because when start workout first called, app stops working after screen goes to sleep. When stopworkout called followed by start, screen sleep issue if fixed - this is a temporary fix, need to understand why this issue arises
        workoutManager.stopWorkout()
        workoutManager.startWorkout()
    }
    
    @IBAction func stop() {
        titleLabel.setText("Stopped Recording")
        
        let fileTrans=session.outstandingFileTransfers
        print(fileTrans.count)
        if session.hasContentPending {
            titleLabel.setText("Data Transfer Pending")
            repeat {
            } while session.hasContentPending
        }
        
        clearTempFolder()
        titleLabel.setText("Ready")
        modeLabel.setText("Select Mode")
        
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
    
    func clearTempFolder() {
        
        titleLabel.setText("Clearing Temp Folder")
        for url in urlList {
            
            do{
                try FileManager.default.removeItem(at: url)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    //WATCHCONNECTIVITY
    
    
    
    
    // MARK: - Items Table
    
    
    func didCaptureStroke(_ strokeType: String) {
        
        
        let tempFileName = ProcessInfo().globallyUniqueString;
        let tempFileURL = tempDirectoryURL.appendingPathComponent(tempFileName)
        
        do{
            try strokeType.write(to: tempFileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error.localizedDescription)
        }
        
        urlList.append(tempFileURL)
        
        guard session.activationState == .activated else {
            os_log("Session not active!")
            return
        }
        
        session.transferFile(tempFileURL, metadata: nil)
        
        //let data = ["data" : strokeType]
        //session.transferUserInfo(data)
        
        os_log("Data Info Sent")
        
        
        if isReachable() {
            
        } else {
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
