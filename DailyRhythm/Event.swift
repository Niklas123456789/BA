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
    
    var eventDate: Date
//    var eventTotalSeconds: Int = 0
    
    var repeatDuration: Int = 0
    var repeatAtWeekdays: [Bool] = [false, false, false, false, false, false, false]
    var weeksTillNextEvent: Int
    
//    var timeTillNextCheck: Int
    var timeTillGo: Int
    var driveTime: Int
    
    init(eventID: String, eventName: String, streetName: String, houseNr: String, houseNrEdited: Bool, cityName: String, eventNotes: String, parkingTime: Int, walkingTime: Int, bufferTime: Int, eventDate: Date, repeatDuration: Int, repeatAtWeekdays: [Bool], weeksTillNextEvent: Int, driveTime: Int, timeTillGo: Int) {
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
    //TODO: duration not included in calc
    mutating func calcDiffInSecOfNowAndEventDate(eventDate: Date, eventWeekdays: [Bool], duration: Int) -> Int {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        
        let hour: Int! = components.hour
        let minute: Int! = components.minute
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        strPickerDate = dateFormatter.string(from: eventDate)
        let temp:Int! = Int(strPickerDate)
        let eventMin = temp % 100
        let eventHour = Int(temp/100)
        print("Time datePicker: \(strPickerDate)")
        
        
        let(difHour, difMin) = differenceTwoHourAndMin(currentHours: hour, currentMin: minute, eventHours: eventHour, eventMin: eventMin)
        
        
        let distanceToEventInSecounds = countDaysTillNextEventDay(repeatAtWeekdays: eventWeekdays) * 86400 + difHour * 3600 + difMin * 60
        print(distanceToEventInSecounds)
        
        return distanceToEventInSecounds
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
    
    
    //TODO
    func calcDriveTime(event:Event) -> Int {
        return 0
    }
}
