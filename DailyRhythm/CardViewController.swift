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
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var streetLabel: UILabel?
    @IBOutlet weak var cityLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var notesLabel: UILabel?
    @IBOutlet weak var bufferLabel: UILabel?
    @IBOutlet weak var walkingLabel: UILabel?
    @IBOutlet weak var parkingLabel: UILabel?
    
    private static let instance = CardViewController()
    
    static func getInstance() -> CardViewController {
        return instance
    }
    override func viewDidLoad() {
        setCardLabels(
            name: tableViewList[cellClickedIndex].eventName,
            street: tableViewList[cellClickedIndex].streetName,
            houseNr: tableViewList[cellClickedIndex].houseNr,
            city: tableViewList[cellClickedIndex].cityName,
            notes: tableViewList[cellClickedIndex].eventNotes,
            eventTime: tableViewList[cellClickedIndex].eventDate.toString(dateFormat: "HH:mm  dd-MM-yyyy"),
            bufferTime: tableViewList[cellClickedIndex].bufferTime,
            walkingTime: tableViewList[cellClickedIndex].walkingTime,
            parkingTime: tableViewList[cellClickedIndex].parkingTime)
    }
    
    func setCardLabels(name: String, street: String, houseNr: String, city: String, notes: String, eventTime: String, bufferTime: Int, walkingTime: Int, parkingTime: Int){
        nameLabel?.text! = name.capitalizingFirstLetter()
        streetLabel?.text! = "\(street.capitalizingFirstLetter()) \(houseNr)"
        cityLabel?.text! = city.capitalizingFirstLetter()
        if (notes.isEmpty) {
            notesLabel?.text? = ""
        }else{
            notesLabel?.text? = "Notizen: \(notes.capitalizingFirstLetter())"
        }
        
        timeLabel?.text! = eventTime
        //print(bufferTime.description)
        bufferLabel?.text! = "\(bufferTime)"
        walkingLabel?.text! = "\(walkingTime)"
        parkingLabel?.text! = "\(parkingTime)"
    }
}
