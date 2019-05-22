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
    
    @IBOutlet weak var tableView: UITableView!
    
    private static let instance = ViewController()
    
    static func getInstance() -> ViewController {
        return instance
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    /* delete Event */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
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
        }
        if (editingStyle == .insert) {
            print("insert")
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
        cell.checkTwoDays(time: EventManager.getInstance().getTimeTillGo(event: tableViewList[indexPath.row]), event: tableViewList[indexPath.row])
        
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

    
    
/*
    //NOTIFICATIONS
    func pushNotifivation(allEventsArray: [Event]){
        var index = 0
        let numberOfNotifications = allEventsArray.count
        //removes all existing pending notifications before creating new ones
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        //empty allEventArray
        if((allEventsArray.count == 1 && allEventsArray[0].eventID == -1)){
            print("ViewController allEventArray is empty")
        }else if(allEventsArray.count == 0){
            print("AllEventArray is empty")
        }else{
        //creates one notification for each event
            while(true){

                let content = UNMutableNotificationContent()
                content.title = "\(allEventsArray[index].eventName)"

                //sets the content of the notification
                if(allEventsArray[index].eventNotes.isEmpty){
                    content.body = "Mit deinem Puffer von \(allEventsArray[index].bufferTime) Minuten musst du jetzt los!"
                }else{
                    content.body = "Mit deinem Puffer von \(allEventsArray[index].bufferTime) Minuten musst du jetzt los! \nNotiz: \(allEventsArray[index].eventNotes)"
                }
                //adds vibration
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                //sets the notification sound
                content.sound = UNNotificationSound.default

                //creates trigger with the right time
                //TODO: wegzeit miteinberechnen
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
*/
    
    //TODO
    func calcDriveTime(event:Event) -> Int {
        return 0
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            allEventsArray[index].timeTillGo =  calcDiffInSecOfNowAndEventDate(eventDate: event.eventDate, eventWeekdays: event.repeatAtWeekdays, duration: event.repeatDuration) - (event.bufferTime + event.walkingTime + event.parkingTime) * 60 - calcDriveTime(event: event) /* - 1 */
            print("TimeTillGo in ViewController: \(allEventsArray[index].timeTillGo)")
            index = index + 1
        }
        print(allEventsArray)
        //add JSON-Events to table
        for indexEventCount in 0..<allEventsArray.count {
            //loads Events into allEventArray
            
        //    allEventsArray.append(loadedEvents[indexEventCount])
            //calc the time till the you have to go timer should trigger
            //TODO: actual wegzeit einberechnen
            //let timeTillGo = allEventsArray[indexEventCount].calcDiffInSecOfNowAndEventDate(eventDate: allEventsArray[indexEventCount].eventDate, eventWeekdays: allEventsArray[indexEventCount].repeatAtWeekdays, duration: allEventsArray[indexEventCount].repeatDuration) - ((allEventsArray[indexEventCount].bufferTime + allEventsArray[indexEventCount].walkingTime + allEventsArray[indexEventCount].parkingTime) * 60)
            
            //allEventsArray[indexEventCount].timeTillGo = timeTillGo
        }
        //        allEventsArray.append(emptyEvent)
 //       allEventsArray.append(testEvent0)
//        allEventsArray.append(testEvent1)
//        allEventsArray.append(testEvent2)
//        allEventsArray.append(testEvent3)
//        allEventsArray.append(testEvent4)
//
       allEventsArray.sort(by: {$0.timeTillGo < $1.timeTillGo})
//
//        //adds to each notification an alarm
   //    pushNotifivation(allEventsArray: allEventsArray)
//
//        //deletes all Events and then adds all Events to the Table View
       tableViewList.removeAll()
       tableViewList.append(contentsOf: allEventsArray)
    }
    
    func calcDiffInSecOfNowAndEventDate(eventDate: Date, eventWeekdays: [Bool], duration: Int) -> Int {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        
        let hour: Int! = components.hour
        let minute: Int! = components.minute
        let seconds: Int! = components.second
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        var strPickerDate = dateFormatter.string(from: eventDate)
        let temp:Int! = Int(strPickerDate)
        let eventMin = temp % 100
        let eventHour = Int(temp/100)
        print("Time datePicker: \(strPickerDate)")
        
        
        let(difHour, difMin, subSec) = differenceTwoHourAndMin(currentHours: hour, currentMin: minute, eventHours: eventHour, eventMin: eventMin)
        
        
        let distanceToEventInSecounds = countDaysTillNextEventDay(repeatAtWeekdays: eventWeekdays) * 86400 + (difHour * 3600) + (difMin * 60) - subSec
        print("DistanceToEventInSec: \(distanceToEventInSecounds)")
        
        return distanceToEventInSecounds
    }
    
    func differenceTwoHourAndMin(currentHours: Int, currentMin:Int, eventHours: Int, eventMin: Int) -> (Int, Int, Int){
        
        var difHours: Int
        var difMin: Int
        var todaysDate = Date()
        print("TodaysDate: \(todaysDate)")
        
        let secondsNow = Calendar.current.component(.second, from: todaysDate)
        
        //works
        if (currentHours < eventHours && currentMin < eventMin){
            difHours = eventHours - currentHours
            difMin = eventMin - currentMin
            
            //works
        } else if (currentHours < eventHours && currentMin > eventMin){
            difHours = eventHours - currentHours - 1
            difMin = 60 - (currentMin - eventMin)
            
            //works
        } else if (currentHours > eventHours && currentMin < eventMin){
            difHours = (-24) + (currentHours - eventHours)
            difMin = eventMin - currentMin
            
            //works
        }else if (currentHours == eventHours && currentMin > eventMin){
            difHours = -23
            difMin = 60 - (currentMin - eventMin)
            
            //works
        }else if (currentHours == eventHours && currentMin < eventMin){
            difHours = 0
            difMin = eventMin - currentMin
            
            //works
        }else if (currentHours < eventHours && currentMin == eventMin){
            difHours = eventHours - currentHours
            difMin = 0
            
            //works
        }else if (currentHours > eventHours && currentMin == eventMin){
            difHours = (-24) + (currentHours - eventHours)
            difMin = 0
            
            //works
        }else if (currentHours > eventHours && currentMin > eventMin){
            difHours = (-24) + (currentHours - eventHours) + 1
            difMin = 60 - (currentMin - eventMin)
            
            //(currentHours == eventHours && currentMin == eventMin)
        } else {
            difHours = 0
            difMin = 0
        }
        return (difHours, difMin, secondsNow)
    }
    
    func countDaysTillNextEventDay(repeatAtWeekdays arr: [Bool]) -> Int{
        
        //current day
        let todaysDate = Date()
        var todaysWeekday = Calendar.current.component(.weekday, from: todaysDate)
        
        print("Todays Day Nr: \(todaysWeekday)")
        
        //compair to repeatAtWeekdays and get next eventDay
        
        var countDays = 0
        var count = 0
        if (arr[todaysWeekday - 1] == true){
            return 0
        }else{
            while (count <= 7){
                
                if(todaysWeekday == 8){
                    todaysWeekday = 1
                }else if(arr[todaysWeekday - 1] != true){
                    countDays += 1
                    todaysWeekday += 1
                }else if(arr[todaysWeekday - 1] == true){
                    break
                }
                count = count + 1
            }
        }
        print("Count to event in Days Return: \(countDays)")
        return countDays
    }
}
