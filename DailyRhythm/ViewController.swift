//
//  ViewController.swift
//  DailyRythmn
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
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (timer) in
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
    
    /* Swipe right for cells */
    /*func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print("row of delete: \(indexPath.row)")
            // handle delete (by removing the data from your array and updating the tableview)
            var allEventsArray = [Event]()
            
            EventManager.getInstance().updateJSONEvents()
            
            allEventsArray = JSONDataManager.loadAll(Event.self)
            
            JSONDataManager.delete("\(allEventsArray[indexPath.row].eventID)")
            
            tableViewList.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            tableView.endUpdates()
            completionHandler(true)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            print("row of edit: \(indexPath.row)")
            completionHandler(true)
        }
//        edit.backgroundColor = UIColor(patternImage: UIImage(named: "Settings_white")!)
//        let image = imageWithImage(image: UIImage(named: "Settings_white")!, scaledToSize: CGSize(width: 60, height: 60))
//        edit.backgroundColor = UIColor(patternImage: image)
        let mute = UIContextualAction(style: UIContextualAction.Style.normal, title: "mute") { (action, sourceView, completionHandler) in
            print("row of mute: \(indexPath.row)")
            completionHandler(true)
        }
        mute.backgroundColor = UIColor.lightText
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }*/
    
    /* Swipe left for cells */
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            print("row of edit: \(indexPath.row)")
            settingsSelected = true
            currentEvent = tableViewList[indexPath.row]
            self.performSegue(withIdentifier: "toSettings", sender: nil)
            completionHandler(true)
        }
        //        edit.backgroundColor = UIColor(patternImage: UIImage(named: "Settings_white")!)
        //        let image = imageWithImage(image: UIImage(named: "Settings_white")!, scaledToSize: CGSize(width: 60, height: 60))
        //        edit.backgroundColor = UIColor(patternImage: image)
        let mute = UIContextualAction(style: .normal, title: "mute") { (action, sourceView, completionHandler) in
            print("row of mute: \(indexPath.row)")
            if (tableViewList[indexPath.row].mute == true) {
                tableViewList[indexPath.row].mute = false
                //TODO Image
                
            } else {
                tableViewList[indexPath.row].mute = false
                //TODO Image
            }
            tableViewList[indexPath.row].saveEventInJSON()
            completionHandler(true)
        }
        mute.backgroundColor = UIColor.blue
        //edit.backgroundColor = UIColor(patternImage: imageWithImage(image: UIImage(named: "Settings_white")!, scaledToSize: CGSize(width: 90, height: 90)))
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [edit, mute])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
    /* scales UIImages */
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
        return newImage
    }
    /* delete Event swipe right side */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
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
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Number of cells equal to listings in tableViewList
        return(tableViewList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewContollerTableViewCell
        
//        if(tableViewList[0].eventID == -1){
//            cell.cellLabel.text = ""
//            cell.textLabel?.text = ""
//            tableViewList.dropFirst()
//        }
        
        //writes the cellLabels
        cell.cellLabel.text = tableViewList[indexPath.row].eventName.capitalizingFirstLetter()
        cell.checkTwoDays(time: tableViewList[indexPath.row].timeTillGo, event: tableViewList[indexPath.row])
        cell.layer.backgroundColor = UIColor.clear.cgColor
//        cell.cellTime.text = "..."
        return(cell)
    }
    
//    func updateTableViewList(event: Event) {
//        var index = 0
//        if tableViewList.count == 0 { return }
//
//        for listElem in tableViewList {
//            var indexPath = IndexPath(row: index, section: 0)
//            if (listElem.eventID == event.eventID) {
//                tableViewList[index] = event
//                tableView(tableView, cellForRowAt: indexPath)
//                tableView.reloadData()
//            }
//            index = index + 1
//        }
//    }
    
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
//        view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrundBlau")!)
        view.backgroundColor = UIColor(rgb: 0x08acf9)
//        gifLogo.loadGif(name: "gif-dark-blue")

//        let img = UIImage(named: "mamor")!.alpha(1.0)
//        tableView.backgroundColor = UIColor(patternImage: img)
        tableView.backgroundColor = UIColor.white
        
//        print("getDate():\(EventManager.getInstance().getDate()) ")
//        let todaysDate = EventManager.getInstance().getTodaysDateWithTimeZone()
//        print("Das heutige Datum ist: \(todaysDate)")
     
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrundHell")!)
        //sets line between cells
        tableView.separatorInset = .zero
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        
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
            

//
            allEventsArray.sort(by: {$0.timeTillGo < $1.timeTillGo})
//
//        //adds to each notification an alarm
   //    pushNotifivation(allEventsArray: allEventsArray)
//
//        //deletes all Events and then adds all Events to the Table View
            tableViewList.removeAll()
            tableViewList.append(contentsOf: allEventsArray)
        
            for tempEvent in tableViewList {
                
            }
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
                        
                    }
                    
                } else {
                    
                    print("Error Occurred1")
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
        for tempEvent in allEventsArray {
            if (event.eventID == tempEvent.eventID) {
                tableViewList[index].timeTillGo = EventManager.getInstance().calcDifNowAndEvent(event: event) - (event.bufferTime + event.walkingTime + event.parkingTime) * 60 - (Int(travelTime))
                
//                var cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
//                cell?.textLabel?.textColor = .lightGray
                print(allEventsArray[index].timeTillGo)
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
            
            presentAlertWithTitle(title: "Erlaube \"Daily Rhythm\" auf deinen Standort zuzugreifen", message: "Um jedes Ereignis zeitlich optimal vorrauszuplanen benötigt die App dauerhaft Zugriff auf deinen Standort. Es werden keine Daten gespeichert oder an Dritte weitergegenen. Klicke auf Einstellungen und setze den Standortzugriff auf \"immer\".", options: "Verlassen", "Einstellungen", completion: {
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
            
            presentAlertWithTitle(title: "Erlaube \"Daily Rhythm\" auf deinen Standort zuzugreifen", message: "Um jedes Ereignis zeitlich optimal vorrauszuplanen benötigt die App dauerhaft Zugriff auf deinen Standort. Es werden keine Daten gespeichert oder an Dritte weitergegenen. Klicke auf Einstellungen und setze den Standortzugriff auf \"immer\".", options: "Verlassen", "Einstellungen", completion: {
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
            
            presentAlertWithTitle(title: "Erlaube \"Daily Rhythm\" auf deinen Standort zuzugreifen", message: "Um jedes Ereignis zeitlich optimal vorrauszuplanen benötigt die App dauerhaft Zugriff auf deinen Standort. Es werden keine Daten gespeichert oder an Dritte weitergegenen. Klicke auf Einstellungen und setze den Standortzugriff auf \"immer\".", options: "Verlassen", "Einstellungen", completion: {
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
        /*presentAlertWithTitle(title: "Titel", message: "Das ist die nachricht", options: "OK", "OK1", completion: {
            (option) in
            print("option: \(option)")
            switch(option) {
            case 0:
                print("option one")
                break
            case 1:
                print("option two")
            default:
                break
            }
        })*/
        
        
    }
}
