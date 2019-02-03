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

var cellClickedIndex = 0
var tableViewList = [Event]()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    
    
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
        cell.cellLabel.text = tableViewList[indexPath.row].eventName
        cell.checkTwoDays(time: tableViewList[indexPath.row].eventTotalSeconds)
        
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellClickedIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }

    //set hight of each cell too 95
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return(95)
    }

    

    //NOTIFICATIONS
    func pushNotifivation(allEventsArray: [Event]){
        
        //TODO alle bestehenden notifications löschen
        
        var index = 0
        let numberOfNotifications = allEventsArray.count
        //removes all existing pending notifications before creating new ones
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        //empty allEventArray
        if((allEventsArray.count == 1 && allEventsArray[0].eventID == -1)){
            
            print("ViewController allEventArray is empty")
        }else{
        //creates one notification for each event
            while(true){

                let content = UNMutableNotificationContent()
                content.title = "\(allEventsArray[index].eventName)"
                
                //sets the content of the notification
                if(allEventsArray[index].eventNotes == ""){
                    content.body = "Mit deinem Puffer von \(allEventsArray[index].bufferTime) Minuten musst du jetzt los!"
                }else{
                    content.body = allEventsArray[index].eventNotes
                }
                //adds vibration
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                //sets the notification sound
                content.sound = UNNotificationSound.default
                
                //creates trigger with the right time
                let totalTravelTime = allEventsArray[index].eventTotalSeconds - (allEventsArray[index].bufferTime * 60) - (allEventsArray[index].parkingTime * 60) -
                    (allEventsArray[index].walkingTime * 60) + 1
                
                if(totalTravelTime > 0){
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(totalTravelTime), repeats: false)
                    
                    let request = UNNotificationRequest(identifier: "\(allEventsArray[index].eventID)", content: content, trigger: trigger)
                    
                    center.add(request, withCompletionHandler: nil)
                }
                //breaks while(true)-loop when every notification is set
                index = index + 1
                if(index == numberOfNotifications){
                    break
                }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let emptyEvent: EventOLD = EventOLD(eventID: -1, eventName: "emptyCell", eventTotalSeconds: 3)
//        //testEvent
//        let testEvent0: EventOLD = EventOLD(eventID: 0, eventName: "Test0", eventTotalSeconds: 666)
//        let testEvent1: EventOLD = EventOLD(eventID: 1, eventName: "Test1", eventTotalSeconds: 30)
//        let testEvent2: EventOLD = EventOLD(eventID: 2, eventName: "Test2", eventTotalSeconds: 16)
//        let testEvent3: EventOLD = EventOLD(eventID: 3, eventName: "Test3", eventTotalSeconds: 86405 * 2)
//        let testEvent4: EventOLD = EventOLD(eventID: 4, eventName: "Test4", eventTotalSeconds: 2000)
//
//        var allEventsArray = [EventOLD]()
//
//        allEventsArray.append(emptyEvent)
//        allEventsArray.append(testEvent0)
//        allEventsArray.append(testEvent1)
//        allEventsArray.append(testEvent2)
//        allEventsArray.append(testEvent3)
//        allEventsArray.append(testEvent4)
//
//        allEventsArray.sort(by: {$0.eventTotalSeconds < $1.eventTotalSeconds})
//
//        //adds to each notification an alarm
//        pushNotifivation(allEventsArray: allEventsArray)
//
//        //deletes all Events and then adds all Events to the Table View
//        tableViewList.removeAll()
//        tableViewList.append(contentsOf: allEventsArray)
    }
}

