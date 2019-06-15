//
//  Helper.swift
//  DailyRhythm
//
//  Created by Niklas Großmann on 19.05.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import MapKit
var validAddress = false
class Helper {
    
    static let instance = Helper()
        
    static func getInstance() -> Helper {
        return instance
    }
    
    func checkAddressIsValid(city: String, street: String, number: String, time: TimeInterval, completion: @escaping () -> Void, completionWithError: @escaping () -> Void) {
        let geoCoder = CLGeocoder()
        //let group = DispatchGroup()
        let address = "Germany, \(city), \(street) \(number)"
        
        var timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { (timer) in
            geoCoder.cancelGeocode()
        })
        //group.enter()
        print("{HELPER} CHECKING ADRESS: \(address)")
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // TODO handle no location found
                print("ERROR no location found \(error.debugDescription)")
                timer.invalidate()
                completionWithError()
                return
            }
//            setValidAddress(location: location)
            print("{HELPER} LOCATION: \(location) adress: \(placemarks.first?.name)")
            for placemark in placemarks {
                print("{HELPER} name \(placemark.name)")
            }
            completion()
            
        }
    }
}
extension Date {
    func localString(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium) -> String {
        return DateFormatter.localizedString(from: self, dateStyle: dateStyle, timeStyle: timeStyle)
    }
}
