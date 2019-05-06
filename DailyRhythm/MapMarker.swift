//
//  MapMarker.swift
//  DailyRhythm
//
//  Created by Niklas Großmann on 06.05.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import MapKit

class MapMarker: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
