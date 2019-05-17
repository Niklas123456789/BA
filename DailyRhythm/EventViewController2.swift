//
//  EventViewController2.swift
//  DailyRhythm
//
//  Created by Niklas Großmann on 12.05.19.
//  Copyright © 2019 Mobile_App_Uni_Ulm. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Contacts

class EventViewController2: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var expectedTimeLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    var timer: Timer!
    let group = DispatchGroup()
    var firstCall = true
    var lat: Double = 0.0
    var long: Double = 0.0
    var address = ""
    var eventNotes = ""
    @IBOutlet weak var mapView: MKMapView!
    enum CardState {
        case expanded
        case collapsed
    }
    
    var cardViewController:CardViewController!
    //var visualEffectView:UIVisualEffectView!
    
    let cardHeight:CGFloat = 320
    let cardHandleAreaHeight:CGFloat = 65
    
    var cardVisible = false
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocationServices()
        getDirections()
        if (tableViewList[cellClickedIndex].eventNotes.isEmpty) {
            eventNotes = ""
        } else {
            eventNotes = tableViewList[cellClickedIndex].eventNotes
        }
        
        myLocationButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        
        activityIndicator.center = self.mapView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.startAnimating()
        
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        var event = EventManager.getInstance().getEventwithID(eventID: "\(tableViewList[cellClickedIndex].eventID)")
        if event.eventID == "-1" {
            print("getEventwithID returned noEvent")
            return
        }
        var timeTillGo = EventManager.getInstance().getTimeTillGo(event: event)
        
        var(t, m, s) = self.secondsToHoursMinutesSeconds(seconds: timeTillGo)
        ausgeben(h: t, m: m, s: s)
        startTimer(timeInSeconds: timeTillGo, event: event)
        //cardViewController.nameLabel.text = "Hallo"
        //setCardLabels(name: event.eventName, street: event.streetName, houseNr: event.houseNr, city: event.cityName, notes: event.eventNotes, bufferTime: event.bufferTime, walkingTime: event.walkingTime, parkingTime: event.parkingTime)
        
        setupCard()
        self.view.bringSubviewToFront(expectedTimeLabel)
    }
    
    func setupCard() {
        //visualEffectView = UIVisualEffectView()
        //visualEffectView.frame = self.view.frame
        //self.view.addSubview(visualEffectView)
//        self.view.translatesAutoresizingMaskIntoConstraints = false
//        let verticalConstraint = NSLayoutConstraint(item: self.myLocationButton.frame, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cardViewController.handleArea.topAnchor, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 100)
//        view.addConstraint(verticalConstraint)
        
//        myLocationButton.translatesAutoresizingMaskIntoConstraints = true
//        var temp = cardViewController.view
//        myLocationButton.center = CGPoint(x: 0, y: temp?.bounds.maxY ?? 300 - 100)
//        myLocationButton.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        
        
        
        cardViewController = CardViewController(nibName:"CardViewController", bundle:nil)
        //TODO: setCardLabels()
        
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight - 140, width: self.view.bounds.width, height: cardHeight)
        
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventViewController2.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(EventViewController2.handleCardPan(recognizer:)))
        
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
        self.view.bringSubviewToFront(cardViewController.view)
        
        self.view.bringSubviewToFront(coverView)
        self.view.bringSubviewToFront(buttonsStack)
        self.view.bringSubviewToFront(timeLabel)
        self.view.bringSubviewToFront(activityIndicator)
        

    }
    
    func setCardLabels(name: String, street: String, houseNr: String, city: String, notes: String, bufferTime: Int, walkingTime: Int, parkingTime: Int){
        
        CardViewController.getInstance().nameLabel?.text = name
        //cardViewController.nameLabel?.text? = name
        /*cardViewController.streetLabel?.text? = "\(street) + \(houseNr)"
        cardViewController.cityLabel?.text? = city
        cardViewController.notesLabel?.text? = notes
        cardViewController.bufferTime?.text? = "\(bufferTime)"
        cardViewController.walkingTime?.text? = "\(walkingTime)"
        cardViewController.parkingTime?.text? = "\(parkingTime)"*/
    }
    
    @objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.cardViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
        
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let myLoationButtonAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.myLocationButton.frame.origin.y = self.view.frame.height - self.cardHeight - 110
                case .collapsed:
                    self.myLocationButton.frame.origin.y = self.view.frame.height - self.cardHeight
                    
                }
            }
            
            myLoationButtonAnimator.addCompletion { (_) in
                self.runningAnimations.removeAll()
            }
            myLoationButtonAnimator.startAnimation()
            runningAnimations.append(myLoationButtonAnimator)
            
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight - 30
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight - 140
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardViewController.view.layer.cornerRadius = 20
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            /*
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    self.visualEffectView.effect = nil
                }
            }
            
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
            */
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
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
    @IBAction func myLocationButtonPressed(_ sender: Any) {
        centerViewOnUserLocation()
        //print("myLocationButten pressed")
    }
    func getDirections() {
        guard let location = locationManager.location?.coordinate else {
            //TODO: Inform user that there is no current location
            return
        }
        
        /*let request = */
        createDirectionsReuest(from: location)
    }
    @IBAction func openMapsAction(_ sender: Any) {
        let coordinates = CLLocationCoordinate2DMake(lat, long)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = cardViewController.nameLabel?.text
        mapItem.openInMaps(launchOptions: options)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func ausgeben(h: Int, m: Int, s: Int){
        //TODO: Center Text correctly
        timeLabel.textAlignment = .center
        if(h==0){
            if(abs(s) <= 9 && s >= 0){
                self.timeLabel.text = "\(m):0\(s)"
            }else{
                self.timeLabel.text = "\(m):\(s)"
                if(m==0){
                    //-9 muss noch entschieden werden wie lange weiterlaeuft
                    if(abs(s) <= 9 && s >= -9 && s != 0){
                        
                        self.timeLabel.text = "\(s)"
                        
                        //groesere Schrift vllt
                    }else{
                        self.timeLabel.text = "\(m):\(s)"
                    }
                }
                if(m <= -1) {
                    self.timeLabel.text = "-\(m)\(abs(s))"
                }
            }
        }else{
            if(m==0 && abs(s) >= 0){
                self.timeLabel.text = "\(h):0\(m):0\(s)"
            }else{
                if(abs(s) <= 9 && s >= 0){
                    self.timeLabel.text = "\(h):\(m):0\(s)"
                }else{
                    self.timeLabel.text = "\(h):\(m):\(s)"
                    self.timeLabel.sizeToFit()
                }
            }
        }
        //print(("\(h):\(m):\(s)"))
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
            self.timeLabel.text = "+24h"
        }
    }
    func createDirectionsReuest(from coordinate: CLLocationCoordinate2D) /*-> MKDirections.Request*/
    {
        //        let latitude = 48.151256
        //        let longitude = 11.623152
        //        let testDestination: CLLocationCoordinate2D  = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let event = EventManager.getInstance().getEventwithID(eventID: "\(tableViewList[cellClickedIndex].eventID)")
        let addressEvent = getAddress(from: event)
        print("AddressEvent: \(addressEvent)")
        
        group.enter()
        /* starts loading animation */
        activityIndicator.center = self.mapView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        
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
            self.activityIndicator.stopAnimating()
            
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
        
    }
    func displayDirectionsOverlay(for directions: MKDirections) {
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else { return } //TODO: Alarm because no route found
            
            print("found \(response.routes.count) routes")
//            var routes2 = response.routes
//            routes2.sort(by:)
            
            var quickestExpectedTravelTime = response.routes.first!.expectedTravelTime
            var (t, h, m) = self.secondsToHoursMinutesSeconds(seconds: Int(quickestExpectedTravelTime/60))
            
            print("quickestExpectedTravelTime: \(h) Std. \(m) Min.")
            print("quickestExpectedTravelTime: \(quickestExpectedTravelTime)")
            
            self.expectedTimeLabel.center = CGPoint(x: response.routes.first!.polyline.boundingMapRect.midX, y: response.routes.first!.polyline.boundingMapRect.midY)
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                
                //route.polyline.coordinate
                print("description \(self.mapView.overlays.last!.description)")
            }
            //self.mapView.addOverlay(response.routes.first!.polyline)
            let boundingRect = response.routes.first!.polyline.boundingMapRect
            self.mapView.setVisibleMapRect(boundingRect, edgePadding: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30), animated: true)
        }
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
}

extension EventViewController2: CLLocationManagerDelegate {
    
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
    func getAddress(from event: Event) -> String {
        address = ""
        //if event.houseNrEdited == true {
        address = "Germany, \(event.cityName), \(event.streetName) \(event.houseNr)"
        //} else {
        //    address = "\(event.streetName), \(event.cityName)"
        //}
        return address
    }
}

extension EventViewController2 {
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

