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

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

//    var coordinates: [CLLocationCoordinate2D] = []
    var coordinates: [CLLocation] = []
    
    var distance : Double = 0
    
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var distanceInMilesLabel: UILabel!
    
    @IBAction func addLocation(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TO DO: add checks that location is enabled and accurate location found!
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // generates authorization popup
        locationManager.requestWhenInUseAuthorization()
        
        // location updates may be pasued if the user does not move a significant distance over a period of time
        locationManager.activityType = .fitness
        
        // looks for GPS coordinates of iphone. This method is asynchronous!
//        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        // check to see if location is valid
        if location.horizontalAccuracy > 0 {
            // stop requesting user location
            locationManager.stopUpdatingLocation()
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            coordinates.append(location)
            
            // Zooming map to user location
            let span : MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let userLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let region : MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
            map.setRegion(region, animated: true)
            
            
//            coordinates.append(userLocation)
            
            // Create coordinate
//            let startAnnotation = MKPointAnnotation()
//            startAnnotation.title = "Start"
//            startAnnotation.coordinate = userLocation
//            self.map.addAnnotation(startAnnotation)
            //        self.map.userTrackingMode
            self.map.showsUserLocation = true
            
            addPin()
            updateDistance()
            addLineToMap()
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
        let pinNumber = coordinates.count
    
        if pinNumber > 1 {
            let lastLocation = coordinates[pinNumber - 2]
            let newLocation = coordinates[pinNumber - 1]
            
            let distanceBetweenLastTwoPins: CLLocationDistance = newLocation.distance(from: lastLocation)
            
            distance += distanceBetweenLastTwoPins
            distanceLabel.text = "Distance(m): " + String(format: "%.1f", distanceBetweenLastTwoPins)
        }
        
        let distanceInMiles = distance * 0.000621371192
        
        distanceInMilesLabel.text = "Distance(mi): " + String(format: "%.2f", distanceInMiles)
    }
    
}
