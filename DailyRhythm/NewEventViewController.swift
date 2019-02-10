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
    
    @IBOutlet weak var MOButton: UIButton!
    var mo: Bool = false
    @IBAction func moAction(_ sender: Any) {
        if(mo==true){
            mo = false
            MOButton.setBackgroundImage(UIImage(named: "LeftBlack"), for: .normal)
            MOButton.setTitleColor(UIColor.black, for: .normal)
        }else{
            mo = true
            MOButton.setBackgroundImage(UIImage(named: "LeftWhite"), for: .normal)
            MOButton.setTitleColor(UIColor.white, for: .normal)
        }
        print("MO pressed")
    }
    
    @IBOutlet weak var DIButton: UIButton!
    var di: Bool = false
    @IBAction func diAction(_ sender: Any) {
        print("DIACTION")
    }
    @IBOutlet weak var MIButton: UIButton!
    var mi: Bool = false
    @IBOutlet weak var DOButton: UIButton!
    var dO: Bool = false
    @IBOutlet weak var FRButton: UIButton!
    var fr: Bool = false
    @IBOutlet weak var SAButton: UIButton!
    var sa: Bool = false
    @IBOutlet weak var SOButton: UIButton!
    var so: Bool = false
    
    
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
    
    //var nextDate: Date
    //let date = Date.init(timeIntervalSinceNow: )
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("heyo")
 
        weekdayStackView.layer.zPosition = 100
        MOButton.layer.zPosition = 101
        
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
    
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {

        print("tap working")
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
        //calc eventTotalSeconds
        //current day
        let todaysDate = Date()
        var todaysWeekday = Calendar.current.component(.weekday, from: todaysDate)
        //var todaysWeekday = 7
        print("Todays Day Nr: \(todaysWeekday)")
        
        //compair to repeatAtWeekdays and get next eventDay

        var countDays = 0
        
        if (arr[todaysWeekday - 1] == true){
            return 0
        }else{
            while (true){
                
                if(todaysWeekday == 8){
                    todaysWeekday = 1
                }else if(arr[todaysWeekday - 1] != true){
                    countDays += 1
                    todaysWeekday += 1
                }else if(arr[todaysWeekday - 1] == true){
                    break
                }
            }
        }
        return countDays

    }
    
    //Function Change back & white Weekdaysbuttons
    
    func invertButtonColor(_ sender: UIButton){
        //if(sender.currentBackgroundImage?.isEqual())
    }
    
    //Function that trigger wenn OK-Button is pressed
    @IBAction func okButton(_ sender: UIButton) {
        
        
        print("Days between today and next event day count: \(countDaysTillNextEventDay(repeatAtWeekdays: repeatAtWeekdays))")
        
        
        ID = ID + 1
        print("WEGZEIT:\(walkingTime)")
        
        if (houseNumberTextField == nil) {
            houseNrEdited = true
        }
        
        //TODO: Check adress
        
        
        //TODO: Save event in JSON

        
//        var newEvent = Event(eventID: ID, eventName: nameTextField.text, streetName: streetTextField.text, houseNr: houseNumberTextField.text, houseNrEdited: houseNrEdited, cityName: cityTextField.text, eventNotes: notesTextField.text, parkingTime: parkingTime, walkingTime: walkingTime, bufferTime: bufferTime, event Date: nextDate, eventTotalSeconds: <#T##Int#>, repeatDuration: Int, repeatAtWeekdays: <#T##[Int]#>)
        //TODO: push notification function
    }
}


