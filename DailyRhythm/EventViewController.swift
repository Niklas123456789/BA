//
//  EventViewController.swift
//  DailyRythmn
//
//  Created by Niklas Großmann on 13.01.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts


class EventViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var infoStack: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetAndNrLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var timeTillGoLabel: UILabel!
    @IBOutlet weak var showHideInfosButton: UIButton!
    var timer: Timer!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    var lat: Double = 0.0
    var long: Double = 0.0
    let group = DispatchGroup()
    var firstCall = true
    @IBOutlet weak var myLocationButton: UIButton!
    var address = ""
    
    @IBAction func showHideInfos(_ sender: Any) {
        if infoStack.isHidden {
            animateView(view: infoStack, toHidden: false)
            animateLabelDown(view: nameLabel, toHidden: false)
            animateLabelDown(view: streetAndNrLabel, toHidden: false)
            animateLabelDown(view: timeLabel, toHidden: false)
            animateLabelDown(view: notesLabel, toHidden: false)
            showHideInfosButton.setImage(UIImage(named: "Down"), for: .normal)
        } else {
            animateView(view: infoStack, toHidden: true)
            animateLabelUp(view: nameLabel, toHidden: true)
            animateLabelUp(view: streetAndNrLabel, toHidden: true)
            animateLabelUp(view: timeLabel, toHidden: true)
            animateLabelUp(view: notesLabel, toHidden: true)
            showHideInfosButton.setImage(UIImage(named: "Up"), for: .normal)
        }
    }
    
    private func animateView(view: UIView, toHidden hidden: Bool) {
        UIView.animate(withDuration: 0.8, delay: 0.05, options: [], animations: {
            view.isHidden = hidden
        }, completion: nil)
    }
    private func animateLabelDown(view: UIView, toHidden hidden: Bool) {
        UIView.animate(withDuration: 0.05, delay: 0, options: [], animations: {
            view.isHidden = hidden
        }, completion: nil)
    }
    private func animateLabelUp(view: UIView, toHidden hidden: Bool) {
        UIView.animate(withDuration: 0.05, delay: 0.8, options: [], animations: {
            view.isHidden = hidden
        }, completion: nil)
    }
    
    @IBAction func openMapsAction(_ sender: Any) {
        let coordinates = CLLocationCoordinate2DMake(lat, long)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = nameLabel.text
        mapItem.openInMaps(launchOptions: options)
    }
    @IBAction func myLocationButtonPressed(_ sender: Any) {
        centerViewOnUserLocation()
        //print("myLocationButten pressed")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocationServices()
        getDirections()

        // Do any additional setup after loading the view.
        myLocationButton.layer.zPosition = 10
        //nameLabel.text = ViewController.tableViewList
        
        nameLabel.text = tableViewList[cellClickedIndex].eventName
        nameLabel.text = nameLabel.text?.capitalizingFirstLetter()
        var street = tableViewList[cellClickedIndex].streetName
        street = street.capitalizingFirstLetter()
        streetAndNrLabel.text = "\(street) \(tableViewList[cellClickedIndex].houseNr)"
        timeLabel.text = tableViewList[cellClickedIndex].eventDate.toString(dateFormat: "HH:mm  dd-MM-yyyy")
        
        if (tableViewList[cellClickedIndex].eventNotes.isEmpty) {
            notesLabel.text = "Keine Notizen"
            notesLabel.textColor = UIColor.gray
        } else {
            notesLabel.text = tableViewList[cellClickedIndex].eventNotes.capitalizingFirstLetter()
            notesLabel.textColor = UIColor.black
        }
        var event = EventManager.getInstance().getEventwithID(eventID: "\(tableViewList[cellClickedIndex].eventID)")
        if event.eventID == "-1" {
            print("getEventwithID returned noEvent")
            return
        }
        var timeTillGo = EventManager.getInstance().getTimeTillGo(event: event)
        
        var(t, m, s) = self.secondsToHoursMinutesSeconds(seconds: timeTillGo)
        ausgeben(h: t, m: m, s: s)
        startTimer(timeInSeconds: timeTillGo, event: event)
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            //setup location manager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //Show POP UP that location is turned off
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func getDirections() {
        guard let location = locationManager.location?.coordinate else {
            //TODO: Inform user that there is no current location
            return
        }
        
        /*let request = */
        createDirectionsReuest(from: location)
        /*
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else { return } //TODO: Alarm because no route found
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
         */
    }
    func getAddress(from event: Event) -> String {
        address = ""
        //if event.houseNrEdited == true {
            address = "Germany, \(event.cityName), \(event.streetName) \(event.houseNr)"
        //} else {
        //    address = "\(event.streetName), \(event.cityName)"
        //}
        return address
    }
    /*
    func addressToLocation(address: String) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // TODO handle no location found
                    print("ERROR no location found")
                    return
                }
            self.lat = location.coordinate.latitude
            print(self.lat)
            self.long = location.coordinate.longitude
        }
        // Use your location
    }
    */
//    func locationToCLLocationCoordinate2D(location: CLLocation) {
//        self.createDirectionsReuest(from: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
//    }
    
    func createDirectionsReuest(from coordinate: CLLocationCoordinate2D) /*-> MKDirections.Request*/
    {
//        let latitude = 48.151256
//        let longitude = 11.623152
//        let testDestination: CLLocationCoordinate2D  = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let event = EventManager.getInstance().getEventwithID(eventID: "\(tableViewList[cellClickedIndex].eventID)")
        let addressEvent = getAddress(from: event)
        print("AddressEvent: \(addressEvent)")
        group.enter()
        //addressToLocation(address: addressEvent)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressEvent) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // TODO handle no location found
                    print("ERROR no location found")
                    return
            }
            self.lat = location.coordinate.latitude
            print(self.lat)
            self.long = location.coordinate.longitude
            self.group.leave()
            
            // show artwork on map
            let mapMarker = MapMarker(title: "\(event.eventName.capitalizingFirstLetter())",
                                  locationName: "\(event.streetName.capitalizingFirstLetter()) \(event.houseNr)",
                                  discipline: "",
                                  coordinate: CLLocationCoordinate2D(latitude: self.lat, longitude: self.long))
            self.mapView.addAnnotation(mapMarker)
            
            self.group.notify(queue: DispatchQueue.main, execute: {
                let destinationEvent: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                
                let startingLocation            = MKPlacemark(coordinate: coordinate)
                let destination                 = MKPlacemark(coordinate: destinationEvent)
                
                let request                     = MKDirections.Request()
                request.source                  = MKMapItem(placemark: startingLocation)
                request.destination             = MKMapItem(placemark: destination)
                request.transportType           = .automobile
                request.requestsAlternateRoutes = true
                //return request
                self.displayDirectionsOverlay(for: MKDirections(request: request))
            })
        }
        /*
        //print("Latitude: \(lat) Longitude: \(long)")
        let destinationEvent: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let destinationCoordiate        = getCenterLocation(for: mapView).coordinate
        let startingLocation            = MKPlacemark(coordinate: coordinate)
        let destination                 = MKPlacemark(coordinate: destinationEvent)
        
        let request                     = MKDirections.Request()
        request.source                  = MKMapItem(placemark: startingLocation)
        request.destination             = MKMapItem(placemark: destination)
        request.transportType           = .automobile
        request.requestsAlternateRoutes = true
        */
        //return request
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //TODO: Show popup alert
            break
        case .denied:
            //TODO: Show popup alert
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            //TODO: Show popup alert
            break
        case .authorizedAlways:
            mapView.showsUserLocation = true
            mapView.showsTraffic = true
            //centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        }
    }
    
    func startTimer(timeInSeconds: Int, event: Event){
        
        var secondsLeft: Int = timeInSeconds
        if(timeInSeconds <= 86400) {
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                
                var(h, m, s) = self.secondsToHoursMinutesSeconds(seconds: secondsLeft)
                
                self.ausgeben(h: h, m: m, s: s)
                secondsLeft = secondsLeft - 1
                
                //TODO:muss noch an event angepasst werden
                if(secondsLeft == -300){
                    self.timer.invalidate()
                }
            }
            )}else{
            //was tun wenn zeit noch über 24h?
            self.timeTillGoLabel.text = "+24h"
        }
    }
    func ausgeben(h: Int, m: Int, s: Int){
        //TODO: Center Text correctly
        timeTillGoLabel.textAlignment = .center
        if(h==0){
            if(abs(s) <= 9 && s >= 0){
                self.timeTillGoLabel.text = "\(m):0\(s)"
            }else{
                self.timeTillGoLabel.text = "\(m):\(s)"
                if(m==0){
                    //-9 muss noch entschieden werden wie lange weiterlaeuft
                    if(abs(s) <= 9 && s >= -9 && s != 0){
                        
                        self.timeTillGoLabel.text = "\(s)"
                        
                        //groesere Schrift vllt
                    }else{
                        self.timeTillGoLabel.text = "\(m):\(s)"
                    }
                }
            }
        }else{
            if(m==0 && abs(s) >= 0){
                self.timeTillGoLabel.text = "\(h):0\(m):0\(s)"
            }else{
                if(abs(s) <= 9 && s >= 0){
                    self.timeTillGoLabel.text = "\(h):\(m):0\(s)"
                }else{
                    self.timeTillGoLabel.text = "\(h):\(m):\(s)"
                    self.timeTillGoLabel.sizeToFit()
                }
            }
        }
        print(("\(h):\(m):\(s)"))
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func displayDirectionsOverlay(for directions: MKDirections) {
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else { return } //TODO: Alarm because no route found
            
            print("found \(response.routes.count) routes")
            
            response.routes.first!.expectedTravelTime
            
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                print("description \(self.mapView.overlays.last!.description)")
            }
            //self.mapView.addOverlay(response.routes.first!.polyline)
            let boundingRect = response.routes.first!.polyline.boundingMapRect
            self.mapView.setVisibleMapRect(boundingRect, edgePadding: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30), animated: true)
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
extension EventViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        if (firstCall) {
            firstCall = false
            mapView.setRegion(region, animated: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension EventViewController {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        //TODO: routenfarbe anpassen. vllt hellblau
        if mapView.overlays.count == 1 {
            renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
            renderer.lineWidth = 5
        } else {
            renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 0.5)
            renderer.lineWidth = 5
        }
        return renderer
    }
}
