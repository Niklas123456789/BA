//
//  ViewContollerTableViewCell.swift
//  Drive on time
//
//  Created by Niklas Großmann on 07.11.18.
//  Copyright © 2018 Mobile_App_Uni_Ulm. All rights reserved.
//

import UIKit
import MapKit

class ViewContollerTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellTime: UILabel!
    weak var timer: Timer!
    var time: Int = 0
    var timerDate = NSDate(timeIntervalSinceNow: 0)
    var dateString: String = ""
    var group4 = DispatchGroup()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func checkTwoDays(time: Int, event: Event){
        //change Fonts
//        self.cellLabel.font = UIFont (name: Font.thinFont, size: 30)
//        self.cellLabel.font = self.cellLabel.font.withSize(34)
        self.cellLabel.layer.zPosition = 10
        
        print("{ViewContollerTableViewCell} checkTwoDays time \(time)   event: \(event.eventName)")
        
        //self.cellTime.font = UIFont (name: Font.thinNumbers, size: 55)
        self.cellTime.textColor = UIColor.darkGray
        
//        self.group4.enter()
//        ViewController.getInstance().getETARequest(destination: CLLocationCoordinate2DMake(event.latitude, event.longitude), event: event, index: 0)
        //TODO  86400
        if(time < 0){
            self.cellTime.text = "Fahre bitte los"
            self.backgroundColor = UIColor.red
            
        }else if(time <= Int.max) {
            startTimer(timeInSeconds: time, event: event)
        } else {
            //was tun wenn Zeit noch über 24h?
            self.cellTime.text = "+24h"
        }
    }
    
    
    func startTimer(timeInSeconds: Int, event: Event){
        if (timer != nil) {timer.invalidate()}
//        cellTime.text = "..."
        var secondsLeft: Int = timeInSeconds
        var count = 0
        

        
        //TODO  86400
        if(secondsLeft <= 86400){ // 24hours
            

            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                
                
            
                
                if(secondsLeft == 0 && count > 0) {
                    self.cellTime.text = "..."
                }
                
//                var(h, m, s) = self.secondsToHoursMinutesSeconds(seconds: secondsLeft)
                
            //            self.ausgeben(h: h, m: m, s: s)
                else if (secondsLeft > 0) {
                    EventManager.getInstance().hmsFrom(seconds: secondsLeft, completion: { (hours, minutes, seconds) in
                            let hours = EventManager.getInstance().getStringFrom(seconds: hours)
                            let minutes = EventManager.getInstance().getStringFrom(seconds: minutes)
                            let seconds = EventManager.getInstance().getStringFrom(seconds: seconds)
                        
                            self.cellTime.text = "\(hours):\(minutes):\(seconds)"
                        })
                    secondsLeft = secondsLeft - 1
                }
                    /* color change of cell */
                else if secondsLeft < event.bufferTime * 60 && secondsLeft > 1{
                    var colorIncrediant: CGFloat = (CGFloat(secondsLeft) / CGFloat(event.bufferTime * 60))
                    if colorIncrediant >= 0 {
                        self.backgroundColor = UIColor.red.withAlphaComponent((CGFloat(1 - colorIncrediant))/2)
                    }

                }
                
                else if(secondsLeft < 0 && count > 1){
                    print("EVENT IN SECONDSLEFT < 0 START TIMER: \(event.eventName) WITH SECONDSLEFT: \(secondsLeft)")
                    self.cellTime.text = "Fahre bitte los"
                    self.cellTime.textColor = UIColor.black
                    self.backgroundColor = UIColor.red.withAlphaComponent(0.6)
                    print("REEED")
                    self.cellTime.textColor = UIColor.init(rgb: 0xbf0000)
                    self.timer.invalidate()
                    return
                }
                count = count + 1
            }
        )}else{
            self.cellTime.text = "+24h"
        }
    }
    func ausgeben(h: Int, m: Int, s: Int){


        
        
        if(h==0){
            if(abs(s) <= 9 && s >= 0){
                self.cellTime.text = "\(m):0\(s)"
            }else{
                self.cellTime.text = "\(m):\(s)"
                if(m==0){
                    if(abs(s) <= 9 && s >= -9 && s != 0){
                    
                        self.cellTime.text = "\(s)"
                        
                    }else{
                        self.cellTime.text = "\(m):\(s)"
                    }
                }
            }
        }else{
            if(m==0 && abs(s) >= 0){
                self.cellTime.text = "\(h):0\(m):0\(s)"
            }else{
                if(abs(s) <= 9 && s >= 0){
                    self.cellTime.text = "\(h):\(m):0\(s)"
                }else{
                    self.cellTime.text = "\(h):\(m):\(s)"
                    self.cellTime.sizeToFit()
                }
            }
        }
        //print(("\(h):\(m):\(s)"))
    }
    func secondsToHoursMinutesSeconds(seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
