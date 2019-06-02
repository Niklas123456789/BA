//
//  EventToJSON.swift
//  DailyRythmn
//
//  Created by Niklas Großmann on 28.01.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation

struct Event : Codable {
    
    var strPickerDate: String = ""
    var pickerHour: Int = 0
    var pickerMin: Int = 0
    
    var eventID: String
    var eventName: String
    var streetName: String
    //ohne hausnummer?
    var houseNr: String
    var houseNrEdited: Bool
    var cityName: String
    var eventNotes: String
    var parkingTime: Int
    var walkingTime: Int
    var bufferTime: Int
    var mute: Bool
    
    var eventDate: Date
//    var eventTotalSeconds: Int = 0
    
    var repeatDuration: Int = 0
    var repeatAtWeekdays: [Bool] = [false, false, false, false, false, false, false]
    var weeksTillNextEvent: Int
    
//    var timeTillNextCheck: Int
    var timeTillGo: Int
    var driveTime: Int
    
    init(eventID: String, eventName: String, streetName: String, houseNr: String, houseNrEdited: Bool, cityName: String, eventNotes: String, parkingTime: Int, walkingTime: Int, bufferTime: Int, eventDate: Date, repeatDuration: Int, repeatAtWeekdays: [Bool], weeksTillNextEvent: Int, driveTime: Int, timeTillGo: Int, mute: Bool) {
        self.eventID = eventID
        self.eventName = eventName
        self.streetName = streetName
        self.houseNr = houseNr
        self.houseNrEdited = houseNrEdited
        self.cityName = cityName
        self.eventNotes = eventNotes
        self.parkingTime = parkingTime
        self.walkingTime = walkingTime
        self.bufferTime = bufferTime
        self.eventDate = eventDate
//        self.eventTotalSeconds = eventTotalSeconds
        self.repeatDuration = repeatDuration
        self.repeatAtWeekdays = repeatAtWeekdays
        self.weeksTillNextEvent = weeksTillNextEvent
//        self.timeTillNextCheck = timeTillNextCheck
        self.timeTillGo = timeTillGo
        self.driveTime = driveTime
        self.mute = mute
    }

    func setEventTotalSecounds(newEventTotalSeconds: Int){
       // self.eventTotalSeconds = newEventTotalSeconds
    }
    
    func saveEventInJSON(){
        JSONDataManager.saveIntoJSON(self, with: "\(eventID)")
    }
    
    func deleteEventInJSON(){
        JSONDataManager.delete("\(eventID)")
    }

    
    
    func differenceTwoHourAndMin(currentHours: Int, currentMin:Int, eventHours: Int, eventMin: Int) -> (Int, Int){
        
        var difHours: Int
        var difMin: Int
        
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
        return (difHours, difMin)
    }
    
    
    
    //TODO
    func calcDriveTime(event:Event) -> Int {
        return 0
    }
}
