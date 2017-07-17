//
//  ViewController.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/5/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// TO DO: add checks that location is enabled and accurate location found!
// change filter, enable location services always
// reset data values
// disenable start button once run starts until stop is pressed
// dont let start until location is found

class TrackRunVC: UIViewController, CLLocationManagerDelegate {
        
    // MARK: Properties
    // Timer
    var timer = Timer()
    let stopwatch = Stopwatch()
        
    // Mileage
    let locationManager = CLLocationManager()
    var coordinates: [CLLocation] = []
    var distance1 = Measurement(value: 0, unit: UnitLength.meters)
    var distance2 : Double = 0
    var run = Run()
    var storeCoordinates = false
        
    // Outlets
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceInMilesLabel: UILabel!
    @IBOutlet weak var startLabel: UIButton!
    @IBOutlet weak var stopLabel: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
        
        // MARK: Actions
    @IBAction func startRun(_ sender: Any) {
        storeCoordinates = true
        startTimer()
        
        if startLabel.currentTitle == "Continue" {
            locationManager.startUpdatingLocation()
        } else if startLabel.currentTitle == "Start" && coordinates.count > 0 {
        }
    }
    
    @IBAction func stopRun(_ sender: Any) {
        if stopLabel.currentTitle == "Stop" {
            storeCoordinates = false
            stopTimer()
        } else { // stopLabel = "Finish
            locationManager.stopUpdatingLocation()
            storeCoordinates = false
            resetTimer()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
            
        timerLabel.text = "0:00"
        setUpLocationManager()
    }
        
    // MARK: Location Services
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
        // generates authorization popup
        locationManager.requestWhenInUseAuthorization()
        
        // location updates may be pasued if the user does not move a significant distance over a period of time
        locationManager.activityType = .fitness
            
        // get location updates every 10 meters traveled
        locationManager.distanceFilter = 10
            
        // looks for GPS coordinates of iphone. This method is asynchronous!
        locationManager.startUpdatingLocation()
    }
        
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
            
        // check to see if location is valid
        if location.horizontalAccuracy > 0 && location.horizontalAccuracy < 20 {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            if storeCoordinates {
                coordinates.append(location)
                updateDistance()
                addPin()
            }
                
            //  Zoom in map to user location
            let span : MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let userLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let region : MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
            map.setRegion(region, animated: true)
            self.map.showsUserLocation = true
        }
            
    }
        
    func addPin() {
            // Create coordinate
        let pin = MKPointAnnotation()
        let pinNumber = coordinates.count
        pin.title = "Pin #\(pinNumber)"
            
        let locationCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(coordinates[pinNumber - 1].coordinate.latitude, coordinates[pinNumber - 1].coordinate.longitude)
        pin.coordinate = locationCoordinate
        self.map.addAnnotation(pin)
    }
        
    func updateDistance() {
        if coordinates.count > 1 {
            let lastLocation = coordinates[coordinates.count - 2]
            let newLocation = coordinates[coordinates.count - 1]
            let delta : CLLocationDistance = newLocation.distance(from: lastLocation)
            distance2 += delta
            distance1 = distance1 + Measurement(value: delta, unit: UnitLength.meters)
                
            let distance2InMiles = distance2 * 0.000621371192
            let distnace1InMiles = distance1.converted(to: UnitLength.miles)
                
            distanceInMilesLabel.text = "Distance(mi)2: " + String(format: "%.2f", distnace1InMiles.value)
                
            distanceLabel.text = "Distance(mi)1: " + String(format: "%.2f", distance2InMiles)
        }
    }
    
    // MARK: Timer
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TrackRunVC.updateTimerLabel), userInfo: nil, repeats: true)
        startLabel.setTitle("Start", for: .normal)
        stopLabel.setTitle("Stop", for: .normal)
//        startStopLabel.setTitle("Pause", for: .normal)
//        finishLabel.isHidden = true
    }
    
    func stopTimer() {
        timer.invalidate()
        startLabel.setTitle("Continue", for: .normal)
        stopLabel.setTitle("Finish", for: .normal)
//        startStopLabel.setTitle("Start", for: .normal)
//        finishLabel.isHidden = false
    }
    
    func resetTimer() {
        stopwatch.reset()
        timerLabel.text = stopwatch.convertTimeToString()
//        finishLabel.isHidden = true
    }
    
    func updateTimerLabel() {
        stopwatch.incrementTime()
        timerLabel.text = stopwatch.convertTimeToString()
    }
}
//saveRun()
//performSegue(withIdentifier: "showRunSummary", sender: self)


//for newLocation in locations {
//    print("horizontal accuracy:")
//    print(newLocation.horizontalAccuracy)
//    let timeElapsed = newLocation.timestamp.timeIntervalSinceNow
//    // check that location update is recent, valid, and within 20 meters of the user's actual location
//    guard newLocation.horizontalAccuracy < 20 && newLocation.horizontalAccuracy > 0 && abs(timeElapsed) < 10 else { continue }
//    
//    if let lastLocation = locations.last {
//        let delta = newLocation.distance(from: lastLocation)
//        distance += delta
//        let distanceInMiles = distance * 0.000621371192
//        mileageLabel.text = "Distance(mi): " + String(format: "%.2f", distanceInMiles)
//    }
//    locationCoordinates.append(newLocation)
//}

//func resetRun() {
//    // would rather reset at the end
//    //        distance = Measurement(value: 0, unit: UnitLength.meters)
//    //        locationCoordinates.removeAll()
//    //        mileageLabel.text = "0:00"
//    //        paceLabel.text = "0'00\""
//    //        locationManager.startUpdatingLocation()
//}

//private func saveRun() {
//    //        run.distance = distance.value
//    run.distance = distance
//    run.duration = stopwatch.time
//    run.timestamp = Date()
//    
//    // add init
//    for location in locationCoordinates {

//@IBAction func startStopTimer(_ sender: Any) {
//    if startStopLabel.currentTitle == "Start" {
//        
//        
//        locationManager.startUpdatingLocation()
//        
//        
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TrackRunVC.updateTimerLabel), userInfo: nil, repeats: true)
//        startStopLabel.setTitle("Pause", for: .normal)
//        finishLabel.isHidden = true
//    } else if startStopLabel.currentTitle == "Pause" {
//        timer.invalidate()
//        startStopLabel.setTitle("Start", for: .normal)
//        finishLabel.isHidden = false
//    }
//}


