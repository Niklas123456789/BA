//
//  EventViewController.swift
//  Drive on time
//
//  Created by Niklas Großmann on 20.11.18.
//  Copyright © 2018 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import AudioToolbox

var ID: Int = 0
var boxView = UIView()


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
            MOButton.setTitleColor(UIColor(rgb: 0x4D4D4D), for: .normal)
            disableOKButtonCheck()
        }else{
            mo = true
            MOButton.setBackgroundImage(UIImage(named: "LeftBlack"), for: .normal)
            MOButton.setTitleColor(UIColor.white, for: .normal)
        }
        startCheckingValityOfFields()
        
//        checkAddressIsValid({
//            jkfgskjfgjsD
//        })
    }

    var di: Bool = false

    @IBOutlet weak var DIButton: UIButton!
    @IBAction func diAction(_ sender: Any) {
        print("DIENSTAG")
        if(di==true){
            di = false
            DIButton.setBackgroundImage(UIImage(named: "White"), for: .normal)
            DIButton.setTitleColor(UIColor(rgb: 0x4D4D4D), for: .normal)
            disableOKButtonCheck()
        }else{
            di = true
            DIButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
            DIButton.setTitleColor(UIColor.white, for: .normal)
        }
        startCheckingValityOfFields()
    }
    @IBOutlet weak var MIButton: UIButton!
    var mi: Bool = false
    @IBAction func miAction(_ sender: Any) {
        if(mi==true){
            mi = false
            MIButton.setBackgroundImage(UIImage(named: "White"), for: .normal)
            MIButton.setTitleColor(UIColor(rgb: 0x4D4D4D), for: .normal)
            disableOKButtonCheck()
        }else{
            mi = true
            MIButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
            MIButton.setTitleColor(UIColor.white, for: .normal)
        }
        startCheckingValityOfFields()
    }
    
    @IBOutlet weak var DOButton: UIButton!
    var dO: Bool = false
    @IBAction func doAction(_ sender: Any) {
        if(dO==true){
            dO = false
            DOButton.setBackgroundImage(UIImage(named: "White"), for: .normal)
            DOButton.setTitleColor(UIColor(rgb: 0x4D4D4D), for: .normal)
            disableOKButtonCheck()
        }else{
            dO = true
            DOButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
            DOButton.setTitleColor(UIColor.white, for: .normal)
        }
        startCheckingValityOfFields()
    }
    
    @IBOutlet weak var FRButton: UIButton!
    var fr: Bool = false
    @IBAction func frAction(_ sender: Any) {
        if(fr==true){
            fr = false
            FRButton.setBackgroundImage(UIImage(named: "White"), for: .normal)
            FRButton.setTitleColor(UIColor(rgb: 0x4D4D4D), for: .normal)
            disableOKButtonCheck()
        }else{
            fr = true
            FRButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
            FRButton.setTitleColor(UIColor.white, for: .normal)
        }
        startCheckingValityOfFields()
    }
    
    @IBOutlet weak var SAButton: UIButton!
    var sa: Bool = false
    @IBAction func saAction(_ sender: Any) {
        if(sa==true){
            sa = false
            SAButton.setBackgroundImage(UIImage(named: "White"), for: .normal)
            SAButton.setTitleColor(UIColor(rgb: 0x4D4D4D), for: .normal)
            disableOKButtonCheck()
        }else{
            sa = true
            SAButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
            SAButton.setTitleColor(UIColor.white, for: .normal)
        }
        startCheckingValityOfFields()
    }
    
    @IBOutlet weak var SOButton: UIButton!
    var so: Bool = false
    @IBAction func soAction(_ sender: Any) {
        if(so==true){
            so = false
            SOButton.setBackgroundImage(UIImage(named: "RightWhite"), for: .normal)
            SOButton.setTitleColor(UIColor(rgb: 0x4D4D4D), for: .normal)
            disableOKButtonCheck()
        }else{
            so = true
            SOButton.setBackgroundImage(UIImage(named: "RightBlack"), for: .normal)
            SOButton.setTitleColor(UIColor.white, for: .normal)
        }
        startCheckingValityOfFields()
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
    var okButtonIsFullyEnabled: Bool!
    
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
    @IBOutlet weak var okButton: UIButton!
    let group2 = DispatchGroup()
    let group3 = DispatchGroup()
    var validAddess = false
    
//    var duration: Int = 0
    var bufferTime: Int = 0
    var walkingTime: Int = 0
    var parkingTime: Int = 0
    
    var repeatDuration: Int = 0
    
    //Starting with Sunday!
    var repeatAtWeekdays: [Bool] = [false, false, false, false, false, false, false]
    
    var strPickerDate: String = ""
    var pickerHour: Int = 0
    var pickerMin: Int = 0
    @IBOutlet weak var titleLabel: UILabel!
    
    //var nextDate: Date
    //var eventDate: Date = Date.init()
    //let date = Date.init(timeIntervalSinceNow: )
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        okButtonIsFullyEnabled = false
        
//        let img = UIImage(named: "mamor")!.alpha(1.0)
        self.view.backgroundColor = UIColor(rgb: 0x08ACF6)
        
        /* only if new event is made currentEvent = tableViewList[cellClickedIndex] */
        if (settingsSelected == false && tableViewList.isEmpty == false) {
            currentEvent = tableViewList[cellClickedIndex]
        }
        
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
        timePickerData = Array(0...60)
        
        //changing label fonts
        newEventLabel.font = UIFont(name: Font.helveticaLight, size: 24)
        
        bufferLabel.font = UIFont(name: Font.helveticaLight, size: 20)
        walkingtimeLabel.font = UIFont(name: Font.helveticaLight, size: 20)
        parkingLabel.font = UIFont(name: Font.helveticaLight, size: 20)
        
        titleLabel.text = "Neues Ereignis"
        
        /* adding Done button to keyboard */
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        nameTextField.inputAccessoryView = toolBar
        streetTextField.inputAccessoryView = toolBar
        houseNumberTextField.inputAccessoryView = toolBar
        cityTextField.inputAccessoryView = toolBar
        notesTextField.inputAccessoryView = toolBar
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(NewEventViewController.tapFunction))
//        labelMO.isUserInteractionEnabled = true
//        labelMO.addGestureRecognizer(tap)
        
        /* this screen is setting screen */
        print("Settingselected: \(settingsSelected)")
        if settingsSelected == true {
            nameTextField.text = currentEvent.eventName
            streetTextField.text = currentEvent.streetName
            houseNumberTextField.text = currentEvent.houseNr
            cityTextField.text = currentEvent.cityName
            notesTextField.text = currentEvent.eventNotes
            
            /* picker */
            durationPicker.selectRow(currentEvent.repeatDuration, inComponent: 0, animated: true)
            bufferPicker.selectRow(currentEvent.bufferTime, inComponent: 0, animated: true)
            walkingTimePicker.selectRow(currentEvent.walkingTime, inComponent: 0, animated: true)
            parkingTimePicker.selectRow(currentEvent.parkingTime, inComponent: 0, animated: true)
            
            startCheckingValityOfFields()
            /* timePicker */
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
            var tempDate = currentEvent.eventDate.addingTimeInterval((TimeInterval(-(secondsFromGMT))))
            strPickerDate = dateFormatter.string(from: tempDate)
            if let date = dateFormatter.date(from: "\(strPickerDate)") {
                timePicker.date = date
            }
            
            /* days */
            repeatAtWeekdays = currentEvent.repeatAtWeekdays
            if (repeatAtWeekdays[1] == true) {
                mo = true
                MOButton.setBackgroundImage(UIImage(named: "LeftBlack"), for: .normal)
                MOButton.setTitleColor(UIColor.white, for: .normal)
            }
            if (repeatAtWeekdays[2] == true) {
                di = true
                DIButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
                DIButton.setTitleColor(UIColor.white, for: .normal)
            }
            if (repeatAtWeekdays[3] == true) {
                mi = true
                MIButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
                MIButton.setTitleColor(UIColor.white, for: .normal)
            }
            if (repeatAtWeekdays[4] == true) {
                dO = true
                DOButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
                DOButton.setTitleColor(UIColor.white, for: .normal)
            }
            if (repeatAtWeekdays[5] == true) {
                fr = true
                FRButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
                FRButton.setTitleColor(UIColor.white, for: .normal)
            }
            if (repeatAtWeekdays[6] == true) {
                sa = true
                SAButton.setBackgroundImage(UIImage(named: "Black"), for: .normal)
                SAButton.setTitleColor(UIColor.white, for: .normal)
            }
            if (repeatAtWeekdays[0] == true) {
                so = true
                SOButton.setBackgroundImage(UIImage(named: "RightBlack"), for: .normal)
                SOButton.setTitleColor(UIColor.white, for: .normal)
            }
            titleLabel.text = "Einstellungen"
            //self.okButton.setImage(UIImage(named: "OK"), for: .normal)
        }
        
        // neues ereigniss hidden "Neues Ereignis"
        //settingsSelected = false
        
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
        print("TimePicker Hour: \(pickerHour) TimePickerMin: \(pickerMin)")
        view.endEditing(true)

        startCheckingValityOfFields()

    }
    
    func disableOKButtonCheck() {
        let eventWeekdays = [so, mo, di, mi, dO, fr, sa]
        if eventWeekdays.contains(true) {}
        else {
//            self.okButton.setImage(UIImage(named: "OK_white_grey"), for: .normal)
            okButtonIsFullyEnabled = false
        }
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        //closes Keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        view.endEditing(true)
        startCheckingValityOfFields()
        
        if (pickerView.isEqual(durationPicker)) {
            repeatDuration = row
            
            
            
            print("Duration Time: \(repeatDuration)")
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
    
    /*func checkAddressIsValid() -> Bool {
        let geoCoder = CLGeocoder()
        var address = "Germany, \(cityTextField.text), \(streetTextField.text) \(houseNumberTextField.text)"
        var valid = false
        
        func helpFunc(placemarks: [CLPlacemark]) -> Bool{
            print("In helpFunc")
            if placemarks.isEmpty {
                valid = false
                return false
            } else {
                print("TRUUUUE")
                valid = true
                return true
            }
        }
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location,
                helpFunc(placemarks: placemarks)
            else {
                    // TODO handle no location found
                    print("ERROR no location found \(error.debugDescription)")
                    return
                
            }
        }
        return valid
    }*/
    func enableOkCheck() {
        print("in enableOkCheck")
        let eventWeekdays = [so, mo, di, mi, dO, fr, sa]
        //TODO: Add alle anderen pflichtfelder
        if (eventWeekdays.contains(true) && self.nameTextField.text?.isEmpty == false ) {
//            self.okButton.setImage(UIImage(named: "OK"), for: .normal)
            okButtonIsFullyEnabled = true
            //okButton.isUserInteractionEnabled = true
            
        }else{
//            self.okButton.setImage(UIImage(named: "OK_white_grey"), for: .normal)
            okButtonIsFullyEnabled = false
            //okButton.isUserInteractionEnabled = false
        }
        
        
    }
    
    /*func checkAddressIsValid() {
        let geoCoder = CLGeocoder()
        let group = DispatchGroup()
        var address = "Germany, \(cityTextField.text), \(streetTextField.text) \(houseNumberTextField.text)"
        
        let timer = Timer.scheduledTimer(withTimeInterval: 100, repeats: false, block: { (timer) in
            geoCoder.cancelGeocode()
        })
        group.enter()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // TODO handle no location found
                print("ERROR no location found \(error.debugDescription)")
                return
            }
            self.enableOkCheck()
//            if error == nil {
//                self.enableOkCheck()
//            } else {
//                print("ERROR no location found \(error.debugDescription)")
//            }
        }
    }*/
    
    func readyToCheckAddress() -> Bool {
        let eventWeekdays = [so, mo, di, mi, dO, fr, sa]
        if (eventWeekdays.contains(true) && self.nameTextField.text?.isEmpty == false && self.cityTextField.text?.isEmpty == false) {
            return true
        } else {
            
            return false
        }
    }
    
    func startCheckingValityOfFields() {
        if (readyToCheckAddress()) {
            self.enableOkCheck()
        }
    }
    
    static func shake(view: UIView, for duration: TimeInterval = 0.5, withTranslation translation: CGFloat = 10) {
        let propertyAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.3) {
            //view.layer.borderColor = UIColor.red.cgColor
            //view.layer.borderWidth = 1
            view.transform = CGAffineTransform(translationX: translation, y: 0)
        }
        
        propertyAnimator.addAnimations({
            view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, delayFactor: 0.2)
        
        propertyAnimator.addCompletion { (_) in
            view.layer.borderWidth = 0
        }
        
        propertyAnimator.startAnimation()
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
    
    
    //TODO: Change Keyboardlayout with hide keyboard button
    //jumps between textFields when pressing return on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        startCheckingValityOfFields()
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
    @IBAction func okButtonAction(_ sender: UIButton) {
        print("--------------OK BUTTON---------------")
        
        let eventWeekdays = [so, mo, di, mi, dO, fr, sa]
        var weekdaysAreAllFalse = true
        for element in eventWeekdays {
            if element == true {
                weekdaysAreAllFalse = false
                break
            }
        }
        if (okButtonIsFullyEnabled == false){
            /* shake */
            if weekdaysAreAllFalse == true {
                NewEventViewController.shake(view: MOButton)
                NewEventViewController.shake(view: DIButton)
                NewEventViewController.shake(view: MIButton)
                NewEventViewController.shake(view: DOButton)
                NewEventViewController.shake(view: FRButton)
                NewEventViewController.shake(view: SAButton)
                NewEventViewController.shake(view: SOButton)
                print("NO WEEKDAY SELECTED ERROR (no JSON-Event saved)")
            }
            if (self.nameTextField.text?.isEmpty == true) {
                
                NewEventViewController.shake(view: nameTextField)
            }
            if (cityTextField.text?.isEmpty == true) {
                NewEventViewController.shake(view: cityTextField)
                
            }
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            return
        }
        //if(validAddess == false) {return}
        //validAddess = false
        loadingWaitCheckingLocationAnimation()
        datePickerAction(sender: timePicker)
        
        
 //       print("Days between today and next event day count: \(countDaysTillNextEventDay(repeatAtWeekdays: repeatAtWeekdays))")
        
        
        //ID = ID + 1
        let eventID = UUID().uuidString
        print("Event ID: \(eventID)")
        
        print("WEGZEIT:\(walkingTime)")
        
        if (houseNumberTextField == nil) {
            houseNrEdited = true
        }
        
        //TODO: Check adress
        

        
        
        
        
        //yyyy.mm.dd hh:mm

        var todaysRealDate = EventManager.getInstance().getDate()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: todaysRealDate)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        var hour: Int! = components.hour
        let minute: Int! = components.minute
        
        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        hour = hour - Int(secondsFromGMT / 3600)
        
//        let componentsReal = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: todaysRealDate)
        
        print("DATE: \(year):"+"\(month):"+"\(day)   "+"\(hour):\(minute)")

        // HOURS and Minutes between event time and now
        
        print("hour: \(hour)")
        let(difHour, difMin, subSec) = EventManager.getInstance().differenceTwoHourAndMin(currentHours: hour, currentMin: minute, eventHours: pickerHour, eventMin: pickerMin)
        
        //TODO: ERROR when no day is selected
        
        var weeksTillNextEvent: Int = 0
        if repeatDuration == 0 {
            weeksTillNextEvent = 0
        }else if repeatDuration == 1 {
            weeksTillNextEvent = 0
        }else if repeatDuration == 2 {
            weeksTillNextEvent = 1
        }else if repeatDuration == 3 {
            weeksTillNextEvent = 2
            //monatlich
        }else if repeatDuration == 4 {
            weeksTillNextEvent = 3
        }

        //TODO DriveTime?
        let onlyTimeEvent = Event(eventID: "", eventName: "", streetName: "", houseNr: "", houseNrEdited: false, cityName: "", eventNotes: "", parkingTime: parkingTime, walkingTime: walkingTime, bufferTime: bufferTime, eventDate: EventManager.getInstance().getDate(), repeatDuration: repeatDuration, repeatAtWeekdays: eventWeekdays, weeksTillNextEvent: weeksTillNextEvent, driveTime: 0, timeTillGo: 0, mute: false, latitude: 0.0, longitude: 0.0, notificationId: 0)
        
        
        print(onlyTimeEvent)

        var distanceToEventInSecounds = EventManager.getInstance().countDaysTillNextEventDay(event: onlyTimeEvent) * 86400 /*+ difHour * 3600 + difMin * 60 - subSec */
//        var distanceToEventInSecounds = EventManager.getInstance().calcDiffInSecOfNowAndEventDate(event: onlyTimeEvent)
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
//        strPickerDate = dateFormatter.string(from: timePicker.date)
//        var temp:Int! = Int(strPickerDate)
//        pickerMin = temp % 100
//        pickerHour = Int(temp/100)
        
        
        let eventHours = calendar.component(.hour, from: timePicker.date)
        let eventMin = calendar.component(.minute, from: timePicker.date)
        
        
        
//        print("{NewEventViewController} eventHours: \(eventHours) eventMin: \(eventMin)")
        var todaysDate = EventManager.getInstance().getDate()
        var distanceDays = EventManager.getInstance().countDaysTillNextEventDay(event: onlyTimeEvent)
        
        print("TodaysDate!: \(todaysDate)")
        var eventDateNoDaysAdded = Calendar.current.date(bySettingHour: eventHours, minute: eventMin, second: 0, of: todaysDate)!
        var eventDate = Calendar.current.date(byAdding: .day, value: EventManager.getInstance().countDaysTillNextEventDay(event: onlyTimeEvent), to: eventDateNoDaysAdded)!
        eventDate = eventDate.addingTimeInterval(TimeInterval(secondsFromGMT))
        
//      eventDate = eventDate.addingTimeInterval(TimeInterval(secondsFromGMT))
        print("Eventdate: \(eventDate)")
        //sets eventDate only seconds to 0
        print("DistanceToEventInSeconds \(distanceToEventInSecounds)")
//        eventDate = todaysRealDate.addingTimeInterval(Double(distanceToEventInSecounds))
        print("EventDate after creating1: \(eventDate)")
//        eventDate = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: eventDate), minute: Calendar.current.component(.minute, from: eventDate), second: 0, of: Date())!
        eventDate = Calendar.current.date(bySetting: .second, value: 0, of: eventDate)!
//        eventDate = Calendar.current.date(byAdding: .day, value: EventManager.getInstance().countDaysTillNextEventDay(event: onlyTimeEvent), to: eventDate)!
        print("EventDate after creating2: \(eventDate)")
        
        
        
        //var timeTillNextCheck = EventManager.getInstance().calcTimeTillNextCheck()

        
        /* gets lat and long */
        let geoCoder = CLGeocoder()
        var localLat: Double = 0.0
        var localLong: Double = 0.0
        let addressEvent = "Germany, \(cityTextField.text!), \(streetTextField.text!) \(houseNumberTextField.text!)"
        self.group3.enter()
        geoCoder.geocodeAddressString(addressEvent) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    print("ERROR no location found")
                    boxView.removeFromSuperview()
                    self.presentAlertWithTitle(title: "Ungültige Adresse", message: "Die eingegebene Ereignisadresse ist nicht gültig. Bitte korrigiere deine Eingabe.", options: "OK", completion: {
                        (option) in
                        print("option: \(option)")
                        switch(option) {
                        case 0:
                            print("option one")
                            break
                            
                        default:
                            break
                        }
                    })
                    return
            }
            localLat = location.coordinate.latitude
            localLong = location.coordinate.longitude
            self.group3.leave()
        }
        self.group3.notify(queue: DispatchQueue.main) {
        
            //TODO: timeTillNextCheck, driveTime und timeTillGo anpassen!
            var newEvent = Event(eventID: eventID, eventName: self.nameTextField.text!, streetName: self.streetTextField.text!, houseNr: self.houseNumberTextField.text!, houseNrEdited: self.houseNrEdited, cityName: self.cityTextField.text!, eventNotes: self.notesTextField.text!, parkingTime: self.parkingTime, walkingTime: self.walkingTime, bufferTime: self.bufferTime, eventDate: eventDate, repeatDuration: self.repeatDuration, repeatAtWeekdays: eventWeekdays, weeksTillNextEvent: weeksTillNextEvent, driveTime: 0, timeTillGo: 0, mute: false, latitude: localLat, longitude: localLong, notificationId: 0)
            
            print("group3 notify() newEvent: \(newEvent)")
            
            //newEvent = EventManager.getInstance().updateEventTimes(event: &newEvent)
            print("After NewEvent called updateEventTimes: \(newEvent)")
        
            var timeTillNextCheck: Int = 0
            
            print("[NEWEVENTVIEWCONTROLLER] about to call getTimeTillNextCheckAction")
            EventManager.getInstance().getTimeTillNextCheckAction(from: newEvent) { (tempTimeTillNextCheck: Int) in
                timeTillNextCheck = tempTimeTillNextCheck
                print("tempTimeTillNextCheck: \(tempTimeTillNextCheck) \(timeTillNextCheck)")
            }
                DispatchQueue.main.async {
                    
                    print("timeTillNextCheck2: \(timeTillNextCheck)")
                    if timeTillNextCheck <= -1 {
                        print("Return because timeTillNextCheck returned negativ")
                        return
                    }
                    
                    Helper.getInstance().checkAddressIsValid(city: "\(self.cityTextField.text!)", street: "\(self.streetTextField.text!)", number: "\(self.houseNumberTextField.text!)", time: 60, completion: {
                        /* valid address */
                        print("Adress valid")
                        self.validAddess = true
                        
                        //timer that triggers the reapeat of timeTillNextCheck
                        print("before repeatTimeCheck")
                        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeTillNextCheck), repeats: false, block: { (timer) in
                            print("In timer repeatTimecheck")
                            if (timeTillNextCheck >= 0) {
//                                EventManager.getInstance().repeatTimeCheck(event: newEvent)
                                
                            }
                        })
                        EventManager.getInstance().removeDuplicateEvents(from: newEvent)
                        
                        
                        if (settingsSelected == false) {
                            if (self.validAddess == false) {
                                return
                            }
                            newEvent.saveEventInJSON()
                            self.performSegue(withIdentifier: "saveEvent", sender: nil)
                            EventManager.getInstance().updateJSONEvents()
                            
                        } else {
                            currentEvent.deleteEventInJSON()
                            newEvent.saveEventInJSON()
                            currentEvent = newEvent
                            EventManager.getInstance().updateJSONEvents()
                            settingsSelected = false
                            self.performSegue(withIdentifier: "saveEvent", sender: nil)
                        }
                        boxView.removeFromSuperview()
                        
                        
                    }, completionWithError:  {
                        /* handle invalid address */
                        print("{NEWEVENTVIEWCONTROLLER} invalid address")
                        boxView.removeFromSuperview()
                        NewEventViewController.shake(view: self.cityTextField)
                        NewEventViewController.shake(view: self.houseNumberTextField)
                        NewEventViewController.shake(view: self.streetTextField)
                    })
                }
//            }
            
            
        }
    }
    
    func loadingWaitCheckingLocationAnimation() {
        // You only need to adjust this frame to move it anywhere you want
        boxView = UIView(frame: CGRect(x: view.frame.midX - 95, y: view.frame.midY - 25, width: 200, height: 50))
        boxView.backgroundColor = UIColor.init(rgb: 0xEBEBEB)
        boxView.alpha = 1
        boxView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        var activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        var textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = "Prüfe Ereignisort"
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.addSubview(boxView)
    }
    
//    func updateEventTimes(event: Event) -> (Int, Int, Int){
//
//        var eventTotalSeconds = calcDiffInSecOfNowAndEventDate(eventDate: event.eventDate, eventWeekdays: event.repeatAtWeekdays, duration: event.repeatDuration) // MARK: repeatDuration
//        var timeTillNextCheck = (event.eventTotalSeconds - ((event.bufferTime + event.walkingTime + event.parkingTime) * 60) - calcDriveTime(event: event)) / 2
//        //TODO Timer that calls the updateEventTimes when timeTillnextcheck is 0
//        //        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeTillNextCheck), repeats: false, block: { (timer) in
//        //            updateEventTimes(event: self)
//        //        })
//
//
//
//        var timeTillGo = (event.eventTotalSeconds - ((event.bufferTime + event.walkingTime + event.parkingTime) * 60) - calcDriveTime(event: event))
//
//        if event.weeksTillNextEvent != 0 && event.weeksTillNextEvent != 1 {
//            eventTotalSeconds = eventTotalSeconds + ((event.weeksTillNextEvent - 1) * 604800)
//            timeTillNextCheck = timeTillNextCheck + ((event.weeksTillNextEvent - 1) * 604800)
//            timeTillGo = timeTillGo + ((event.weeksTillNextEvent - 1) * 604800)
//        }
//        return (eventTotalSeconds, timeTillNextCheck, timeTillGo)
//    }
    //TODO
    func calcDriveTime(event: Event) -> Int {
        return 0
    }
    
//    func repeatTimeCheck(event: inout Event) {
//        EventManager.getInstance().updateEventTimes(event: &event)
//    }
    
    
    @IBAction func exitButtonAction(_ sender: Any) {
        if (settingsSelected == false) {
            self.performSegue(withIdentifier: "exit", sender: nil)
        } else {
            self.performSegue(withIdentifier: "exitToEvent", sender: nil)
            settingsSelected = false
            titleLabel.text = "Neues Ereignis"
        }
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "saveNewEvent" || identifier == "saveEvent") {
            if (okButtonIsFullyEnabled == true) {
                return true
            } else {
                //TODO: Rückmeldung via vibration
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
        if (identifier == "exit" || identifier == "exitToEvent") {
            return true
        }
        return false
    }
    /* picker row hight */
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if pickerView.isEqual(durationPicker) {
            print("duration picker")
            //durationPicker.rowSize(forComponent: 200)
            
            return 32
        }
        return 22
    }
    
    /* textFields max length */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.isEqual(notesTextField) {
            let currentCharacterCount = textField.text?.utf16.count ?? 0
            if range.length + range.location > currentCharacterCount {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 70
        } else {
            let currentCharacterCount = textField.text?.utf16.count ?? 0
            if range.length + range.location > currentCharacterCount {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 42
        }
    }
}


