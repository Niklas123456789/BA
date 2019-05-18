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
    @IBOutlet weak var expectedTravelTimeLabelMin: UILabel?
    @IBOutlet weak var expectedTravelTimeLabelHours: UILabel!
    @IBOutlet weak var stundenLabel1: UILabel!
    @IBOutlet weak var hoursLabel1: UILabel!
    @IBOutlet weak var stundenLabel2: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet weak var totalMinLabel: UILabel!
    
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
        
        setExpectedTravelTime()
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
    
    func setExpectedTravelTime() {
        var timer: Timer?
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
            if ((expectedTravelTime == -1) || (expectedTravelTimeUpdated == false)) {
                print("no expectedTavelTime")
                self.handleArea.isUserInteractionEnabled = false
            } else {
                if (expectedTravelTime > 60) {
                    var (t, h, m) = EventViewController2.getInstance().secondsToHoursMinutesSeconds(seconds: expectedTravelTime)
                    self.expectedTravelTimeLabelMin?.text! = "\(m)"
                    self.hoursLabel1.text = "\(h)"
                    self.stundenLabel1.isHidden = false
                } else {
                    self.expectedTravelTimeLabelMin?.text! = "~\(expectedTravelTime)"
                    
                    
                }
                //TODO: calc insgasammte Zeit
                self.setTotalTravelTime()
                timer.invalidate()
            }
        })
    }
    func setTotalTravelTime() {
        var totalTravelTime = Int(bufferLabel!.text!)! + Int(walkingLabel!.text!)! + Int(parkingLabel!.text!)! + expectedTravelTime
        if (totalTravelTime > 60) {
            var (t, h, m) = EventViewController2.getInstance().secondsToHoursMinutesSeconds(seconds: totalTravelTime)
            self.totalMinLabel.text = "\(m)"
            self.totalHoursLabel.text = "\(h)"
            self.stundenLabel2.isHidden = false
        } else {
            self.totalMinLabel.text = "\(totalTravelTime)"
        }
        self.handleArea.isUserInteractionEnabled = true
        print("setTotalTravelTime \(totalTravelTime)")
    }
    
}
