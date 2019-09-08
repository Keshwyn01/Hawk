//
//  RunningBuffer.swift
//  PerformanceTennisTracking WatchKit Extension
//
//  Created by Philip Mogull on 24/02/2019.
//  Copyright © 2019 Philip Mogull. All rights reserved.
//

import Foundation
import WatchKit
import CoreMotion


class ShotManager {
    // MARK: Properties
    
    var leadingSignalXData = [Double]()
    var trailingSignalXData = [Double]()
    
    var leadingSignalYData = [Double]()
    var trailingSignalYData = [Double]()
    
    var leadingSignalZData = [Double]()
    var trailingSignalZData = [Double]()
    
    var leadingGyroXData = [Double]()
    var trailingGyroXData = [Double]()
    
    var leadingGyroYData = [Double]()
    var trailingGyroYData = [Double]()
    
    var leadingGyroZData = [Double]()
    var trailingGyroZData = [Double]()
    
    
    var size = 0
    var hasShotBeenDetected = false
    var hasShotBeenStored = false
    
    // MARK: Initialization
    
    init(size: Int) {
        self.size = size
    }
    
    // MARK: Running Buffer
    
    func addSample(_ sample: CMDeviceMotion) {
        
        let xAcceleration = sample.userAcceleration.x.rounded(toPlaces: 4)
        let yAcceleration = sample.userAcceleration.y.rounded(toPlaces: 4)
        let zAcceleration = sample.userAcceleration.z.rounded(toPlaces: 4)
        
        let xGyro = sample.rotationRate.x.rounded(toPlaces: 4)
        let yGyro = sample.rotationRate.y.rounded(toPlaces: 4)
        let zGyro = sample.rotationRate.z.rounded(toPlaces: 4)
        
        let accelerationMagnitude = (xAcceleration*xAcceleration + yAcceleration*yAcceleration + zAcceleration*yAcceleration).squareRoot()
        
        if (accelerationMagnitude > 5) && (self.leadingSignalXData.count == 192) {
            self.hasShotBeenDetected = true
            WKInterfaceDevice.current().play(.notification)
        }
        
        if self.hasShotBeenDetected == false {
            self.leadingSignalXData.append(xAcceleration)
            self.leadingSignalYData.append(yAcceleration)
            self.leadingSignalZData.append(zAcceleration)
            self.leadingGyroXData.append(xGyro)
            self.leadingGyroYData.append(yGyro)
            self.leadingGyroZData.append(zGyro)
            
            if self.leadingSignalXData.count > 192 {
                self.leadingSignalXData.removeFirst()
                self.leadingSignalYData.removeFirst()
                self.leadingSignalZData.removeFirst()
                self.leadingGyroXData.removeFirst()
                self.leadingGyroYData.removeFirst()
                self.leadingGyroZData.removeFirst()
            }
        }
        
        if self.hasShotBeenDetected == true && self.trailingSignalXData.count < 192 {
            self.trailingSignalXData.append(xAcceleration)
            self.trailingSignalYData.append(yAcceleration)
            self.trailingSignalZData.append(zAcceleration)
            self.trailingGyroXData.append(xGyro)
            self.trailingGyroYData.append(yGyro)
            self.trailingGyroZData.append(zGyro)
        }
        
        if self.hasShotBeenDetected == true && self.trailingSignalXData.count == 192 {
            self.hasShotBeenStored = true
        }
    }
    
    
    
    func reset() {
        leadingSignalXData.removeAll(keepingCapacity: true)
        trailingSignalXData.removeAll(keepingCapacity: true)
        
        leadingSignalYData.removeAll(keepingCapacity: true)
        trailingSignalYData.removeAll(keepingCapacity: true)
        
        leadingSignalZData.removeAll(keepingCapacity: true)
        trailingSignalZData.removeAll(keepingCapacity: true)
        
        leadingGyroXData.removeAll(keepingCapacity: true)
        trailingGyroXData.removeAll(keepingCapacity: true)
        
        leadingGyroYData.removeAll(keepingCapacity: true)
        trailingGyroYData.removeAll(keepingCapacity: true)
        
        leadingGyroZData.removeAll(keepingCapacity: true)
        trailingGyroZData.removeAll(keepingCapacity: true)
        
        hasShotBeenDetected = false
        hasShotBeenStored = false
    }
    
    
    func recentMean() -> Double {
        // Calculate the mean over the beginning half of the buffer.
        let recentCount = self.size / 2
        var mean = 0.0
        if (leadingSignalXData.count >= recentCount) {
            let recentBuffer = leadingSignalXData[0..<recentCount]
            mean = recentBuffer.reduce(0.0, +) / Double(recentBuffer.count)
        }
        return mean
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


