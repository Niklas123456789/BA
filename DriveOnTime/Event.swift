//
//  EventToJSON.swift
//  Drive on time
//
//  Created by Niklas Großmann on 28.01.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import MapKit

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
    var latitude: Double
    var longitude: Double
    
    var eventDate: Date
//    var eventTotalSeconds: Int = 0
    
    var repeatDuration: Int = 0
    var repeatAtWeekdays: [Bool] = [false, false, false, false, false, false, false]
    var weeksTillNextEvent: Int
    
//    var timeTillNextCheck: Int
    var timeTillGo: Int
    var driveTime: Int
    
    var notificationId = 0
    
    init(eventID: String, eventName: String, streetName: String, houseNr: String, houseNrEdited: Bool, cityName: String, eventNotes: String, parkingTime: Int, walkingTime: Int, bufferTime: Int, eventDate: Date, repeatDuration: Int, repeatAtWeekdays: [Bool], weeksTillNextEvent: Int, driveTime: Int, timeTillGo: Int, mute: Bool, latitude: Double, longitude: Double, notificationId: Int) {
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
        self.latitude = latitude
        self.longitude = longitude
        self.notificationId = notificationId
    }

    func setEventTotalSecounds(newEventTotalSeconds: Int){
       // self.eventTotalSeconds = newEventTotalSeconds
    }
    
    mutating func saveEventInJSON() {
        self.updateNotificationId()
        JSONDataManager.saveIntoJSON(self, with: "\(eventID)")
    }
    
    func deleteEventInJSON(){
        JSONDataManager.delete("\(eventID)")
    }

    
    //TODO
    func calcDriveTime(event:Event) -> Int {
        return 0
    }
    
    mutating func updateNotificationId() {
        if (EventManager.eventNotificationIds.keys.contains(eventID)) {
            self.notificationId = EventManager.eventNotificationIds[eventID]!
        }
    }
}
