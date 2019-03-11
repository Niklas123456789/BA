//
//  EventManager.swift
//  DailyRhythm
//
//  Created by Niklas Großmann on 09.03.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import AudioToolbox

class EventManager {
    
    private static let instance = EventManager()
    
    static func getInstance() -> EventManager {
        return instance
    }
    
    private init() {
    }

    
    
    
    
    //TODO
    func calcDriveTime(event: Event) -> Int {
        return 0
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
    
    func updateEventTimes(event: inout Event) -> Event{
        
        var eventTotalSeconds = calcDiffInSecOfNowAndEventDate(eventDate: event.eventDate, eventWeekdays: event.repeatAtWeekdays, duration: event.repeatDuration) // MARK: hi
        var timeTillNextCheck = (event.eventTotalSeconds - ((event.bufferTime + event.walkingTime + event.parkingTime) * 60) - calcDriveTime(event: event)) / 2
        
        
        var timeTillGo = (event.eventTotalSeconds - ((event.bufferTime + event.walkingTime + event.parkingTime) * 60) - calcDriveTime(event: event))
        //TODO: Soll nicht beim ersten mal erstellen passieren, sodass ein event was alle 3 woche geht diese woche startet
        if event.weeksTillNextEvent != 0 && event.weeksTillNextEvent != 1 {
            eventTotalSeconds = eventTotalSeconds + ((event.weeksTillNextEvent - 1) * 604800)
            timeTillNextCheck = timeTillNextCheck + ((event.weeksTillNextEvent - 1) * 604800)
            timeTillGo = timeTillGo + ((event.weeksTillNextEvent - 1) * 604800)
        }
        
        event.eventTotalSeconds = eventTotalSeconds
        event.timeTillNextCheck = timeTillNextCheck
        event.timeTillGo = timeTillGo
        
        return event
    }
    
    //<24h
    func repeatTimeCheck(event: inout Event) {
        
        EventManager.getInstance().updateJSONEvents()
        
        event.eventTotalSeconds = calcDiffInSecOfNowAndEventDate(eventDate: event.eventDate, eventWeekdays: event.repeatAtWeekdays, duration: event.repeatDuration) // MARK: hi
        event.timeTillNextCheck = (event.eventTotalSeconds - ((event.bufferTime + event.walkingTime + event.parkingTime) * 60) - calcDriveTime(event: event)) / 2
        event.timeTillGo = (event.eventTotalSeconds - ((event.bufferTime + event.walkingTime + event.parkingTime) * 60) - calcDriveTime(event: event))
        
        //let loadedEvents = JSONDataManager.loadAll(Event.self)
        
        
        // 1 min
        if event.timeTillGo <= 60 {
            print("Push event notification")
            self.pushNotifivation(event: event)
            return
        // 3 min check every 30 sec
        } else if event.timeTillGo <= 180 {
            event.timeTillNextCheck = 30
            print("Set timeTillNextCheck: \(event.timeTillNextCheck)")
        // 10 min check every 3 min
        } else if event.timeTillGo <= 600 {
            event.timeTillNextCheck = 180
            print("Set timeTillNextCheck: \(event.timeTillNextCheck)")
        // 25 min check every 5 min
        } else if event.timeTillGo <= 1500 {
            event.timeTillNextCheck = 300
            print("Set timeTillNextCheck: \(event.timeTillNextCheck)")
        //60 min check every 10 min
        } else if event.timeTillGo <= 3600 {
            event.timeTillNextCheck = 600
            print("Set timeTillNextCheck: \(event.timeTillNextCheck)")
        }
        
        //ViewController().updateTableViewList(event: event)
        var newEvent = event
        
        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(event.timeTillNextCheck), repeats: false, block: { (timer) in
            
            EventManager.getInstance().repeatTimeCheck(event: &newEvent)
        })
    }
    
    func updateJSONEvents() {
        var loadedEvents = JSONDataManager.loadAll(Event.self)
        let todaysDate = Date()
        
        for event in loadedEvents {
            
            var tempEvent = event
            
            if(todaysDate <= event.eventDate) {
                //update? what?
            }else{
                if(event.repeatDuration == 0){
                    event.deleteEventInJSON()
                } else {
                    //TODO: check if event is repeated
                }
                
            }
        }
    }
    
    func pushNotifivation(event: Event){
        //removes all existing pending notifications before creating new ones
        let center = UNUserNotificationCenter.current()
        //center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "\(event.eventName)"

        //sets the content of the notification
//        if(event.eventNotes.isEmpty){
//            content.body = "Mit deinem Puffer von \(event.bufferTime) Minuten musst du jetzt los!"
//        }else{
            content.body = "Mit deinem Puffer von \(event.bufferTime) Minuten musst du jetzt los! \nNotiz: \(event.eventNotes)"
       // }
        //adds vibration
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        //sets the notification sound
        content.sound = UNNotificationSound.default

        //creates trigger with the right time
        //TODO: wegzeit miteinberechnen
        //let totalTravelTime = event.eventTotalSeconds - (event.bufferTime * 60) - (event.parkingTime * 60) - (event.walkingTime * 60) + 1

        //TODO: FIX that triggers instant
        let todaysDate = Date()
        var secondsNow = Calendar.current.component(.second, from: todaysDate)
        
        print("TimeTillGo: \(getTimeTillGo(event: event))")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(getTimeTillGo(event: event)), repeats: false)

        let request = UNNotificationRequest(identifier: "\(event.eventID)", content: content, trigger: trigger)

        center.add(request, withCompletionHandler: nil)

    }
    
    func getTimeTillGo(event: Event) -> Int {
        var temp = calcDiffInSecOfNowAndEventDate(eventDate: event.eventDate, eventWeekdays: event.repeatAtWeekdays, duration: event.repeatDuration)
        temp = (temp - (event.bufferTime + event.walkingTime + event.parkingTime) * 60) - calcDriveTime(event: event)
        if temp <= 0 {
            return 1
        }
        return temp
    }
}