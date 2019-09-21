//
//  WorkoutManager.swift
//  Hawk WatchKit Extension
//
//  Created by Philip Mogull on 14/06/2019.
//  Copyright © 2019 Philip Mogull. All rights reserved.
//

import Foundation
import HealthKit
import os.log


/**
 `WorkoutManagerDelegate` exists to inform delegates of swing data changes.
 These updates can be used to populate the user interface.
 */
protocol WorkoutManagerDelegate: class {
    func didUpdateMotion(_ manager: WorkoutManager, gravityStr: String, rotationRateStr: String, userAccelStr: String, attitudeStr: String)
    
    func didCaptureStroke(_ strokeType: String)
    
    
    func activateWatchConnectivity()
}

class WorkoutManager: MotionManagerDelegate {
    
    
    func didCaptureStroke(_ strokeType: String) {
        delegate?.didCaptureStroke(strokeType)
    }
    
    let motionManager = MotionManager()
   let healthStore = HKHealthStore()
    
    weak var delegate: WorkoutManagerDelegate?
    var session: HKWorkoutSession?
    
    
    init() {
        motionManager.delegate = self
    }
    
    
    func startWorkout() {
        
        if !HKHealthStore.isHealthDataAvailable() {
            os_log("Problemos with healthkit")
        }
        
       // let healthStore = HKHealthStore()
        // Configure the workout session.
        
        
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .tennis
        workoutConfiguration.locationType = .outdoor
        
        do {session = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)}
        catch {fatalError("Unable to create the workout session!")}
        
        let builder = session!.associatedWorkoutBuilder()
        builder.beginCollection(withStart: Date()) { (success, error) in
        }

        motionManager.startUpdates()
        delegate?.activateWatchConnectivity()
    }
    
    func stopWorkout() {
        // If we have already stopped the workout, then do nothing.
        if (session == nil) {
            return
        }
        
        // Stop the device motion updates and workout session.
        motionManager.stopUpdates()
        //End current workout session
        session!.end()
        // Clear the workout session.
        session = nil
    }
    
    // MARK: MotionManagerDelegate
    
    func didUpdateMotion(_ manager: MotionManager, gravityStr: String, rotationRateStr: String, userAccelStr: String, attitudeStr: String) {
        delegate?.didUpdateMotion(self, gravityStr: gravityStr, rotationRateStr: rotationRateStr, userAccelStr: userAccelStr, attitudeStr: attitudeStr)
    }
}
