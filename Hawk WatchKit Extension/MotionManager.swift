//
//  MotionManager.swift
//  PerformanceTennisTracking WatchKit Extension
//
//  Created by Philip Mogull on 24/02/2019.
//  Copyright © 2019 Philip Mogull. All rights reserved.
//


import Foundation
import CoreMotion
import WatchKit
import os.log
/**
 `MotionManagerDelegate` exists to inform delegates of motion changes.
 These contexts can be used to enable application specific behavior.
 */
protocol MotionManagerDelegate: class {
    func didUpdateMotion(_ manager: MotionManager, gravityStr: String, rotationRateStr: String, userAccelStr: String, attitudeStr: String)
    
    func didCaptureStroke(_ strokeType: String)
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}


class MotionManager {
    
    // MARK: Properties
    
    var previousTimeStamp: Int64 = 0;
    var rallyLength = 0;
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let wristLocationIsLeft = WKInterfaceDevice.current().wristLocation == .left
    
    // MARK: Application Specific Constants
    
    // The app is using 50hz data and the buffer is going to hold 1s worth of data.
    let sampleInterval = 1.0 / 128
    let shotData = ShotManager(size: 100)
    
    
    weak var delegate: MotionManagerDelegate?
    
    var gravityStr = ""
    var rotationRateStr = ""
    var userAccelStr = ""
    var attitudeStr = ""
    
    var recentDetection = false
    
    // MARK: Initialization
    
    init() {
        // Serial queue for sample handling and calculations.
        queue.maxConcurrentOperationCount = 1
        queue.name = "MotionManagerQueue"
    }
    
    // MARK: Motion Manager
    
    func startUpdates() {
        if !motionManager.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }
        
        os_log("Start Test Updates");
        
        motionManager.deviceMotionUpdateInterval = sampleInterval
        motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {print("Encountered error: \(error!)")}
            if deviceMotion != nil {self.processDeviceMotion(deviceMotion!)}}
        
        
    }
    
    func stopUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    // MARK: Motion Processing
    
    func processDeviceMotion(_ deviceMotion: CMDeviceMotion) {
        
        
        
        gravityStr = String(format: "X: %.1f Y: %.1f Z: %.1f" ,
                            deviceMotion.gravity.x,
                            deviceMotion.gravity.y,
                            deviceMotion.gravity.z)
        userAccelStr = String(format: "X: %.1f Y: %.1f Z: %.1f" ,
                              deviceMotion.userAcceleration.x,
                              deviceMotion.userAcceleration.y,
                              deviceMotion.userAcceleration.z)
        rotationRateStr = String(format: "X: %.1f Y: %.1f Z: %.1f" ,
                                 deviceMotion.rotationRate.x,
                                 deviceMotion.rotationRate.y,
                                 deviceMotion.rotationRate.z)
        attitudeStr = String(format: "r: %.1f p: %.1f y: %.1f" ,
                             deviceMotion.attitude.roll,
                             deviceMotion.attitude.pitch,
                             deviceMotion.attitude.yaw)
        
        updateMetricsDelegate();
        
        shotData.addSample(deviceMotion)
        
        if shotData.hasShotBeenStored == true {
            let exportString = createExportString()
            shotData.reset()
            
            DispatchQueue.main.async {
                self.delegate?.didCaptureStroke(exportString)
            }
        }
    }
    
    func createExportString () -> String {
        var exportString = ""
        let totalSignalXData = shotData.leadingSignalXData + shotData.trailingSignalXData
        let totalSignalYData = shotData.leadingSignalYData + shotData.trailingSignalYData
        let totalSignalZData = shotData.leadingSignalZData + shotData.trailingSignalZData
        let totalSignalXGyro = shotData.leadingGyroXData + shotData.trailingGyroXData
        let totalSignalYGyro = shotData.leadingGyroYData + shotData.trailingGyroYData
        let totalSignalZGyro = shotData.leadingGyroZData + shotData.trailingGyroZData
        print(totalSignalXData.count)
        
        let o = (totalSignalXData.count)
        
        for j in 1...o {
            exportString = exportString + "\(Double(totalSignalXData[j-1])),"
        }
        
        for j in 1...o {
            exportString = exportString + "\(Double(totalSignalYData[j-1])),"
        }
        
        for j in 1...o {
            exportString = exportString + "\(Double(totalSignalZData[j-1])),"
        }
        
        for j in 1...o {
            exportString = exportString + "\(Double(totalSignalXGyro[j-1])),"
        }
        
        for j in 1...o {
            exportString = exportString + "\(Double(totalSignalYGyro[j-1])),"
        }
        
        for j in 1...o {
            exportString = exportString + "\(Double(totalSignalZGyro[j-1])),"
        }
        
        return exportString
    }
    
    func storeExportString (_ exportString: String) {
        os_log("Stroke Data Exported")
        
    }
    
    // MARK: Data and Delegate Management
    
    func updateMetricsDelegate() {
        delegate?.didUpdateMotion(self,gravityStr:gravityStr, rotationRateStr: rotationRateStr, userAccelStr: userAccelStr, attitudeStr: attitudeStr)
    }
    
}




