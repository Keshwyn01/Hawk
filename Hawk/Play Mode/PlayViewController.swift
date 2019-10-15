//
//  PlayViewController.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 20/09/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import UIKit
import os.log


class PlayViewController: UIViewController, PlaySessionHandlerDelegate {
    
    //let mlConstants = MLConstants()
    
    @IBOutlet weak var summaryButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var classificationAccuracyLabel: UILabel!
    
    let motionAnalyser = MotionAnalysis()
    var count = 0
    var strokeSummary = [0,0,0,0,0]
    
    var squareBox: UILabel!
    var category: UIView!
    var categoryTopMarker:UILabel!
    var categoryStrokeType:UILabel!
    
    func updateLabel(_ message: String) {
        DispatchQueue.main.async {
            self.categoryStrokeType.text = message
           // os_log("Message Recieved By iPhone")
        }

    }
    
    func updateSpeedLabel(_ speed: Double) {
            let a:String = String(format:"%.1f", speed)
            speedLabel.text = "Speed: \(a)"
    }
    
    func updateClassAccuracyLabel(_ value: Double) {
            let a:String = String(format:"%.1f", value)
            classificationAccuracyLabel.text = "Accuracy: \(a)"
    }
    
    func updateCount() {
        DispatchQueue.main.async {
            self.count += 1
            self.countLabel.text = "Count: \(self.count)"
        }
        
    }
    
    
    func analyseStroke(_ fileURL: URL) {
        
        var strokeData = ""
        
        do {
            strokeData = try String(contentsOfFile: fileURL.path)
            } catch {
                print(error.localizedDescription)
            }
        
        let data = reshapeData(strokeData)
        let speed = motionAnalyser.strokeMetric(data)
        let strokeClass = motionAnalyser.classifyStroke(data)
        
        
        print(strokeClass)
        trackStrokes(strokeClass[1] as! String)
        updateLabel(strokeClass[1] as! String)
        DispatchQueue.main.async {
            self.category.blink()
            self.updateSpeedLabel(speed)
            if let val = strokeClass[0] as? Double {
                self.updateClassAccuracyLabel(val)
            } else{
                
            }

        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        PlaySessionHandler.shared.sessionHandlerDelegate = self
        setUpElements()
    }
    
    // send information about conditions to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let summaryViewController = segue.destination as? SummaryViewController
            else {
                return
        }
        summaryViewController.strokeSummary = strokeSummary
    }
    
    
    func reshapeData(_ strokeData: String) -> [Double] {
        let StringRecordedArr = strokeData.components(separatedBy: ",")
        let newData: [Double] = StringRecordedArr.compactMap{ str in Double (str) }
        //print(newData.count)
        return newData
        }
        
    func trackStrokes(_ strokeClass: String) {
        
        if strokeClass == "FT" {
            strokeSummary[0] += 1
        } else if strokeClass == "BT" {
            strokeSummary[1] += 1
        } else if strokeClass == "S" {
            strokeSummary[2] += 1
        } else if strokeClass == "FS" {
            strokeSummary[3] += 1
        } else if strokeClass == "BS" {
            strokeSummary[4] += 1
        } else {
            print("Stroke not classified")
        }
    
    }
    
    func setUpElements() {
        
        addCategorySubview()
        addHeaderSubview()
        Utilities.styleHollowButton(summaryButton)
        Utilities.styleNavBar(self)
    
    }
    
    func addCategorySubview() {
           category = UIView()
           category.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
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


extension UIView{
     func blink() {
         self.alpha = 0.2
         UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear], animations: {self.alpha = 1.0}, completion: nil)
     }
}
