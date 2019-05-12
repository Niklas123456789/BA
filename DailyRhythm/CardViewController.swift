//
//  CardViewController.swift
//  DailyRhythm
//
//  Created by Niklas Großmann on 11.05.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import UIKit

class CardViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var bufferTime: UILabel!
    @IBOutlet weak var walkingTime: UILabel!
    @IBOutlet weak var parkingTime: UILabel!
    
    
    override func viewDidLoad() {
        
    }
    
    func setCardLabels(name: String, street: String, houseNr: String, city: String, notes: String, bufferTime: Int, walkingTime: Int, parkingTime: Int){
        nameLabel.text! = name
        streetLabel.text! = "\(street) + \(houseNr)"
        cityLabel.text! = city
        notesLabel.text? = notes
        /*bufferTime.text! = "\(bufferTime)"
        walkingTime.text! = "\(walkingTime)"
        parkingTime.text! = "\(parkingTime)"*/
    }
}
