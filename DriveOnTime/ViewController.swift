//
//  ViewController.swift
//  Drive on time
//
//  Created by Niklas Großmann on 07.11.18.
//  Copyright © 2018 Mobile_App_Uni_Ulm. All rights reserved.
//

import UIKit
import UserNotifications
import AudioToolbox
import MapKit
import CoreLocation

let locationManager = CLLocationManager()
var cellClickedIndex = 0
var tableViewList = [Event]()
var group6 = DispatchGroup()
var refreshControl: UIRefreshControl?

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var gifLogo: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private static let instance = ViewController()
    
    
    static func getInstance() -> ViewController {
        return instance
    }
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    @objc func refreshList() {
        
        var allEventsArray = [Event]()
        
        EventManager.getInstance().updateJSONEvents()
        
        allEventsArray = JSONDataManager.loadAll(Event.self)
        
        var index = 0
        for event in allEventsArray {
            
            getETARequest(destination: CLLocationCoordinate2DMake(event.latitude, event.longitude), event: event, index: index)

            print("TimeTillGo1 in ViewController: \(allEventsArray[index].timeTillGo)")
            index = index + 1
        }
        var timer = Timer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { (timer) in
                refreshControl?.endRefreshing()
        })

        
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveEvent" {
            expectedTravelTime = -1
        }
        if segue.identifier == "exit" {
            expectedTravelTime = -1
        }
        if segue.identifier == "saveSettings" {
            expectedTravelTime = -1
        }
        if segue.identifier == "exitToEvent" {
            expectedTravelTime = -1
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action =  UIContextualAction(style: .normal, title: "Edit", handler: { (action,view,completionHandler ) in
            //do stuff
            print("row of edit: \(indexPath.row)")
            settingsSelected = true
            currentEvent = tableViewList[indexPath.row]
            self.performSegue(withIdentifier: "toSettings", sender: nil)
            
            completionHandler(true)
        })
        action.image = UIImage(named: "settings.png")
        action.backgroundColor = .lightGray
        let confrigation = UISwipeActionsConfiguration(actions: [action])
        
        return confrigation
    }

    
    /* scales UIImages */
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
        return newImage
    }
    /* delete swipe */
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action =  UIContextualAction(style: .normal, title: "Delete", handler: { (action,view,completionHandler ) in
            
            // handle delete (by removing the data from your array and updating the tableview)
            var allEventsArray = [Event]()
            
            EventManager.getInstance().updateJSONEvents()
            
            allEventsArray = JSONDataManager.loadAll(Event.self)
            if !(allEventsArray.isEmpty) {
                JSONDataManager.delete("\(allEventsArray[indexPath.row].eventID)")
            }
            
            
            
            tableViewList.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            tableView.endUpdates()
            
            completionHandler(true)
        })
        action.image = UIImage(named: "bin.png")
        action.backgroundColor = .red
        let confrigation = UISwipeActionsConfiguration(actions: [action])
        
        return confrigation
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Number of cells equal to listings in tableViewList
        return(tableViewList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewContollerTableViewCell
        

        
        //writes the cellLabels
        cell.cellLabel.text = tableViewList[indexPath.row].eventName.capitalizingFirstLetter()
        
        cell.checkTwoDays(time: tableViewList[indexPath.row].timeTillGo, event: tableViewList[indexPath.row])
        cell.layer.backgroundColor = UIColor.clear.cgColor
//        cell.cellTime.text = "..."
        return(cell)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellClickedIndex = indexPath.row
        performSegue(withIdentifier: "segue2", sender: self)
    }

    //set hight of each cell too 95
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return(95)
    }
    
    func setETT(event: Event, travelTime: Int){
        
        var allEventsArray = [Event]()
        
        EventManager.getInstance().updateJSONEvents()
        allEventsArray = JSONDataManager.loadAll(Event.self)
        
        var index = 0
        for event in allEventsArray {
            allEventsArray[index].timeTillGo =
        EventManager.getInstance().calcDifNowAndEvent(event: event) - (event.bufferTime + event.walkingTime + event.parkingTime) * 60 - travelTime
            
            index += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkLocationAuthorization()
        refreshList()
    }
    override func viewDidAppear(_ animated: Bool) {
        checkLocationAuthorization()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("{ViewController}")
        addRefreshControl()
        view.backgroundColor = UIColor(rgb: 0x08acf9)
        tableView.backgroundColor = UIColor.white
        

        //sets line between cells
        tableView.separatorInset = .zero
        
        
        if(settingsSelected == true) {
//            settingsSelected = false
            performSegue(withIdentifier: "segue2", sender: self)
        }
        // Do any additional setup after loading the view, typically from a nib.
        var allEventsArray = [Event]()
        
        EventManager.getInstance().updateJSONEvents()
        
        allEventsArray = JSONDataManager.loadAll(Event.self)
        
        var index = 0
        for event in allEventsArray {
            
            getETARequest(destination: CLLocationCoordinate2DMake(event.latitude, event.longitude), event: event, index: index)
            
//            allEventsArray[index].timeTillGo = EventManager.getInstance().calcDifNowAndEvent(event: event) - (event.bufferTime + event.walkingTime + event.parkingTime) * 60 /* - 1 */
            print("TimeTillGo2 in ViewController: \(allEventsArray[index].timeTillGo)")
            index = index + 1
        }
        print(allEventsArray)
        //add JSON-Events to table
        for indexEventCount in 0..<allEventsArray.count {
            //loads Events into allEventArray
            
            allEventsArray.sort(by: {$0.timeTillGo < $1.timeTillGo})

//        //deletes all Events and then adds all Events to the Table View
            tableViewList.removeAll()
            tableViewList.append(contentsOf: allEventsArray)
        }
    }
    

    
    
    func getETARequest(destination:CLLocationCoordinate2D, event: Event, index: Int) {
        
        let request = MKDirections.Request()
        
        if let currentLocation = locationManager.location?.coordinate {
            
            request.source =  MKMapItem(placemark: MKPlacemark(coordinate: currentLocation, addressDictionary: nil))
            
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
            
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            
            directions.calculateETA(completionHandler: { ( response, error) in
                
                if error == nil {
                    
                    if let interval = response?.expectedTravelTime  {
                        
                        print("ETARequest \(interval)")
                        
                        self.updateTableWithETA(travelTime: Int(interval), event: event, index: index)
//                        self.tableView(self.tableView, cellForRowAt: IndexPath(row: index, section: 0))
                    }
                    
                } else {
                
                    print("Error Occurred1")
                    print(error)
                }
                
            })
            
        }
    }

    func updateTableWithETA(travelTime: Int, event: Event, index: Int) {
        print("ETA Tracel time: \(travelTime) of Event: \(event.eventName)")
        var allEventsArray = [Event]()
        EventManager.getInstance().updateJSONEvents()
        allEventsArray = JSONDataManager.loadAll(Event.self)
        
        group6.enter()
        var tempCount = 0
        for tempEvent in allEventsArray {
            if (event.eventID == tempEvent.eventID) {
                tableViewList[index].timeTillGo = EventManager.getInstance().calcDifNowAndEvent(event: event) - (event.bufferTime + event.walkingTime + event.parkingTime) * 60 - (Int(travelTime))
                
                let indexPath = IndexPath(row: tempCount, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ViewContollerTableViewCell
                cell.checkTwoDays(time: tableViewList[index].timeTillGo, event: event)
//                print(allEventsArray[index].timeTillGo)
                
//                THIS LINE COULD BE IMPORTANT
                self.tableView.reloadRows(at: [indexPath], with: .fade)
                tempCount = tempCount + 1
//
            }
            
            print("TimeTillGo3 in ViewController: \(tableViewList[index].timeTillGo)")
            
        }
        group6.leave()
//        print(allEventsArray)
        
        //add Events to table
        group6.notify(queue: DispatchQueue.main) {
            allEventsArray.sort(by: {$0.timeTillGo < $1.timeTillGo})
            print("tableViewList1: \(tableViewList)")
//            tableViewList.sort(by: {$0.timeTillGo < $1.timeTillGo})
            
            self.tableView.reloadData()
        }
    }
    
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            
            presentAlertWithTitle(title: "Erlaube \"DriveOnTime\" auf deinen Standort zuzugreifen", message: "Um jedes Ereignis zeitlich optimal vorrauszuplanen, benötigt die App dauerhaft Zugriff auf deinen Standort. Es werden keine standortbezogenen Daten gespeichert! Klicke auf Einstellungen und setze den Standortzugriff auf \"immer\".", options: "Verlassen", "Einstellungen", completion: {
                (option) in
                print("option: \(option)")
                switch(option) {
                case 0:
                    UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                           to: UIApplication.shared, for: nil)
                    break
                case 1:
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                default:
                    break
                }
            })
            break
        case .denied:
            
            presentAlertWithTitle(title: "Erlaube \"DriveOnTime\" auf deinen Standort zuzugreifen", message: "Um jedes Ereignis zeitlich optimal vorrauszuplanen, benötigt die App dauerhaft Zugriff auf deinen Standort. Es werden keine standortbezogenen Daten gespeichert! Klicke auf Einstellungen und setze den Standortzugriff auf \"immer\".", options: "Verlassen", "Einstellungen", completion: {
                (option) in
                print("option: \(option)")
                switch(option) {
                case 0:
                    UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                           to: UIApplication.shared, for: nil)
                    break
                case 1:
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                default:
                    break
                }
            })
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            
            presentAlertWithTitle(title: "Erlaube \"DriveOnTime\" auf deinen Standort zuzugreifen", message: "Um jedes Ereignis zeitlich optimal vorrauszuplanen, benötigt die App dauerhaft Zugriff auf deinen Standort. Es werden keine standortbezogenen Daten gespeichert! Klicke auf Einstellungen und setze den Standortzugriff auf \"immer\".", options: "Verlassen", "Einstellungen", completion: {
                (option) in
                print("option: \(option)")
                switch(option) {
                case 0:
                    UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                           to: UIApplication.shared, for: nil)
                    break
                case 1:
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                default:
                    break
                }
            })
            break
        case .authorizedAlways:
            break
        }
    }
    @IBAction func settingsButtonAction(_ sender: Any) {
    }
}
