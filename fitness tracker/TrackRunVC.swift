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

// TO DO: add checks that location is enabled and accurate location found!. dont let start until location is found
// change filter, enable location services always
// reset data values
// segue to finish screen
// disenable start button once run starts until stop is pressed
// pace
// location update failed method -> clima comparison
// allow user to pause

class TrackRunVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
        
    // MARK: Properties
    var store = DataStore.sharedInstance
    var date = Date() // need time actually started run?
    
    // Timer
    var timer = Timer()
    let stopwatch = Stopwatch()
    
    // Mileage
    let locationManager = CLLocationManager()
    var coordinates: [CLLocation] = []
    var distance1 = Measurement(value: 0, unit: UnitLength.meters)
    var distance2 : Double = 0
    var run : Run?
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
            saveRun()
            storeCoordinates = false
            resetTimer()
            performSegue(withIdentifier: "showRunSummary", sender: self)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        timerLabel.text = "0:00"
        setUpLocationManager()
    }
        
    // MARK: Location Services
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
        // generates authorization popup
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        // location updates may be pasued if the user does not move a significant distance over a period of time
        locationManager.activityType = .fitness
            
        // get location updates every 10 meters traveled
        // locationManager.distanceFilter = 8
            
        // looks for GPS coordinates of iphone. This method is asynchronous!
        locationManager.startUpdatingLocation()
    }
        
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        print("In location manager method")
        print(location.horizontalAccuracy)
        // check to see if location is valid
        if location.horizontalAccuracy > 0 { //&& location.horizontalAccuracy < 100 { //20
            print("location valid")
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            if storeCoordinates {
                coordinates.append(location)
                updateDistance()
                map.add(createPolyLine())
                if coordinates.count == 1 {
                    addPin()
                }
            }
                
            //  Zoom in map to user location
            let span : MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let userLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let region : MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
            map.setRegion(region, animated: true)
            self.map.showsUserLocation = true
        }
    
    }
    
    // MARK: Map
    func addPin() {
            // Create coordinate
        let pin = MKPointAnnotation()
        pin.title = "Start"
        
        pin.coordinate = CLLocationCoordinate2DMake(coordinates[coordinates.count - 1].coordinate.latitude, coordinates[coordinates.count - 1].coordinate.longitude)
        self.map.addAnnotation(pin)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let polyLineRenderer = MKPolylineRenderer(overlay: polyline)
        polyLineRenderer.strokeColor = UIColor.gray
        polyLineRenderer.lineWidth = 5
        return polyLineRenderer
    }
    
    func createPolyLine() -> MKPolyline {
        if coordinates.count < 2 {
            return MKPolyline()
        }
        let mapCoordinates : [CLLocationCoordinate2D] = coordinates.map { coordinate in
            return CLLocationCoordinate2D(latitude: coordinate.coordinate.latitude, longitude: coordinate.coordinate.longitude)
        }
        return MKPolyline(coordinates: mapCoordinates, count: mapCoordinates.count)
    }
    
    
   // MARK: Distance
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
    
    // MARK: Save run data
    func saveRun() {
        var locations : [[String:Double]] = []
        for coordinate in coordinates {
            locations.append(["lat": coordinate.coordinate.latitude, "long": coordinate.coordinate.longitude])
        }
        
        if let newRun = Run(date: date, mileage: distance1.converted(to: .miles).value, duration: stopwatch.time, locations: locations) {
            store.addRun(item: newRun)
            run = newRun
        } else {
            // Add alert
            print("Unable to store run at this time")
        }
    }
    
    // MARK: Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRunSummary" {
            let destinationVC = segue.destination as! RunSummaryVC
            if let newRun = run {
                destinationVC.run = newRun
            }
        }
    }
}



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


