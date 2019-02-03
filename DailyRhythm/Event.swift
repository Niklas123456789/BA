//
//  EventToJSON.swift
//  DailyRythmn
//
//  Created by Niklas Großmann on 28.01.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation

struct Event : Codable {
    
    var eventID: Int
    var eventName: String
    var streetName: String
    //ohne hausnummer?
    var houseNr: Int = -1
    var houseNrEdited: Bool
    var cityName: String
    var eventNotes: String
    var parkingTime: Int
    var walkingTime: Int
    var bufferTime: Int
    
    var eventDate: Date
    var eventTotalSeconds: Int = 0
    
    var repeatDuration: Int = 0
    var repeatAtWeekdays: [Int] = [0, 0, 0, 0, 0, 0, 0]
    
    init(eventID: Int, eventName: String, streetName: String, houseNr: Int,houseNrEdited: Bool, cityName: String, eventNotes: String, parkingTime: Int, walkingTime: Int, bufferTime: Int, eventDate: Date, eventTotalSeconds: Int, repeatDuration: Int, repeatAtWeekdays: [Int]) {
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
        self.eventTotalSeconds = eventTotalSeconds
        self.repeatDuration = repeatDuration
        self.repeatAtWeekdays = repeatAtWeekdays
    }

    
    
    func saveEventInJSON(){
        JSONDataManager.saveIntoJSON(self, with: String(eventID))
    }
    
    func deleteEventInJSON(){
        JSONDataManager.delete(String(eventID))
    }
}
