//
//  MotionAnalysis.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 20/09/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import Foundation


class MotionAnalysis {
 
    func classifyStroke (_ totalData: [Double]) -> String {
        
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
                    maximumIndex = weights.firstIndex(of: maxValue)!
                }
                
                if maximumIndex == 0 {
                    return "FT"
                } else if maximumIndex == 1 {
                    return "BT"
                } else if maximumIndex == 2 {
                    return "S"
                } else if maximumIndex == 3 {
                    return "FS"
                } else if maximumIndex == 4 {
                    return "BS"
                } else {
                    return "Fatal Error"
                }
    }
    
    
}
