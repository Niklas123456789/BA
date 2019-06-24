//
//  ViewContollerTableViewCell.swift
//  DailyRythmn
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
        
        //self.cellTime.font = UIFont (name: Font.thinNumbers, size: 55)
        self.cellTime.textColor = UIColor.darkGray
        
//        self.group4.enter()
//        ViewController.getInstance().getETARequest(destination: CLLocationCoordinate2DMake(event.latitude, event.longitude), event: event, index: 0)
        //TODO  86400
        if(time < 0){
            self.cellTime.text = "Fahr bitte los"
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
        
        var secondsLeft: Int = timeInSeconds
        //TODO  86400
        if(time <= Int.max){
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            
            var(h, m, s) = self.secondsToHoursMinutesSeconds(seconds: secondsLeft)
            
            self.ausgeben(h: h, m: m, s: s)
            secondsLeft = secondsLeft - 1
            
            if secondsLeft == 1 {
                //benachrichtigung muss raus
                //EventManager.getInstance().createNotification(for: event)
            }
                //Todo farbe dynamisch verändern
            if secondsLeft < event.bufferTime * 60 {
                    //schoener machen
                var colorIncrediant: CGFloat = (CGFloat(secondsLeft) / CGFloat(event.bufferTime * 60))
                if colorIncrediant >= 0 {
                    self.backgroundColor = UIColor.red.withAlphaComponent((CGFloat(1 - colorIncrediant))/2)
                }
                print("color \(colorIncrediant)")
                //TODO muss noch an event angepasst werden
            }
            if(secondsLeft < 0){
                self.cellTime.text = "Fahr bitte los"
                self.timer.invalidate()
            }
        }
        )}else{
            //was tun wenn zeit noch über 24h?
//            self.cellTime.text = "+24h"
        }
    }
    func ausgeben(h: Int, m: Int, s: Int){


        
        
        if(h==0){
            if(abs(s) <= 9 && s >= 0){
                self.cellTime.text = "\(m):0\(s)"
            }else{
                self.cellTime.text = "\(m):\(s)"
                if(m==0){
                    //TODO -9 muss noch entschieden werden wie lange weiterlaeuft
                    if(abs(s) <= 9 && s >= -9 && s != 0){
                    
                        self.cellTime.text = "\(s)"
                        
                    //groesere Schrift vllt
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
