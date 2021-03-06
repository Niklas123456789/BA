//
//  EventManager.swift
//  Drive on time
//
//  Created by Niklas Großmann on 09.03.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import AudioToolbox
import MapKit

class EventManager {
    
    let locationManager = CLLocationManager()
    static var eventNotificationIds = [String : Int]()
    var group7 = DispatchGroup()
    
     static let instance = EventManager()
    
    static func getInstance() -> EventManager {
        return instance
    }
    
     init() {
    }
    
     func zeroReturn(event: Event) -> Int {
        return 0
    }
    
     func calcDifNowAndEvent(event: Event) -> Int {
        let date = EventManager.getInstance().getDate()
        let difference = event.eventDate.timeIntervalSince(date)
        print("Diffrenence between Dates in secondes :\(difference)")
        return Int(difference)
    }
    
     func calcDiffInSecOfNowAndEventDate(event: Event) -> Int {
        calcDifNowAndEvent(event: event)
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        let eventComponents = calendar.dateComponents([.hour, .minute], from: event.eventDate)
        
        let hour: Int! = components.hour
        let minute: Int! = components.minute
        let seconds: Int! = components.second
        
        
        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        let eventHour = eventComponents.hour!
        
        let(difHour, difMin, subSec) = differenceTwoHourAndMin(currentHours: hour, currentMin: minute, eventHours: eventHour, eventMin: eventComponents.minute!)
        let realDifHour = difHour  - (secondsFromGMT/3600)
        
//        print("eventComponents.hour!, eventMin: eventComponents.minute! \(eventHour) \(eventComponents.minute)")
        
        /* sets distanceToEventInSecounds */
        _ = getDate()
        
        let eventSecondsThisDay = eventHour * 3600 + eventComponents.minute! * 60
        var distanceToEventInSecounds = 0
        print("Int(todaysDate.secondsFromBeginningOfTheDay()) \(Int(date.secondsFromBeginningOfTheDay())) eventSecondsThisDay \(eventSecondsThisDay)")
        /* eventTime before now */
        if (Int(date.secondsFromBeginningOfTheDay()) >= eventSecondsThisDay) {
            print("'''''''eventTime BEFORE now */ \(realDifHour) \(difMin)")
        /* eventTime after now */
        } else {
            print("'''''''eventTime AFTER now */ \(realDifHour) \(difMin)")
        }
        distanceToEventInSecounds = countDaysTillNextEventDay(event: event) * 86400 + (realDifHour * 3600) + (difMin * 60) - subSec
        print("++++++++++++++++++++++DistanceToEventInSec: \(distanceToEventInSecounds)")
        
        return distanceToEventInSecounds
    }
    
     func differenceTwoHourAndMin(currentHours: Int, currentMin:Int, eventHours: Int, eventMin: Int) -> (Int, Int, Int){
        
        var difHours: Int
        var difMin: Int
            let todaysDate = self.getDate()
        
            let secondsNow = Calendar.current.component(.second, from: todaysDate)
        print("current Hours: \(currentHours) min: \(currentMin) ")
        print("Event Hours: \(eventHours) min: \(eventMin) ")
        //works!
        if (currentHours < eventHours && currentMin < eventMin){
            difHours = eventHours - currentHours
            difMin = eventMin - currentMin
            print("currentHours < eventHours && currentMin < eventMin")
            
            //works!
        } else if (currentHours < eventHours && currentMin > eventMin){
            difHours = eventHours - currentHours - 1
            difMin = 60 - (currentMin - eventMin)
            print("currentHours < eventHours && currentMin > eventMin")
            
            //works!
        } else if (currentHours > eventHours && currentMin < eventMin){
            difHours = ((currentHours - eventHours) - 1) * -1
            difMin = (eventMin + currentMin) * -1
            print("currentHours > eventHours && currentMin < eventMin")
            
            //works!
        }else if (currentHours == eventHours && currentMin > eventMin){
            difHours = 0
            difMin = (currentMin - eventMin) * -1
            print("currentHours == eventHours && currentMin > eventMin")
            //works!
        }else if (currentHours == eventHours && currentMin < eventMin){
            difHours = 0
            difMin = eventMin - currentMin
            print("currentHours == eventHours && currentMin < eventMin")
            //works!
        }else if (currentHours < eventHours && currentMin == eventMin){
            difHours = eventHours - currentHours
            difMin = 0
            print("currentHours < eventHours && currentMin == eventMin")
            //works!
        }else if (currentHours > eventHours && currentMin == eventMin){
            difHours = (eventHours - currentHours)
            difMin = 0
            print("currentHours > eventHours && currentMin == eventMin")
            //works!
        }else if (currentHours > eventHours && currentMin > eventMin){
            difHours = (currentHours - eventHours) * -1
            difMin = (currentMin - eventMin) * -1
            print("currentHours > eventHours && currentMin > eventMin")
            //(currentHours == eventHours && currentMin == eventMin)
        } else {
            difHours = 0
            difMin = 0
            print("currentHours == eventHours && currentMin == eventMin")
        }
        print("CALC DIF HOUR \(difHours) MIN \(difMin)")
        return (difHours, difMin, secondsNow)
    }
    
     func countDaysBetweenNowAndEvent(event: Event) {
        
    }
    
     func countDaysTillNextEventDay(event: Event) -> Int{
        
        //current day
        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        let todaysDate = EventManager.getInstance().getDate().addingTimeInterval(TimeInterval(-secondsFromGMT))
        var todaysWeekday = Calendar.current.component(.weekday, from: todaysDate)
        
        
        let calendar = Calendar.current
        let eventHours = calendar.component(.hour, from: event.eventDate)
        let eventMin = calendar.component(.minute, from: event.eventDate)
        
        print("{EventManager} countDaysTillNextEventDay: Hours:\(eventHours) Min \(eventMin)")
        
        print("Todays Day Nr: \(todaysWeekday)")
        
        //compair to repeatAtWeekdays and get next eventDay
        
        var countDays = 0
        var count = 0
        if (event.repeatAtWeekdays[todaysWeekday - 1] == true){
            countDays = 0
        }else{
            while (count <= 7){
                
                if(todaysWeekday == 8){
                    todaysWeekday = 1
                }else if(event.repeatAtWeekdays[todaysWeekday - 1] != true){
                    countDays += 1
                    todaysWeekday += 1
                }else if(event.repeatAtWeekdays[todaysWeekday - 1] == true){
                    break
                }
                count = count + 1
            }
        }
        print("CountDays: \(countDays)")
        if countDays == 0 {
//            todo fix eventHours
            let eventSecondsThisDay = eventHours * 3600 + eventMin * 60 - (event.bufferTime + event.parkingTime + event.walkingTime) * 60
            if ((Int(todaysDate.secondsFromBeginningOfTheDay()) - secondsFromGMT) >= eventSecondsThisDay) {
                print("todaysDate.secondsFromBeginningOfTheDay() \(todaysDate.secondsFromBeginningOfTheDay()) EventSecondsThisDay \(eventSecondsThisDay)")
                return 7
            }
        }
        print("+++++++++++++++++Count to event in Days Return: \(countDays)")
        return countDays
    }
    
    
    func countTillNextEventDay2(event: Event) -> Int {
        var count = 0
        var countTillNext = 0
        let todaysDate = EventManager.getInstance().getDate()
        
        var eventWeekdaysBinary = [0,0,0,0,0,0,0]
        var tempCount = 0
        for temp in event.repeatAtWeekdays {
            if (temp == true){
                eventWeekdaysBinary[tempCount] = 1
            }
            tempCount = tempCount + 1
        }
        
        let todaysWeekday = Calendar.current.component(.weekday, from: todaysDate)
        var tempCount2 = 0
        while(tempCount2 < 7){
            if ((todaysWeekday + count) <= 6){
                if(eventWeekdaysBinary[todaysWeekday + count] == 1){
                    if(countTillNext == 0) {
                        countTillNext = count + 1
                    }
                }
            }else{
                if(eventWeekdaysBinary[todaysWeekday + count - 7] == 1){
                    if(countTillNext == 0) {
                        countTillNext = count + 1
                    }
                }
            }
            tempCount2 = tempCount2 + 1
            count = count + 1
        }
        return countTillNext
    }
    
     func callTimeTillNextCheckAction(in timeTillNextCheck: Int, event: Event) {
        print("In repeatTimeCheck")
        EventManager.getInstance().updateJSONEvents()
        
        _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeTillNextCheck), repeats: false, block: { (timer) in
            self.getTimeTillNextCheckAction(from: event, completion: { (tempResult: Int) in
                
            })
        })
    }
    
     func removeDuplicateEvents(from event: Event) {
        let loadedEvents = JSONDataManager.loadAll(Event.self)
        
        for oneEvent in loadedEvents {
            if(oneEvent.eventID == event.eventID) {
                oneEvent.deleteEventInJSON()
            }
        }
    }
    
        /* updates JSON */
     func updateJSONEvents() {
        let loadedEvents = JSONDataManager.loadAll(Event.self)

        
        let todaysDate = getDate()
        
        for event in loadedEvents {
            
            if(todaysDate <= event.eventDate) {
            }else{
                if(event.repeatDuration == 0){
                    event.deleteEventInJSON()
                } else {
                    
                }
                
            }
        }
    }
    var testValue = 0
    
     func createNotification(for event: Event){

        //removes all existing pending notifications before creating new ones
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = event.eventName
        if (event.eventNotes.isEmpty) {
            content.body = "Mit deinem Puffer von \(event.bufferTime) Minuten musst du jetzt los!"
        } else {
            content.body = "Mit deinem Puffer von \(event.bufferTime) Minuten musst du jetzt los! \nNotiz: \(event.eventNotes)"
        }
        content.sound = UNNotificationSound.default
        
        let todaysDate = Date()
        var secondsNow = Calendar.current.component(.second, from: todaysDate)
        //that the notification doesn't go off by 1 min
        if secondsNow == 0 {secondsNow = 59}
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (TimeInterval(61 - secondsNow)), repeats: false)
        let request = UNNotificationRequest(identifier: "\(event.eventID)", content: content, trigger: trigger)
        center.add(request) { (error) in
            if (error != nil) {
                print("error creating notification for id: \(event.eventID): \(error!.localizedDescription)")
            } else {
                print("created notification with id: \(event.eventID) and notes: \(event.eventNotes)")
            }
        }
    }
    
     func createNotification(time: Int, for event: Event, travelTime: Int){
        
        if (EventManager.eventNotificationIds.keys.contains(event.eventID)) {
            EventManager.eventNotificationIds[event.eventID] = EventManager.eventNotificationIds[event.eventID]! + 1
        } else {
            EventManager.eventNotificationIds[event.eventID] = 0
        }
        let eventId = event.eventID + "\(EventManager.eventNotificationIds[event.eventID]!)"
        //removes all existing pending notifications before creating new ones
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (notifications) in
            for request in notifications {
                if request.identifier == eventId {
                    print("found pending request with same id: \(eventId)")
                    return
                }
            }
        }
        center.getDeliveredNotifications { (notifications) in
            for request in notifications {
                if request.request.identifier == eventId {
                    print("found delivered request with same id: \(eventId)")
                    return
                }
            }
        }
        let content = UNMutableNotificationContent()
        content.title = event.eventName
        if (event.eventNotes.isEmpty) {
            content.body = "Mit deinem Puffer von \(event.bufferTime) Minuten musst du jetzt los!"
        } else {
            content.body = "Mit deinem Puffer von \(event.bufferTime) Minuten musst du jetzt los! \nNotiz: \(event.eventNotes)"
        }
//        content.subtitle = "Aktuelle Fahrzeit: \(Int(travelTime/60)) min"
        content.sound = UNNotificationSound.default


        
        
        _ = event.eventID + "\(event.notificationId)"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (TimeInterval(time + 1)), repeats: false)
        let request = UNNotificationRequest(identifier: eventId, content: content, trigger: trigger)
        center.add(request) { (error) in
            if (error != nil) {
                print("error creating notification for id: \(eventId): \(error!.localizedDescription)")
            } else {
                print("created notification with id: \(eventId) and notes: \(event.eventNotes)")
            }
        }
    }
    
    
     func getTimeTillNextCheckAction(from event: Event, completion: @escaping (Int) -> ()) {
        removePendingNotifications(with: event.eventID, notId: EventManager.eventNotificationIds[event.eventID] ?? 0)
        var travelTime: Int = 0
        var result: Int = 0

        self.getETTOnly(event: event) { (tempResult: Int) in
            travelTime = tempResult
            DispatchQueue.main.async {
                
                let eventTotalSeconds = self.calcDifNowAndEvent(event: event)
                var timeTillNextCheck = ((eventTotalSeconds - ((event.bufferTime + event.walkingTime + event.parkingTime) * 60)) - travelTime)
                
                let timeTillGo = (eventTotalSeconds - ((event.bufferTime + event.walkingTime + event.parkingTime) * 60)) - travelTime
                
                
                if timeTillNextCheck / 2 <= 86400 {
                    
                    if timeTillGo < 0 {
                        print("Event \(event.eventName) has passed already")
                        
                        
                        self.checkIfEventShouldRepeat(for: event)
                        result = -1
                        completion(-1)
                    } else if timeTillGo <= 60 {
                        print("Push event notification")
//                        self.createNotification(for: event)
                        self.createNotification(time: timeTillGo, for: event, travelTime: travelTime)
                        
                        //repeats if needed event 5 min after notification went of
                        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(300.0), repeats: false, block: { (timer) in
                            self.checkIfEventShouldRepeat(for: event)
                        })
                        
                        result = 0
                        // 3 min check every 15 sec
                        completion(0)
                    }else if timeTillGo <= 180 {
                        timeTillNextCheck = 15
                        self.createNotification(time: timeTillGo, for: event, travelTime: travelTime)
                        //self.callTimeTillNextCheckAction(in: timeTillNextCheck, event: event)
                        print("Set timeTillNextCheck: \(timeTillNextCheck)")
                        completion(15)
                        // 6 min check every 1 min
                    } else if timeTillGo <= 360 {
                        timeTillNextCheck = 60
                        self.createNotification(time: timeTillGo, for: event, travelTime: travelTime)
//                        //self.callTimeTillNextCheckAction(in: timeTillNextCheck, event: event)
                        print("Set timeTillNextCheck: \(timeTillNextCheck)")
                       completion(60)
                    } else if timeTillGo <= 600 {  // 10 min check every 3 min
                        timeTillNextCheck = 180
                        self.createNotification(time: timeTillGo, for: event, travelTime: travelTime)
                        //self.callTimeTillNextCheckAction(in: timeTillNextCheck, event: event)
                        print("Set timeTillNextCheck: \(timeTillNextCheck)")
                        completion(180)
                        // 30 min check every 8 min
                    } else if timeTillGo <= 1800 {
                        timeTillNextCheck = 480
                        self.createNotification(time: timeTillGo, for: event, travelTime: travelTime)
                        //self.callTimeTillNextCheckAction(in: timeTillNextCheck, event: event)
                        print("Set timeTillNextCheck: \(timeTillNextCheck)")
                        completion(480)
                        //60 min check every 12 min
                    } else if timeTillGo <= 3600 {
                        timeTillNextCheck = 720
                        self.createNotification(time: timeTillGo, for: event, travelTime: travelTime)
//                        //self.callTimeTillNextCheckAction(in: timeTillNextCheck, event: event)
                        completion(720)
                        print("Set timeTillNextCheck: \(timeTillNextCheck)")
                    }
                } else {
                    self.createNotification(time: timeTillGo, for: event, travelTime: travelTime)
                    //self.callTimeTillNextCheckAction(in: timeTillNextCheck, event: event)
                    timeTillNextCheck = timeTillNextCheck / 2
                    completion(timeTillNextCheck)
                }
                self.startMySignificantLocationChanges()
                result = timeTillNextCheck
                print("Inside Dispatchqueue with travelTime:\(travelTime) eventTotalSeconds: \(eventTotalSeconds) timeTillNextCheck: \(timeTillNextCheck) timeTillGo: \(timeTillGo)")

            }
        }
    }
    
    func removePendingNotifications(with id: String, notId: Int) {
        let center = UNUserNotificationCenter.current()
        print("Removing pending notifications up to no: \(notId)")
        var notIds = [String]()
        for index in 0..<notId {
            notIds.append(id + "\(index)")
        }
        
        center.removePendingNotificationRequests(withIdentifiers: notIds)
    }
    
    func startMySignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The device does not support this service.
            return
        }
        let allJsonEvents = JSONDataManager.loadAll(Event.self)
        if (allJsonEvents.isEmpty){
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        _ = locations.last!
        
        var smallestTimeTillEvent = 64000
        let allJsonEvents = JSONDataManager.loadAll(Event.self)
        for event in allJsonEvents {
            getTimeTillNextCheckAction(from: event) { (result) in
                if result < smallestTimeTillEvent {
                    smallestTimeTillEvent = result
                }
            }
        }
        if smallestTimeTillEvent > 64000 {
            locationManager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    /* repeats event after notification */
     func checkIfEventShouldRepeat(for event: Event) {
        var weeksTillNextEvent: Double = 0
        event.deleteEventInJSON()
        //event has repeatDuration
        if event.repeatDuration != 0 {
            if event.repeatDuration == 1 {
                weeksTillNextEvent = 0.0
            }else if event.repeatDuration == 2 {
                weeksTillNextEvent = 1.0
            }else if event.repeatDuration == 3 {
                weeksTillNextEvent = 2.0
                //monatlich
            }else if event.repeatDuration == 4 {
                weeksTillNextEvent = 3.0
            }
        }
        var newEvent = event
        var timeTillNextCheck: Int = 0
        newEvent.eventDate = newEvent.eventDate.addingTimeInterval(TimeInterval(weeksTillNextEvent * 604800))
        newEvent.saveEventInJSON()
        //calls repeatTimeCheck after all weeks minus 1 day
        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(weeksTillNextEvent * 604800.0 - 86400.0), repeats: false, block: { (timer) in
            print("\(event.eventName) In timer repeatTimecheck")
            self.getTimeTillNextCheckAction(from: event) { (tempResult: Int) in
                timeTillNextCheck = tempResult
                
            }
        })
    }
    
     func getTimeTillGo(event: Event) -> Int {
        var temp = calcDifNowAndEvent(event: event)
        temp = (temp - (event.bufferTime + event.walkingTime + event.parkingTime) * 60) - zeroReturn(event: event)
        if temp <= 0 {
            return 0
        }
        return temp
    }
    //when called you have to check if eventID is "-1"
     func getEventwithID(eventID: String) -> Event {
        var allEventsArray = [Event]()
        updateJSONEvents()
        let noEvent = Event(eventID: "-1", eventName: "noEvent", streetName: "", houseNr: "", houseNrEdited: false, cityName: "", eventNotes: "", parkingTime: 0, walkingTime: 0, bufferTime: 0, eventDate: Date.init(), repeatDuration: 0, repeatAtWeekdays: [false,false,false,false,false,false,false], weeksTillNextEvent: 0, driveTime: 0, timeTillGo: 0, mute: false, latitude: 0.0, longitude: 0.0, notificationId: 0)
        
        allEventsArray = JSONDataManager.loadAll(Event.self)
        //seach for event with the same UUID
        for tempEvent in allEventsArray
        {
            if (tempEvent.eventID == eventID){
                return tempEvent
            }
        }
        return noEvent
    }
    
     func convertDateToTimeZoneDate(dateToConvert: String) -> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm  dd-MM-yyyy"
        let convertedDate = format.date(from: dateToConvert)
        format.timeZone = TimeZone.current
        format.dateFormat = "HH:mm  dd-MM-yyyy"
        let temp = format.string(from: convertedDate!)
        print("convertDateToTimeZoneDate Return\(temp)")
        return temp
    }

    
     func getDate() -> Date {
        var date = Date()
        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
//        print("SecondsFromGTM: \(secondsFromGMT)")
        let finalDate = date.addingTimeInterval(TimeInterval(secondsFromGMT))
//        print("getDate return: \(finalDate)")
        return finalDate
    }
    
     func getETTOnly(event: Event, completion: @escaping (Int) -> ()) {
        
        var result: Int = 0
        
        let destination = CLLocationCoordinate2DMake(event.latitude, event.longitude)
        
        let request = MKDirections.Request()
        group7.enter()
        
        if let currentLocation = locationManager.location?.coordinate {
            
            request.source =  MKMapItem(placemark: MKPlacemark(coordinate: currentLocation, addressDictionary: nil))
            
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
            
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            
            directions.calculateETA(completionHandler: { ( response, error) in
                
                if error == nil {
                    
                    if let interval = response?.expectedTravelTime  {
                        
                        print("ETARequest \(interval)")
                        
//                        self.updateTableWithETA(travelTime: Int(interval), event: event, index: index)
//                        result = Int(interval)
                        completion(Int(interval))
                    }
                    
                } else {
                    
                    print("Error Occurred2")
                    print(error)
                }
                
            })
            
        group7.leave()
        }
    }
    
     func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        
    }
    
     func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
}
