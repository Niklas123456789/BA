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
    
    @IBOutlet weak var labelMO: UILabel!
    @IBOutlet weak var backgroundMO: UIImageView!
    @IBOutlet weak var labelDI: UILabel!
    @IBOutlet weak var backgroundDI: UIImageView!
    @IBOutlet weak var labelMI: UILabel!
    @IBOutlet weak var backgroundMI: UIImageView!
    @IBOutlet weak var labelDO: UILabel!
    @IBOutlet weak var backgroundDO: UIImageView!
    @IBOutlet weak var labelFR: UILabel!
    @IBOutlet weak var backgroundFR: UIImageView!
    @IBOutlet weak var labelSA: UILabel!
    @IBOutlet weak var backgroundSA: UIImageView!
    @IBOutlet weak var labelSO: UILabel!
    @IBOutlet weak var backgroundSO: UIImageView!
    
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
    var repeatAtWeekdays: [Int] = [0, 0, 0, 0, 0, 0, 0]
    
    //var nextDate: Date
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
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewEventViewController.tapFunction))
        labelMO.isUserInteractionEnabled = true
        labelMO.addGestureRecognizer(tap)
        
        
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
    
    //Function that trigger wenn OK-Button is pressed
    @IBAction func okButton(_ sender: UIButton) {
        //calc eventTotalSeconds
        //current day
        let todaysDate = Date()
        var todaysWeekday = Calendar.current.component(.weekday, from: todaysDate)
        todaysWeekday = todaysWeekday - 1
        print(todaysWeekday)
        
        //compair to repeatAtWeekdays
        var distanceDaysInSecounds = 0
        if(repeatAtWeekdays.contains(1)){
            //today?
            if(repeatAtWeekdays[todaysWeekday - 1] == 1){
                //distanceDaysInSecounds stays 0
                //TODO: totalEventSeconds
            } else if(repeatAtWeekdays[todaysWeekday] == 12){
                //distanceDaysInSecounds stays 0
                //TODO: totalEventSeconds
            }
        }
        
        
        
        
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


