//
//  File.swift
//  Drive on time
//
//  Created by Niklas Großmann on 18.05.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import MapKit

class TimeMarker: NSObject, MKAnnotation {
    let title: String?
    let image: UIImage?
    let coordinate: CLLocationCoordinate2D
    let discipline: String?
    
    init(title: String, image: UIImage, coordinate: CLLocationCoordinate2D, discipline: String) {
        self.title = title
        self.image = image
        self.coordinate = coordinate
        self.discipline = discipline
        
        
        super.init()
    }

}

