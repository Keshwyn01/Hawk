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
    let shotData = ShotManager(size: 250)
    
    
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
            storeExportString(exportString)
            shotData.reset()
        }
        
        
        //   os_log("Motion: %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@",
        //          String(timestamp),
        //          String(deviceMotion.gravity.x),
        //          String(deviceMotion.gravity.y),
        //          String(deviceMotion.gravity.z),
        //          String(deviceMotion.userAcceleration.x),
        //          String(deviceMotion.userAcceleration.y),
        //          String(deviceMotion.userAcceleration.z),
        //          String(deviceMotion.rotationRate.x),
        //          String(deviceMotion.rotationRate.y),
        //          String(deviceMotion.rotationRate.z),
        //          String(deviceMotion.attitude.roll),
        //          String(deviceMotion.attitude.pitch),
        //          String(deviceMotion.attitude.yaw))
        
    }
    
    func createExportString () -> String {
        
        var exportString = ""
        //let totalData = shotData.leadingSignalXData + shotData.trailingSignalXData + shotData.leadingSignalYData + shotData.trailingSignalYData + shotData.leadingSignalZData + shotData.trailingSignalZData + shotData.leadingGyroXData + shotData.trailingGyroXData + shotData.leadingGyroYData + shotData.trailingGyroYData + shotData.leadingGyroZData + shotData.trailingGyroZData
        /*
        var weights = [Double]()
        
        var zippedData = zip(totalData, MLConstants.forehandTopspinWeightArray).map(*)
        let totalForehand = zippedData.reduce(0, +)
        weights.append(totalForehand)
        
        zippedData = zip(totalData, MLConstants.backhandTopspinWeightArray).map(*)
        let totalBackhand = zippedData.reduce(0, +)
        weights.append(totalBackhand)
        
        zippedData = zip(totalData, MLConstants.serveWeightArray).map(*)
        let totalServe = zippedData.reduce(0, +)
        weights.append(totalServe)
        
        zippedData = zip(totalData, MLConstants.forehandSliceWeightArray).map(*)
        let totalForehandSlice = zippedData.reduce(0, +)
        weights.append(totalForehandSlice)
        
        zippedData = zip(totalData, MLConstants.backhandSliceWeightArray).map(*)
        let totalBackhandSlice = zippedData.reduce(0, +)
        weights.append(totalBackhandSlice)
        
        var maximumIndex = 0
        
        if let maxValue = weights.max() {
            maximumIndex = weights.index(of: maxValue)!
        }
        
        if maximumIndex == 0 {
            exportString = "FT"
        } else if maximumIndex == 1 {
            exportString = "BT"
        } else if maximumIndex == 2 {
            exportString = "S"
        } else if maximumIndex == 3 {
            exportString = "FS"
        } else if maximumIndex == 4 {
            exportString = "BS"
        } else {
            exportString = "Fatal Error"
        }
        
  //      let trailingGyroYData = shotData.trailingGyroYData
  //      let trailingGyroZData = shotData.trailingGyroZData
        
  //      let o = (trailingGyroYData.count)
  //      let p = (trailingGyroZData.count)
        
  //      var spin = 0.0
  //      var speed = 0.0
        
   //     for i in 1...o {
    ///        if ((trailingGyroYData[i-1] * 0.68) > speed) {
    //            speed = trailingGyroYData[i-1] * 0.68
    //        }
    //        if (-trailingGyroYData[i-1] * 0.68 > speed) {
    //            speed = -trailingGyroYData[i-1] * 0.68
    //        }
   //     }
        
   //     for i in 1...p {
  //          if ((trailingGyroZData[i-1] * 0.68) > spin) {
  //              spin = trailingGyroZData[i-1] * 0.68
  //          }
  //          if (-trailingGyroZData[i-1] * 0.68 > spin) {
  //              spin = -trailingGyroZData[i-1] * 0.68
  //          }
  //      }
        
        let nextTimestamp = Date().millisecondsSince1970
        
        if (nextTimestamp - previousTimeStamp > 7000) {
            rallyLength = 1
        } else {
            rallyLength = rallyLength + 1
        }
        
        previousTimeStamp = nextTimestamp
        
        let fraction: Double = 2.0 + Double.random(in: -1.5 ..< 1.5)
        
        delegate?.didCaptureStroke(exportString)
        */
     //   exportString = exportString + "  Shot Speed: \(Double(speed.rounded(toPlaces: 3)))," + "  Shot Spin: \(Double(spin.rounded(toPlaces: 3)))," + "   Rally Length: \(Int(rallyLength))," + "   Consistency: \(Double(fraction.rounded(toPlaces: 2)))"
        
        
        //var exportString = ""
        
        let totalSignalXData = shotData.leadingSignalXData + shotData.trailingSignalXData
        let totalSignalYData = shotData.leadingSignalYData + shotData.trailingSignalYData
        let totalSignalZData = shotData.leadingSignalZData + shotData.trailingSignalZData
        let totalSignalXGyro = shotData.leadingGyroXData + shotData.trailingGyroXData
        let totalSignalYGyro = shotData.leadingGyroYData + shotData.trailingGyroYData
        let totalSignalZGyro = shotData.leadingGyroZData + shotData.trailingGyroZData
        
         let o = (totalSignalXData.count)
         
         for j in 1...o {
         exportString = exportString + "\(Double(totalSignalXData[j-1])), "
         }
         
         for j in 1...o {
         exportString = exportString + "\(Double(totalSignalYData[j-1])), "
         }
         
         for j in 1...o {
         exportString = exportString + "\(Double(totalSignalZData[j-1])), "
         }
         
         for j in 1...o {
         exportString = exportString + "\(Double(totalSignalXGyro[j-1])), "
         }
         
         for j in 1...o {
         exportString = exportString + "\(Double(totalSignalYGyro[j-1])), "
         }
         
         for j in 1...o {
         exportString = exportString + "\(Double(totalSignalZGyro[j-1])), "
         }
         
       delegate?.didCaptureStroke(exportString)
        return exportString
        
    }
    
    func storeExportString (_ exportString: String) {
        let timestamp = Date().millisecondsSince1970
        os_log("Stroke Data: %@, %@", String(timestamp), exportString)}
    
    // MARK: Data and Delegate Management
    
    func updateMetricsDelegate() {
        delegate?.didUpdateMotion(self,gravityStr:gravityStr, rotationRateStr: rotationRateStr, userAccelStr: userAccelStr, attitudeStr: attitudeStr)
    }
}


