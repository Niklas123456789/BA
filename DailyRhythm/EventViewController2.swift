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

var expectedTravelTime: Int = -1
var expectedTravelTimeUpdated: Bool = false
var settingsSelected: Bool = false
var currentEvent = Event(eventID: "-1", eventName: "", streetName: "", houseNr: "", houseNrEdited: false, cityName: "", eventNotes: "", parkingTime: 0, walkingTime: 0, bufferTime: 0, eventDate: Date.init(), repeatDuration: 0, repeatAtWeekdays: [false, false, false, false, false, false, false], weeksTillNextEvent: 0, driveTime: 0, timeTillGo: 0, mute: false, latitude: 0.0, longitude: 0.0)
class EventViewController2: UIViewController, MKMapViewDelegate {
    


    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var expectedTimeLabel: UILabel!
//    @IBOutlet weak var timeLabelSubtitle: UILabel!
    let timeLabelSubtitle = UILabel()
    
    
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
    private static let instance = EventViewController2()
    static func getInstance() -> EventViewController2 {
        return instance
    }
    var cardViewController:CardViewController!
    //var visualEffectView:UIVisualEffectView!
    
    let cardHeight:CGFloat = 320
    let cardHandleAreaHeight:CGFloat = 60
    
    var cardVisible = false
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    var boundingRectOfFirstRoute = MKMapRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(settingsSelected == true) {
            settingsSelected = false
        } else {
            currentEvent = tableViewList[cellClickedIndex]
        }
//        self.view.bringSubviewToFront(timeLabelSubtitle)

        timeLabelSubtitle.text = "bis zur Erinnerung"
        timeLabelSubtitle.font = UIFont(name: "HelveticaNeue-Light", size: 10)
        timeLabelSubtitle.textColor = UIColor.darkGray
        timeLabelSubtitle.textAlignment = .center
        timeLabelSubtitle.numberOfLines = 1
        timeLabelSubtitle.frame = CGRect(x: 0, y: 0, width: 140, height: 21)
        self.view.addSubview(timeLabelSubtitle)
        
        
        mapView.delegate = self
        //mapView.register(TimeMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        //mapView.register(MapMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        checkLocationServices()
        getDirections()
        expectedTravelTimeUpdated = false
        if (currentEvent.eventNotes.isEmpty) {
            eventNotes = ""
        } else {
            eventNotes = currentEvent.eventNotes
        }
        
        myLocationButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        
        activityIndicator.center = self.mapView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.startAnimating()
        
        
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        var event = EventManager.getInstance().getEventwithID(eventID: "\(currentEvent.eventID)")
        if event.eventID == "-1" {
            print("getEventwithID returned noEvent")
            return
        }
        
        setupCard()
    }
    
    func setupCard() {

        cardViewController = CardViewController(nibName:"CardViewController", bundle:nil)
        //TODO: setCardLabels()
        
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        myLocationButton.translatesAutoresizingMaskIntoConstraints = false
        myLocationButton.bottomAnchor.constraint(equalTo: cardViewController.view.topAnchor, constant: -10).isActive = true
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight - 140, width: self.view.bounds.width, height: cardHeight)
        
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventViewController2.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(EventViewController2.handleCardPan(recognizer:)))
        
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
        self.view.bringSubviewToFront(cardViewController.view)
        
        self.view.bringSubviewToFront(coverView)
        
        self.view.bringSubviewToFront(timeLabel)
        
        self.view.bringSubviewToFront(buttonsStack)
        self.view.bringSubviewToFront(timeLabelSubtitle)
        self.view.bringSubviewToFront(activityIndicator)

        timeLabelSubtitle.translatesAutoresizingMaskIntoConstraints = false
        timeLabelSubtitle.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: -10).isActive = true
        timeLabelSubtitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true

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
            var fractionComplete = translation.y / (cardHeight + 45)
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            print("FractionComplete: \(fractionComplete)")
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
                    self.myLocationButton.frame.origin.y = self.view.frame.height - self.cardHeight - 80
                case .collapsed:
                    self.myLocationButton.frame.origin.y = self.view.frame.height - self.cardHeight + 75
                    
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
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight - 40
                    if (expectedTravelTime != -1) {
                        self.mapView.setVisibleMapRect(self.boundingRectOfFirstRoute, edgePadding: UIEdgeInsets(top: 40, left: 50, bottom: 225, right: 50), animated: true)
                    }
                    
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight - 135
                    if(expectedTravelTime != -1) {
                        self.mapView.setVisibleMapRect(self.boundingRectOfFirstRoute, edgePadding: UIEdgeInsets(top: 40, left: 50, bottom: 120, right: 50), animated: true)
                    }
                    
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
                    self.cardViewController.view.layer.cornerRadius = 25
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 15
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
            // Inform user that there is no current location
            presentAlertWithTitle(title: "Keinen Standort gefungen", message: "Die App konnte deinen Standort nicht finden", options: "OK", completion: {
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
            if(m==0 && abs(s) >= 0 && abs(s) < 10){
                self.timeLabel.text = "\(h):0\(m):0\(s)"
            }else{
                if(abs(s) <= 9 && s >= 0){
                    self.timeLabel.text = "\(h):\(m):0\(s)"
                }else{
                    self.timeLabel.text = "\(h):\(m):\(s)"
                    //self.timeLabel.sizeToFit()
                }
            }
        }
        //print(("\(h):\(m):\(s)"))
    }
    
    func startTimer(timeInSeconds: Int, event: Event){
        
        var secondsLeft: Int = timeInSeconds
        if(timeInSeconds <= 86400) {
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                
                if (secondsLeft > 0) {
                    var(h, m, s) = self.secondsToHoursMinutesSeconds(seconds: secondsLeft)
//                    self.ausgeben(h: h, m: m, s: s)
                    EventManager.getInstance().hmsFrom(seconds: secondsLeft, completion: { (hours, minutes, seconds) in
                        let hours = EventManager.getInstance().getStringFrom(seconds: hours)
                        let minutes = EventManager.getInstance().getStringFrom(seconds: minutes)
                        let seconds = EventManager.getInstance().getStringFrom(seconds: seconds)
                        
                        self.timeLabel.text = "\(hours):\(minutes):\(seconds)"
                    })
                    secondsLeft = secondsLeft - 1
                } else {
                    var timeToEvent = EventManager.getInstance().calcDifNowAndEvent(event: event)
                    self.timer.invalidate()
                    if (self.timeLabelSubtitle.text == "bis zur Erinnerung") {
                        self.timeLabelSubtitle.text = "bis zum Ereignis"
                        self.startTimer(timeInSeconds: timeToEvent, event: event)
//                        TODO Timer der eventuell neues Event erstellt
                    }
                    return
//                    self.timeLabel.text = ""
                    
                }
                //TODO:muss noch an event angepasst werden
                if(secondsLeft == -300){
                    self.timer.invalidate()
                }
            })
            
        }else{
            //was tun wenn zeit noch über 24h?
            self.timeLabel.text = "+24h"
        }
    }
    func createDirectionsReuest(from coordinate: CLLocationCoordinate2D) /*-> MKDirections.Request*/
    {
        //        let latitude = 48.151256
        //        let longitude = 11.623152
        //        let testDestination: CLLocationCoordinate2D  = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let event = EventManager.getInstance().getEventwithID(eventID: "\(currentEvent.eventID)")
        let addressEvent = getAddress(from: event)
        print("AddressEvent: \(addressEvent)")
        print("{EVENTVIEWCONTROLLER2} CHECKING ADRESS: \(addressEvent)")
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
                    // handle no location found
                    print("ERROR no location found")
                    self.presentAlertWithTitle(title: "Dein Ziel konnte nicht gefunden werden", message: "Bitte überprüfe deine Internetverbindung und deine Ortungsdienste", options: "OK", completion: {
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
            for placemark in placemarks {
            print("{EVENTVIEWCONTROLLER2} PLACEMARK NAME: \(placemark.name)")
            }
            self.lat = location.coordinate.latitude
            print(self.lat)
            self.long = location.coordinate.longitude
            self.group.leave()
            self.activityIndicator.stopAnimating()
            

            
            // show artwork on map
            let mapMarker = MapMarker(title: "\(event.eventName.capitalizingFirstLetter())",
                locationName: "\(event.streetName.capitalizingFirstLetter()) \(event.houseNr)",
                discipline: "Goal",
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
                
               
               
                var timer = Timer()
                timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                    if (expectedTravelTime == -1) {
                        //print("no expectedTavelTime")
                        
                    } else {
                        /* sets time till go tith travel time */
                        let timeTillGo = EventManager.getInstance().getTimeTillGo(event: event) - self.getTravelTime()
                        print("getTravelTime: \(self.getTravelTime())")
                        self.startTimer(timeInSeconds: timeTillGo, event: event)
                        timer.invalidate()
                    }
                })
            })
        }
        
    }
    private func setTravelTime(travelTime: Int) {
        expectedTravelTime = travelTime
        expectedTravelTimeUpdated = true
        print("in setTravelTime \(expectedTravelTime)")
    }
    func getTravelTime() -> Int{
        return expectedTravelTime
    }
    
    func displayDirectionsOverlay(for directions: MKDirections) {
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else {
                self.presentAlertWithTitle(title: "Keine Route gefunden", message: "Bitte überprüfe deine Internetverbindung", options: "OK", completion: {
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
                return }
            
            print("found \(response.routes.count) routes")
//            var routes2 = response.routes
//            routes2.sort(by:)
            
            var quickestExpectedTravelTime = response.routes.first!.expectedTravelTime
            var (t, h, m) = self.secondsToHoursMinutesSeconds(seconds: Int(quickestExpectedTravelTime/60))
            //CardViewController.getInstance().setExpectedTravelTime(time: 5)
            
            print("quickestExpectedTravelTime: \(h) Std. \(m) Min.")
            print("quickestExpectedTravelTime: \(quickestExpectedTravelTime)")
            
            //self.expectedTimeLabel.center = CGPoint(x: response.routes.first!.polyline.boundingMapRect.midX, y: response.routes.first!.polyline.boundingMapRect.midY)
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                
                //route.polyline.coordinate
                print("expectedTravelTime \(route.expectedTravelTime)")
            }
            self.setTravelTime(travelTime: Int(quickestExpectedTravelTime)) //self.mapView.addOverlay(response.routes.first!.polyline)
            self.boundingRectOfFirstRoute = MKMapRect(x: response.routes.first!.polyline.boundingMapRect.midX, y: response.routes.first!.polyline.boundingMapRect.midY, width: response.routes.first!.polyline.boundingMapRect.width, height: response.routes.first!.polyline.boundingMapRect.height)
            
            self.boundingRectOfFirstRoute = response.routes.first!.polyline.boundingMapRect
            self.group.enter()
            self.mapView.setVisibleMapRect(self.boundingRectOfFirstRoute, edgePadding: UIEdgeInsets(top: 60, left: 60, bottom: 80, right: 60), animated: true)
            self.group.leave()
            self.group.notify(queue: DispatchQueue.main, execute: {
                
            })
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
            // Show popup alert
            presentAlertWithTitle(title: "Erlaube \"Daily Rhythm\" auf deinen Standort zuzugreifen", message: "Um jedes Ereignis zeitlich optimal vorrauszuplanen benötigt die App dauerhaft Zugriff auf deinen Standort. Es werden keine Daten gespeichert oder an Dritte weitergegenen! Klicke auf Einstellungen und setze den Standortzugriff auf \"immer\".", options: "Verlassen", "Einstellungen", completion: {
                (option) in
                print("option: \(option)")
                switch(option) {
                case 0:
                    UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                           to: UIApplication.shared, for: nil)
                    break
                case 1:
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                default:
                    break
                }
            })
            break
        case .denied:
            // Show popup alert
            presentAlertWithTitle(title: "Erlaube \"Daily Rhythm\" auf deinen Standort zuzugreifen", message: "Um jedes Ereignis zeitlich optimal vorrauszuplanen benötigt die App dauerhaft Zugriff auf deinen Standort. Es werden keine Daten gespeichert oder an Dritte weitergegenen! Klicke auf Einstellungen und setze den Standortzugriff auf \"immer\".", options: "Verlassen", "Einstellungen", completion: {
                (option) in
                print("option: \(option)")
                switch(option) {
                case 0:
                    UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                           to: UIApplication.shared, for: nil)
                    break
                case 1:
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                default:
                    break
                }
            })
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            // Show popup alert
            presentAlertWithTitle(title: "Erlaube \"Daily Rhythm\" auf deinen Standort zuzugreifen", message: "Um jedes Ereignis zeitlich optimal vorrauszuplanen benötigt die App dauerhaft Zugriff auf deinen Standort. Es werden keine Daten gespeichert oder an Dritte weitergegenen! Klicke auf Einstellungen und setze den Standortzugriff auf \"immer\".", options: "Verlassen", "Einstellungen", completion: {
                (option) in
                print("option: \(option)")
                switch(option) {
                case 0:
                    UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                           to: UIApplication.shared, for: nil)
                    break
                case 1:
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                default:
                    break
                }
            })
            break
        case .authorizedAlways:
            mapView.showsUserLocation = true
            mapView.showsTraffic = true
            //centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        }
    }
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        if identifier == "segueSettings" {
//            print("performs segue")
//            settingsSelected = true
//        }
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueSettings" {
            print("performs segue to settings")
            settingsSelected = true
            currentEvent = tableViewList[cellClickedIndex]
        }
        if segue.identifier == "backFromEvent" {
            expectedTravelTime = -1
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
    // 1
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        // 2
//        guard let annotation = annotation as? MapMarker else { return nil }
//        // 3
//        let identifier = "marker"
//        var view: MKMarkerAnnotationView
//        // 4
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//            as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            // 5
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
//    }
}
