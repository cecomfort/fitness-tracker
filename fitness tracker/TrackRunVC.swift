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
// location update failed method -> clima comparison

// Future work: Allow user to pause and not track displacement of run distance

class TrackRunVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
        
    // MARK: Properties
    var store = DataStore.sharedInstance
    var date : Date? // only need a date if run is started
    var reset = false
    
    // Timer
    var timer = Timer()
    let stopwatch = Stopwatch()
    
    // Mileage
    let locationManager = CLLocationManager()
    var coordinates: [CLLocation] = []
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var run : Run?
    var storeCoordinates = false
    var distanceInMiles = Measurement(value: 0, unit: UnitLength.miles)
    var splitTimes = [Int]()
    
    // Map
    var polylines : [MKPolyline] = []
    
    // Outlets
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var displayBackground: UIView!
    @IBOutlet weak var finishButton: UIBarButtonItem!
        

    func clearRunData() {
        stopwatch.reset()
        coordinates = []
        distance = Measurement(value: 0, unit: UnitLength.meters)
        distanceInMiles = Measurement(value: 0, unit: UnitLength.miles)
        splitTimes = []
        
        updateDistance()
        updatePace()
        
        for polyline in polylines {
            map.remove(polyline)
        }
        polylines = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if reset {
            clearRunData()
            finishButton.isEnabled = false
            locationManager.startUpdatingLocation()
            reset = false
        }
    }
    
    @IBAction func startStopRun(_ sender: UIButton) {
        let buttonTitle = sender.title(for: .normal)!
        print(buttonTitle)
        if buttonTitle == "start" {
            sender.setTitle("stop", for: .normal)
            sender.setImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
            
            finishButton.isEnabled = false
            
            storeCoordinates = true
            startTimer()
            
            if coordinates.count == 0 {
                date = Date()
            }
            
        } else if buttonTitle == "stop" {
            sender.setTitle("start", for: .normal)
            sender.setImage(#imageLiteral(resourceName: "startButton"), for: .normal)
            
            if coordinates.count > 0 {
                finishButton.isEnabled = true
            }
                
            storeCoordinates = false
            stopTimer()
        }

    }
    
    @IBAction func saveRun(_ sender: UIBarButtonItem) {
        print("Saving!")
        locationManager.stopUpdatingLocation()
        saveRunData()
        resetTimer()
        reset = true
        performSegue(withIdentifier: "showRunSummary", sender: self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        tabBarController?.tabBar.barTintColor = UIColor.white
        
        
        
        displayBackground.backgroundColor = UIColor(white: 1, alpha: 0.8)
        
        map.delegate = self
        timerLabel.text = "0:00"
        setUpLocationManager()
        finishButton.isEnabled = false
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
        
        locationManager.allowsBackgroundLocationUpdates = true
        // default value true
        locationManager.pausesLocationUpdatesAutomatically = false
            
        // get location updates every 10 meters traveled
//        locationManager.distanceFilter = 10
        
        // looks for GPS coordinates of iphone. This method is asynchronous!
        locationManager.startUpdatingLocation()
    }
        
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
//        print("In location manager method")
//        print(location.horizontalAccuracy)
        // check to see if location is valid
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        //  Zoom in map to user location
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let userLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region : MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
        
        
        if location.horizontalAccuracy > 0 && location.horizontalAccuracy < 50 { //20
//            print("location valid")
//            let latitude = location.coordinate.latitude
//            let longitude = location.coordinate.longitude
            
            if storeCoordinates {
                coordinates.append(location)
                updateDistance()
                updatePace()
                updateSplits()
                map.add(createPolyLine())
//                if coordinates.count == 1 {
//                    addPin()
//                }
            }
                
//            //  Zoom in map to user location
//            let span : MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
//            let userLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
//            let region : MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
//            map.setRegion(region, animated: true)
//            self.map.showsUserLocation = true
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
//        UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        polyLineRenderer.strokeColor = UIColor(red: 231/255, green: 127/255, blue: 123/255, alpha: 0.6)
        polyLineRenderer.lineWidth = 4
        return polyLineRenderer
    }
    
    func createPolyLine() -> MKPolyline {
        if coordinates.count < 2 {
            return MKPolyline()
        }
        let mapCoordinates : [CLLocationCoordinate2D] = coordinates.map { coordinate in
            return CLLocationCoordinate2D(latitude: coordinate.coordinate.latitude, longitude: coordinate.coordinate.longitude)
        }
        let polyline = MKPolyline(coordinates: mapCoordinates, count: mapCoordinates.count)
        polylines.append(polyline)
        return polyline
    }
    
    
   // MARK: Update Run Stats
    func updateDistance() {
        if coordinates.count > 1 {
            let lastLocation = coordinates[coordinates.count - 2]
            let newLocation = coordinates[coordinates.count - 1]
            let delta : CLLocationDistance = newLocation.distance(from: lastLocation)
            distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            distanceInMiles = distance.converted(to: UnitLength.miles)
            distanceLabel.text = String(format: "%.2f", distanceInMiles.value)
        } else {
            distanceLabel.text = "0.00"
        }
    }
    
    func updatePace() {
        if distance.value >= 0.1 {
            let pace = Run.pace(mileage: distanceInMiles.value, duration: stopwatch.time)
            paceLabel.text = Run.paceToString(pace: pace)
        } else {
            paceLabel.text = "0'00\""
        }
    }
    
    // splits: if Int(mileage) > splits.count { splits.append(currentTime) } // split for every mile
    func updateSplits() {
        if Int(distanceInMiles.value) > splitTimes.count {
            splitTimes.append(stopwatch.time)
        }
    }
    
    
    
    // MARK: Timer
    func startTimer() {
        stopwatch.start()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TrackRunVC.updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        stopwatch.stop()
        timer.invalidate()
    }
    
    func resetTimer() {
        stopwatch.reset()
        timerLabel.text = stopwatch.convertTimeToString()
//        finishLabel.isHidden = true
    }
    
    func updateTimerLabel() {
        stopwatch.updateTime()
        timerLabel.text = stopwatch.convertTimeToString()
    }
    
    // MARK: Save and reset run data
    func saveRunData() {
        var locations : [[String:Double]] = []
        for coordinate in coordinates {
            locations.append(["lat": coordinate.coordinate.latitude, "long": coordinate.coordinate.longitude])
        }
        
        if let newRun = Run(date: date!, mileage: distance.converted(to: .miles).value, duration: stopwatch.time, locations: locations, splitTimes: splitTimes) {
            store.addRun(item: newRun)
            run = newRun
        } else {
            // Add alert
            print("Unable to store run at this time")
        }
    }
    

    
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRunSummary" {
            let destinationVC = segue.destination as! RunPageVC
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

