//
//  Helper.swift
//  DailyRhythm
//
//  Created by Niklas Großmann on 19.05.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import MapKit
class Helper {
    
    static func checkAddressIsValid(city: String, street: String, number: String, time: TimeInterval, completion: @escaping () -> Void) {
        let geoCoder = CLGeocoder()
        let group = DispatchGroup()
        var address = "Germany, \(city), \(street) \(number)"
        
        let timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { (timer) in
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
            completion()
        }
    }
}
