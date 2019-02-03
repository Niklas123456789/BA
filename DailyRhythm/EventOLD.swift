//
//  Event.swift
//  DailyRythmn
//
//  Created by Niklas Großmann on 08.11.18.
//  Copyright © 2018 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation

//muss noch in JSON schreiben
//Codable
class EventOLD: NSDate, Codable{
    
    var eventID: Int = -1
    var eventName: String = ""
    var timerInSeconds: Int = -1
    var streetName: String = ""
    var houseNr: Int = -1
    var cityName: String = ""
    var eventNotes: String = ""
    //muss noch 5 werden
    var parkingTime: Int = 0
    var walkingTime: Int = 0
    var buffer: Int = 0

//    var eventDate: NSDate
    var eventTotalSeconds: Int = 0
    var eventSeconds: Int8 = 0
    var eventMinutes: Int8 = 0
    var eventHours: Int8 = 0
    
    var repeatIteration: Int = 0
    var repeatAtWeekdays: [Int] = [0, 0, 0, 0, 0, 0, 0]

    
    
    
    //getIterations (repeatEvent)
    
    
    //init zum Testen
    init(eventID: Int, eventName: String, eventTotalSeconds: Int){
        self.eventID = eventID
        self.eventName = eventName
        self.eventTotalSeconds = eventTotalSeconds
//        self.eventDate = eventDate
        
        
        super.init()
    }

    init(eventID: Int, eventName: String, timerInSeconds: Int, streetName: String, houseNr: Int, cityName: String, eventNotes: String, parkingTime: Int, walkingTime: Int, buffer: Int, eventDate: NSDate, repeatIteration: Int, repeatAtWeekdays: [Int], eventSeconds: Int8, eventMinutes: Int8, eventHours: Int8) {
        self.eventID = eventID
        self.eventName = eventName
        self.timerInSeconds = timerInSeconds
        self.streetName = streetName
        self.houseNr = houseNr
        self.cityName = cityName
        self.eventNotes = eventNotes
        self.parkingTime = parkingTime
        self.walkingTime = walkingTime
        self.buffer = buffer
//        self.eventDate = eventDate
        self.repeatIteration = repeatIteration
        self.repeatAtWeekdays = repeatAtWeekdays
        self.eventSeconds = eventSeconds
        self.eventMinutes = eventMinutes
        self.eventHours = eventHours

        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
