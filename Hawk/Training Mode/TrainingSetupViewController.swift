//
//  TrainingSetupViewController.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 03/09/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import UIKit

class TrainingSetupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    


    @IBOutlet weak var conditionPicker: UIPickerView!
    
    @IBOutlet weak var strokePicker: UIPickerView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    var conditionPickerData: [[String]] = [[String]]()
    var strokePickerData: [String] = [String]()
    
    var trainingCondition: [String] = ["","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        // Connect data:
        self.conditionPicker.delegate = self
        self.conditionPicker.dataSource = self
        self.strokePicker.delegate = self
        self.strokePicker.dataSource = self
        
        // Input the data into the array
        conditionPickerData = [["Court Surface","Hard", "Clay", "Grass", "Other"],
        ["Weather","Sunny", "Overcast", "Rainy", "Other"]]
        
        strokePickerData=["Stroke Type","Forehand Top Spin", "Backhand Top Spin", "Serve", "Forehand Slice", "Backhand Slice"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == conditionPicker {
            return 2
        }
        if pickerView == strokePicker {
            return 1
        }
        return 0
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == conditionPicker {
            return conditionPickerData[0].count
        }
        if pickerView == strokePicker {
            return strokePickerData.count
        }
            return 0
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == conditionPicker {
            return conditionPickerData[component][row]
        }
        if pickerView == strokePicker {
            return strokePickerData[row]
        }
        
        return conditionPickerData[component][row]
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleNavBar(self)
        Utilities.styleFilledButton(startButton)
        
    }
    
    // send information about conditions to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let trainingViewController = segue.destination as? TrainingViewController
            else {
                return
        }
        trainingViewController.trainingCondition = trainingCondition
    }
    
    
    @IBAction func startButtonTapped(_ sender: Any) {
        
        let err = validateFields()
        
        if err != nil {
            showError(err!)
        }
        
        else {
            let stroke = strokePicker.selectedRow(inComponent: 0)
            trainingCondition[0] = strokePickerData[strokePicker.selectedRow(inComponent: 0)]
            trainingCondition[1] = conditionPickerData[0][conditionPicker.selectedRow(inComponent: 0)]
            trainingCondition[2] = conditionPickerData[1][conditionPicker.selectedRow(inComponent: 1)]
            
            performSegue(withIdentifier: "trainingSegue", sender: nil)
        }
    }
    
    func validateFields() -> String? {
        
        let strokeVal = strokePicker.selectedRow(inComponent: 0)
        let courtVal = conditionPicker.selectedRow(inComponent: 0)
        let weatherVal = conditionPicker.selectedRow(inComponent: 1)
        if strokeVal == 0 || courtVal == 0 || weatherVal == 0 {
            return "Please fill in all fields"
        }
        errorLabel.alpha=0
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text=message
        errorLabel.alpha=1
    }
    
    
}
