//
//  EventViewController.swift
//  DailyRythmn
//
//  Created by Niklas Großmann on 13.01.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetAndNrLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //nameLabel.text = ViewController.tableViewList
        
        nameLabel.text = tableViewList[cellClickedIndex].eventName
        nameLabel.text?.capitalized
    }
}
