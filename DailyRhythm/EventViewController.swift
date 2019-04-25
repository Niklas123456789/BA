//
//  EventViewController.swift
//  DailyRythmn
//
//  Created by Niklas Großmann on 13.01.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EventViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetAndNrLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var timeTillGoLabel: UILabel!
    var timer: Timer!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocationServices()

        // Do any additional setup after loading the view.
        
        //nameLabel.text = ViewController.tableViewList
        
        nameLabel.text = tableViewList[cellClickedIndex].eventName
        nameLabel.text = nameLabel.text?.capitalizingFirstLetter()
        var street = tableViewList[cellClickedIndex].streetName
        street = street.capitalizingFirstLetter()
        streetAndNrLabel.text = "\(street) \(tableViewList[cellClickedIndex].houseNr)"
        timeLabel.text = tableViewList[cellClickedIndex].eventDate.toString(dateFormat: "HH:mm  dd-MM-yyyy")
        
        if (tableViewList[cellClickedIndex].eventNotes.isEmpty) {
            notesLabel.text = "Keine Notizen"
            notesLabel.textColor = UIColor.gray
        } else {
            notesLabel.text = tableViewList[cellClickedIndex].eventNotes.capitalizingFirstLetter()
            notesLabel.textColor = UIColor.black
        }
        var event = EventManager.getInstance().getEventwithID(eventID: "\(tableViewList[cellClickedIndex].eventID)")
        if event.eventID == "-1" {
            print("getEventwithID returned noEvent")
            return
        }
        var timeTillGo = EventManager.getInstance().getTimeTillGo(event: event)
        
        var(t, m, s) = self.secondsToHoursMinutesSeconds(seconds: timeTillGo)
        ausgeben(h: t, m: m, s: s)
        startTimer(timeInSeconds: timeTillGo, event: event)
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            //setup location manager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //Show POP UP that location is turned off
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //TODO: Show popup alert
            break
        case .denied:
            //TODO: Show popup alert
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            //TODO: Show popup alert
            break
        case .authorizedAlways:
            mapView.showsUserLocation = true
            //mapView.showsTraffic = true
            break
        }
    }
    
    func startTimer(timeInSeconds: Int, event: Event){
        
        var secondsLeft: Int = timeInSeconds
        if(timeInSeconds <= 86400){
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                
                var(h, m, s) = self.secondsToHoursMinutesSeconds(seconds: secondsLeft)
                
                self.ausgeben(h: h, m: m, s: s)
                secondsLeft = secondsLeft - 1
                
                //TODO:muss noch an event angepasst werden
                if(secondsLeft == -300){
                    self.timer.invalidate()
                }
            }
            )}else{
            //was tun wenn zeit noch über 24h?
            self.timeTillGoLabel.text = "+24h"
        }
    }
    func ausgeben(h: Int, m: Int, s: Int){

        if(h==0){
            if(abs(s) <= 9 && s >= 0){
                self.timeTillGoLabel.text = "\(m):0\(s)"
            }else{
                self.timeTillGoLabel.text = "\(m):\(s)"
                if(m==0){
                    //-9 muss noch entschieden werden wie lange weiterlaeuft
                    if(abs(s) <= 9 && s >= -9 && s != 0){
                        
                        self.timeTillGoLabel.text = "\(s)"
                        
                        //groesere Schrift vllt
                    }else{
                        self.timeTillGoLabel.text = "\(m):\(s)"
                    }
                }
            }
        }else{
            if(m==0 && abs(s) >= 0){
                self.timeTillGoLabel.text = "\(h):0\(m):0\(s)"
            }else{
                if(abs(s) <= 9 && s >= 0){
                    self.timeTillGoLabel.text = "\(h):\(m):0\(s)"
                }else{
                    self.timeTillGoLabel.text = "\(h):\(m):\(s)"
                    self.timeTillGoLabel.sizeToFit()
                }
            }
        }
        print(("\(h):\(m):\(s)"))
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
extension EventViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}
