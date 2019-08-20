//
//  TimerController.swift
//  Drive on time
//
//  Created by Niklas Großmann on 07.11.18.
//  Copyright © 2018 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import UIKit

class TimerController: NSDate {
    
    var seconds: Int
    var timer = Timer()
    var isTimerRunning = false
    var timeTillNextCheck: Double
    var cellTimer: ViewContollerTableViewCell
    var eventTimeInSeconds: Int
    var allTimeSettingsInSeconds: Int
    var routeTimeInSeconds: Int
    var timeDifferenceEventAndNow: NSDate
    var eventDate = NSDate(timeIntervalSinceNow: 0)
    
    
    
    init(seconds: Int, timer: Timer, isTimerRunning: Bool, timeTillNextCheck: Double, cellTimer: ViewContollerTableViewCell, eventTimeInSeconds: Int, allTimeSettingsInSeconds: Int, routeTimeInSeconds: Int, timeDifferenceEventAndNow: NSDate, eventDate: NSDate){
        self.seconds = seconds
        self.timer = timer
        self.isTimerRunning = isTimerRunning
        self.timeTillNextCheck = timeTillNextCheck
        self.cellTimer = cellTimer
        self.eventTimeInSeconds = eventTimeInSeconds
        self.allTimeSettingsInSeconds = allTimeSettingsInSeconds
        self.routeTimeInSeconds = routeTimeInSeconds
        self.timeDifferenceEventAndNow = timeDifferenceEventAndNow
        self.eventDate = eventDate
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func runTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: timeTillNextCheck, repeats: false, block: { (_) in
            //TODO: mehoden für neuen Timer aufrufen
        })
    }
//    func updateTimer(){
//        seconds = seconds - 1
//    }
//    let date = Date()
    
    
    func calculateNextCheckTime(){
        //TODO
        
    }
}
