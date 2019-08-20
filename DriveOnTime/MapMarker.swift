//
//  MapMarker.swift
//  Drive on time
//
//  Created by Niklas Großmann on 06.05.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import MapKit

class MapMarker: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String?
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
//    var imageName: String? {
//        if discipline == "Goal" {
//            return "Location"
//        } else {
//            return "Clock"
//        }
//    }
}
//class MapMarkerView: MKAnnotationView {
//    override var annotation: MKAnnotation? {
//        
//        willSet {
//            //if self.annotation?.isKind(of: MapMarker.self) == true {return}
//            guard let mapMarker = newValue as? MapMarker else {return}
//            canShowCallout = true
//            calloutOffset = CGPoint(x: -5, y: 5)
//            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            
//            if let imageName = mapMarker.imageName {
//                image = UIImage(named: imageName)
//                //image?.size = CGRect(0, 0, 60, 60)
//            } else {
//                image = nil
//            }
//        }
//    }
//}
