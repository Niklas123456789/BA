//
//  File.swift
//  DailyRhythm
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
    
//    var imageName: String? {
//        if discipline == "Goal" {
//            return "Location"
//        } else {
//            return "Clock"
//        }
//    }
}

//class TimeMarkerView: MKAnnotationView {
//    override var annotation: MKAnnotation? {
//
//        willSet {
//            if self.annotation?.isKind(of: MapMarker.self) == true {return}
//            guard let timeMaker = newValue as? TimeMarker else {return}
//            canShowCallout = true
//            calloutOffset = CGPoint(x: -5, y: 5)
//            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//
//            if let imageName = timeMaker.imageName {
//                image = UIImage(named: imageName)
//                //image?.size = CGRect(0, 0, 60, 60)
//            } else {
//                image = nil
//            }
//        }
//    }
//}
