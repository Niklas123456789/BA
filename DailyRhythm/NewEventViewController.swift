//
//  EventViewController.swift
//  DailyRythmn
//
//  Created by Niklas Großmann on 20.11.18.
//  Copyright © 2018 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import UIKit

var ID: Int = 0

class NewEventViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{



    var houseNrEdited = false
    @IBOutlet weak var weekdayStackView: UIStackView!

    var mo: Bool = false
    
    @IBOutlet weak var MOButton: UIButton!
    @IBAction func moAction(_ sender: Any) {
        print("MONDAY")
        if(mo==true){
            mo = false
            MOButton.setBackgroundImage(UIImage(named: "LeftWhite"), for: .normal)
            MOButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            mo = true
            MOButton.setBackgroundImage(UIImage(named: "LeftBlack"), for: .normal)
            MOButton.setTitleColor(UIColor.white, for: .normal)
        }
    }

    var di: Bool = false

    @IBOutlet weak var DIButton: UIButton!
    @IBAction func diAction(_ sender: Any) {
        print("DIENSTAG")
        if(di==true){
            di = false
            DIButton.setBackgroundImage(UIImage(named: "White"), for: .normal)
            DIButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            di = true
            DIButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
            DIButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    @IBOutlet weak var MIButton: UIButton!
    var mi: Bool = false
    @IBAction func miAction(_ sender: Any) {
        if(mi==true){
            mi = false
            MIButton.setBackgroundImage(UIImage(named: "White"), for: .normal)
            MIButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            mi = true
            MIButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
            MIButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    @IBOutlet weak var DOButton: UIButton!
    var dO: Bool = false
    @IBAction func doAction(_ sender: Any) {
        if(dO==true){
            dO = false
            DOButton.setBackgroundImage(UIImage(named: "White"), for: .normal)
            DOButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            dO = true
            DOButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
            DOButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    @IBOutlet weak var FRButton: UIButton!
    var fr: Bool = false
    @IBAction func frAction(_ sender: Any) {
        if(fr==true){
            fr = false
            FRButton.setBackgroundImage(UIImage(named: "White"), for: .normal)
            FRButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            fr = true
            FRButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
            FRButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    @IBOutlet weak var SAButton: UIButton!
    var sa: Bool = false
    @IBAction func saAction(_ sender: Any) {
        if(sa==true){
            sa = false
            SAButton.setBackgroundImage(UIImage(named: "White"), for: .normal)
            SAButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            sa = true
            SAButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
            SAButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    @IBOutlet weak var SOButton: UIButton!
    var so: Bool = false
    @IBAction func soAction(_ sender: Any) {
        if(so==true){
            so = false
            SOButton.setBackgroundImage(UIImage(named: "RightWhite"), for: .normal)
            SOButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            so = true
            SOButton.setBackgroundImage(UIImage(named: "RightBlack"), for: .normal)
            SOButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    
//
//    @IBOutlet weak var containerStackView: UIStackView!
//    @IBOutlet weak var firstContainerStackView: UIStackView!
//    @IBOutlet weak var topLabel: UILabel!
//    @IBOutlet weak var bufferLabel: UILabel!
//    @IBOutlet weak var walkingLabel: UILabel!
//    @IBOutlet weak var parkingLabel: UILabel!
//
//    @IBOutlet weak var firstContainer: UIView!
//    @IBOutlet weak var secondContainer: UIView!
//    @IBOutlet weak var thirdContainer: UIView!
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var newEventLabel: UILabel!
    @IBOutlet weak var bufferLabel: UILabel!
    @IBOutlet weak var walkingtimeLabel: UILabel!

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var houseNumberTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    @IBOutlet weak var durationPicker: UIPickerView!
    var durationPickerData: [String] = [String]()
    
   
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var bufferPicker: UIPickerView!
    @IBOutlet weak var walkingTimePicker: UIPickerView!
    @IBOutlet weak var parkingTimePicker: UIPickerView!
    var timePickerData: [Int] = [Int]()
    
    var duration: String = ""
    var bufferTime: Int = 0
    var walkingTime: Int = 0
    var parkingTime: Int = 0
    
    var repeatDuration: Int = 0
    
    //Starting with Sunday!
    var repeatAtWeekdays: [Bool] = [false, false, false, false, false, false, false]
    
    var strPickerDate: String = ""
    var pickerHour: Int = 0
    var pickerMin: Int = 0
    
    //var nextDate: Date
    //var eventDate: Date = Date.init()
    //let date = Date.init(timeIntervalSinceNow: )
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("heyo")

        
        


        
        //Picker Delegates
        self.durationPicker.delegate = self
        self.bufferPicker.delegate = self
        self.walkingTimePicker.delegate = self
        self.parkingTimePicker.delegate = self
        
        nameTextField.delegate = self
        
        //Picker DataSources
        self.durationPicker.dataSource = self
        self.bufferPicker.dataSource = self
        self.walkingTimePicker.dataSource = self
        self.parkingTimePicker.dataSource = self

        
        //creating picker data
        durationPickerData = ["einmalig", "jede Woche", "alle 2 Wochen", "alle 3 Wochen", "monatlich"]
        timePickerData = Array(0...99)
        
        //changing label fonts
        newEventLabel.font = UIFont(name: Font.helveticaLight, size: 24)
        
        bufferLabel.font = UIFont(name: Font.helveticaLight, size: 20)
        walkingtimeLabel.font = UIFont(name: Font.helveticaLight, size: 20)
        parkingLabel.font = UIFont(name: Font.helveticaLight, size: 20)
        
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(NewEventViewController.tapFunction))
//        labelMO.isUserInteractionEnabled = true
//        labelMO.addGestureRecognizer(tap)
        
        
    }
    
    
    //@objc func tapFunction(sender:UITapGestureRecognizer) {

        //print("tap working")
    //}
    
    @IBAction func datePickerAction(sender: AnyObject) {
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        strPickerDate = dateFormatter.string(from: timePicker.date)
        var temp:Int! = Int(strPickerDate)
        pickerMin = temp % 100
        pickerHour = Int(temp/100)
        print("Time datePicker: \(strPickerDate)")
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        //closes Keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        
        if (pickerView.isEqual(durationPicker)) {
            duration = durationPickerData[row]
            print("Duration Time: \(duration)")
        }
        if(pickerView.isEqual(bufferPicker)) {
            bufferTime = timePickerData[row]
            print("Buffer Time: \(bufferTime)")
        }
        if(pickerView.isEqual(walkingTimePicker)) {
            walkingTime = timePickerData[row]
            print("Walking Time: \(walkingTime)")
        }
        if(pickerView.isEqual(parkingTimePicker)) {
            parkingTime = timePickerData[row]
            print("Parking Time: \(parkingTime)")
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.durationPicker.endEditing(true)
        self.timePicker.endEditing(true)
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.isEqual(durationPicker)){
            return durationPickerData.count
        }else{
            return timePickerData.count
        }
    }
    
    //change fonts and size of pickers
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        if(pickerView.isEqual(durationPicker)){
            //label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont(name: Font.helveticaLight, size: 22)
        
            // where data is an Array of String
            label.text = durationPickerData[row]
        }else{
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.regular)
            
            // where data is an Array of String
            label.text = "\(timePickerData[row])"
        }
        return label
    }
    
    
    
    //jumps between textFields when pressing return on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            
        case nameTextField:
            streetTextField.becomeFirstResponder()
        case streetTextField:
            houseNumberTextField.becomeFirstResponder()
        case houseNumberTextField:
            cityTextField.becomeFirstResponder()
        case cityTextField:
            notesTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
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

    
    //Function that trigger wenn OK-Button is pressed
    @IBAction func okButton(_ sender: UIButton) {
        datePickerAction(sender: timePicker)
        
        
 //       print("Days between today and next event day count: \(countDaysTillNextEventDay(repeatAtWeekdays: repeatAtWeekdays))")
        
        
        ID = ID + 1
        print("WEGZEIT:\(walkingTime)")
        
        if (houseNumberTextField == nil) {
            houseNrEdited = true
        }
        
        //TODO: Check adress
        
        //checks repeatAtWeekdays and checks if all are false
        let eventWeekdays = [so, mo, di, mi, dO, fr, sa]
        var weekdaysAreAllFalse = true
        for element in eventWeekdays {
            if element == true {
                weekdaysAreAllFalse = false
                break
            }
        }
        if weekdaysAreAllFalse == true {
            print("NO WEEKDAY SELECTED ERROR (no JSON-Event saved)")
            return
        }

        
        //TODO: Save event in JSON
        
        //yyy.mm.dd hh:mm
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        let hour: Int! = components.hour
        let minute: Int! = components.minute
        
        
        
        print("DATE: \(year):"+"\(month):"+"\(day)   "+"\(hour):\(minute)")

        // HOURS and Minutes between event time and now

        let(difHour, difMin) = differenceTwoHourAndMin(currentHours: hour, currentMin: minute, eventHours: pickerHour, eventMin: pickerMin)
        
        //TODO: ERROR when no day is selected
        print(countDaysTillNextEventDay(repeatAtWeekdays: eventWeekdays))
        
        

        var distanceToEventInSecounds = countDaysTillNextEventDay(repeatAtWeekdays: eventWeekdays) * 86400 + difHour * 3600 + difMin * 60
        print(distanceToEventInSecounds)
        
        var eventDate = date.addingTimeInterval(Double(distanceToEventInSecounds))

        
        var newEvent = Event(eventID: ID, eventName: nameTextField.text!, streetName: streetTextField.text!, houseNr: houseNumberTextField.text!, houseNrEdited: houseNrEdited, cityName: cityTextField.text!, eventNotes: notesTextField.text!, parkingTime: parkingTime, walkingTime: walkingTime, bufferTime: bufferTime, eventDate: eventDate, eventTotalSeconds: distanceToEventInSecounds, repeatDuration: repeatDuration, repeatAtWeekdays: eventWeekdays)
        //TODO: push notification function
        
        //TODO: load allEventScreen
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
}


