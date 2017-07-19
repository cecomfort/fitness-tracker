//
//  RunSummaryVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/16/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit
import MapKit

// splits: if Int(mileage) > splits.count { splits.append(currentTime) } // split for every mile

class RunSummaryVC: UIViewController, MKMapViewDelegate {
    var run = Run(date: Date(), mileage: 0.0, duration: 0, locations: [], splitTimes: [])
//    var run = Run?()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var splitsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplay()
        
        mapView.delegate = self
        loadMapData()
//        addPins()
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillDisappear(_ animated: true) {
//        run = Run(date: Date(), mileage: 0.0, duration: 0, locations: [], splitTimes: [])
//    }
    
    
    func updateDisplay() {
        if let newRun = run {
            dateLabel.text = DateFormatter.localizedString(from: newRun.date, dateStyle: .medium, timeStyle: .short) // also .none style if only want to display date or time
            mileageLabel.text = String(format: "%.2f", newRun.mileage) + " mi"
            durationLabel.text = String(newRun.duration) // needs formatting!!
            paceLabel.text = Run.paceToString(pace: newRun.avgPace())
            
            let stopwatch = Stopwatch(time: newRun.duration)
            durationLabel.text = stopwatch.convertTimeToString()
            
            let splits = newRun.splitsToString()
            splitsLabel.text = "\(splits)"
            
        }
    }
    
    // MARK: - Map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        let polyLineRenderer = MKPolylineRenderer(overlay: polyline)
        polyLineRenderer.strokeColor = UIColor.gray
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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}

