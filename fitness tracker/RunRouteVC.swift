//
//  RunSummaryVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/16/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit
import MapKit

class RunRouteVC: UIViewController, MKMapViewDelegate {
    var run = Run(date: Date(), mileage: 0.0, duration: 0, locations: [], splitTimes: [])
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        loadMapData()
    }
    
    // MARK: - Map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        let polyLineRenderer = MKPolylineRenderer(overlay: polyline)
        polyLineRenderer.strokeColor = UIColor(red: 231/255, green: 127/255, blue: 123/255, alpha: 0.6)
        polyLineRenderer.lineWidth = 4
        return polyLineRenderer
    }
    
    func createPolyLine() -> MKPolyline {
        if let locations = run?.locations, locations.count > 0 {
            let mapCoordinates : [CLLocationCoordinate2D] = locations.map { location in
                return CLLocationCoordinate2D(latitude: location["lat"]!, longitude: location["long"]!)
            }
            return MKPolyline(coordinates: mapCoordinates, count: mapCoordinates.count)
        } else {
            return MKPolyline()
        }
    }
    
    private func loadMapData() {
        if let minMaxOfCoordinates = run?.calculateMaxMinOfCoordinates() {
            let maxLat = minMaxOfCoordinates["maxLat"]
            let minLat = minMaxOfCoordinates["minLat"]
            let maxLong = minMaxOfCoordinates["maxLong"]
            let minLong = minMaxOfCoordinates["minLong"]
            let center = CLLocationCoordinate2D(latitude: (minLat! + maxLat!) / 2, longitude: (minLong! + maxLong!) / 2)
            let span = MKCoordinateSpan(latitudeDelta: (maxLat! - minLat!) * 2.5, longitudeDelta: (maxLong! - minLong!) * 2.5)
            let region = MKCoordinateRegion(center: center, span: span)

            mapView.setRegion(region, animated: true)
            mapView.add(createPolyLine())
            
            
        } else {
            print("no coordinates found") // alert?
        }

    }
    
    func addPins() {
        let startPin = MKPointAnnotation()
        startPin.title = "Start"
        startPin.coordinate = CLLocationCoordinate2DMake((run?.locations.first?["lat"])!, (run?.locations.first?["long"])!)
        
        // no finish pin?
        let finishPin = MKPointAnnotation()
        finishPin.title = "Finish"
        finishPin.coordinate = CLLocationCoordinate2DMake((run?.locations.last?["lat"])!, (run?.locations.last?["long"])!)
        
        mapView.addAnnotations([startPin])
    }
}



