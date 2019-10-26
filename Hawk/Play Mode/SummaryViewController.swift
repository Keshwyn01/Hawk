//
//  SummaryViewController.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 21/09/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    var strokeSummary: [Int]?
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var ftsCount: UILabel!
    @IBOutlet weak var btsCount: UILabel!
    @IBOutlet weak var sCount: UILabel!
    @IBOutlet weak var fsCount: UILabel!
    @IBOutlet weak var bsCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    @IBAction func dimissButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(dismissButton)
        Utilities.styleNavBar(self)
        guard let summary = strokeSummary else {
            return
        }
        //print(summary)
        ftsCount.text = "Forehand Top Spin: \(summary[0])"
        btsCount.text = "Backhand Top Spin: \(summary[1])"
        sCount.text = "Serve: \(summary[2])"
        fsCount.text = "Forehand Slice: \(summary[3])"
        bsCount.text = "Backhand Slide: \(summary[4])"
    }

}
