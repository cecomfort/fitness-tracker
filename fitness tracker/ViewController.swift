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

    var coordinates: [CLLocationCoordinate2D] = []
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var currentLatitude: UILabel!
    @IBOutlet weak var currentLogitude: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // generates authorization popup
        locationManager.requestWhenInUseAuthorization()
        
        // location updates may be pasued if the user does not move a significant distance over a period of time
        locationManager.activityType = .fitness
        // looks for GPS coordinates of iphone. This method is asynchronous!
        locationManager.startUpdatingLocation()
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
            
            // Change coordinates on screen
            currentLatitude.text = "Latitdue = " + String(format: "%.4f", latitude)
            currentLogitude.text = "Longitude = " + String(format: "%.4f", longitude)
            
            // Zooming map to user location
            let span : MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let userLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let region : MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
            map.setRegion(region, animated: true)
            
            // Create coordinate
            let startAnnotation = MKPointAnnotation()
            startAnnotation.title = "Start"
            startAnnotation.coordinate = userLocation
            self.map.addAnnotation(startAnnotation)
            //        self.map.userTrackingMode
//            self.map.showsUserLocation = true
        }
        
    }



}

