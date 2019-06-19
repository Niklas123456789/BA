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
    
    @IBOutlet weak var hold: UIView!
    @IBOutlet weak var activityIndicatorETT: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorTTT: UIActivityIndicatorView!
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
    @IBOutlet weak var sumLine: UIImageView!
    
    private static let instance = CardViewController()
    
    static func getInstance() -> CardViewController {
        return instance
    }
    override func viewDidLoad() {
        currentEvent = tableViewList[cellClickedIndex]
        
        hold.backgroundColor = UIColor(patternImage: UIImage(named: "hold")!)
        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        
        let eventDateString = currentEvent.eventDate.addingTimeInterval(TimeInterval(-secondsFromGMT)).toString(dateFormat: "HH:mm  dd-MM-yyyy")
        
        
        setCardLabels(
            name: tableViewList[cellClickedIndex].eventName,
            street: tableViewList[cellClickedIndex].streetName,
            houseNr: tableViewList[cellClickedIndex].houseNr,
            city: tableViewList[cellClickedIndex].cityName,
            notes: tableViewList[cellClickedIndex].eventNotes,
            eventTime: eventDateString,
            bufferTime: tableViewList[cellClickedIndex].bufferTime,
            walkingTime: tableViewList[cellClickedIndex].walkingTime,
            parkingTime: tableViewList[cellClickedIndex].parkingTime)
        
        setExpectedTravelTime()
        
        //farbverlauf
        setGradientBackground()
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor.lightGray.withAlphaComponent(0.4).cgColor
//            UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor.white.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 5)
        
        self.handleArea.layer.insertSublayer(gradientLayer, at:0)
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
        setLabelsWithNoETT()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            if (expectedTravelTime == -1) {
                //print("no expectedTavelTime")
                //self.handleArea.isUserInteractionEnabled = false
            } else {
                if (expectedTravelTime > 60) {
                    var (t, h, m) = EventViewController2.getInstance().secondsToHoursMinutesSeconds(seconds: expectedTravelTime)
                    self.expectedTravelTimeLabelMin?.text! = "\(m + 1)"
                    self.hoursLabel1.text = "\(h)"
                    self.stundenLabel1.isHidden = false
                    
                } else {
                    self.expectedTravelTimeLabelMin?.text! = "\(expectedTravelTime + 1)"
                    
                    
                }
                self.setTotalTravelTime()
                timer.invalidate()
            }
        })
    }
    func setTotalTravelTime() {
        var totalTravelTime = Int(bufferLabel!.text!)! + Int(walkingLabel!.text!)! + Int(parkingLabel!.text!)! + expectedTravelTime
        if (totalTravelTime > 60) {
            var (t, h, m) = EventViewController2.getInstance().secondsToHoursMinutesSeconds(seconds: totalTravelTime)
            self.totalMinLabel.text = "\(m + 1)"
            self.totalHoursLabel.text = "\(h)"
            self.stundenLabel2.isHidden = false
        } else {
            self.totalMinLabel.text = "\(totalTravelTime + 1)"
        }
        self.handleArea.isUserInteractionEnabled = true
        activityIndicatorTTT.stopAnimating()
        activityIndicatorETT.stopAnimating()
        print("setTotalTravelTime \(totalTravelTime)")
    }
    
    func setLabelsWithNoETT() {
        self.expectedTravelTimeLabelMin!.text = ""
        self.totalMinLabel!.text = ""
        //activityIndicatorETT
        activityIndicatorETT.center = self.expectedTravelTimeLabelMin!.center
        activityIndicatorETT.hidesWhenStopped = true
        activityIndicatorETT.color = UIColor.black
        activityIndicatorETT.style = UIActivityIndicatorView.Style.gray
        activityIndicatorETT.startAnimating()
        
        //activityIndicatorTTT
        activityIndicatorTTT.startAnimating()
        activityIndicatorTTT.center = CGPoint(x: 241 + self.totalMinLabel.frame.width/2, y: 119 + self.totalMinLabel.frame.height/2)
        activityIndicatorTTT.hidesWhenStopped = true
        activityIndicatorTTT.color = UIColor.black
        activityIndicatorTTT.style = UIActivityIndicatorView.Style.gray
        activityIndicatorTTT.startAnimating()
        
        
        
    }
    
}
