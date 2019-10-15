//
//  MotionAnalysis.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 20/09/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import Foundation


class MotionAnalysis {
 
    func classifyStroke (_ totalData: [Double]) -> [Int: Any] {
        
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
                
                var maximumIndex = 1000
                var strokeClass = [Int: Any]()
        
                if let maxValue = weights.max() {
                    
                    maximumIndex = weights.firstIndex(of: maxValue)!
                    strokeClass[0] = maxValue
                }
                
        
                if maximumIndex == 0 {
                    strokeClass[1] = "FT"
                } else if maximumIndex == 1 {
                    strokeClass[1] = "BT"
                } else if maximumIndex == 2 {
                    strokeClass[1] = "S"
                } else if maximumIndex == 3 {
                    strokeClass[1] = "FS"
                } else if maximumIndex == 4 {
                    strokeClass[1] = "BS"
                } else {
                    strokeClass[1] = "Fatal Error"
                }
        return strokeClass
    }
    
    func strokeMetric (_ totalData: [Double]) -> Double {
        
        let trailingGyroYData = Array(totalData[1727...1919])
        let trailingGyroZData = Array(totalData[2111...2303])
              
        let o = (trailingGyroYData.count)
        let p = (trailingGyroZData.count)
        
        var spin = 0.0
        var speed = 0.0
              
         for i in 1...o {
            if ((trailingGyroYData[i-1] * 0.68) > speed) {
          speed = trailingGyroYData[i-1] * 0.68
                 }
               if (-trailingGyroYData[i-1] * 0.68 > speed) {
                    speed = -trailingGyroYData[i-1] * 0.68
                  }
              }
              
             for i in 1...p {
                  if ((trailingGyroZData[i-1] * 0.68) > spin) {
                      spin = trailingGyroZData[i-1] * 0.68
                  }
                  if (-trailingGyroZData[i-1] * 0.68 > spin) {
                      spin = -trailingGyroZData[i-1] * 0.68
                }
              }
    print(speed)
    print(spin)
        
    return speed
    }
    
    
}
