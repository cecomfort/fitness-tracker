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
    var run = Run(date: Date(), mileage: 0.0, duration: 0, locations: [])
    
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
//        loadMapData()
        // Do any additional setup after loading the view.
    }
    

    
    func updateDisplay() {
        if let newRun = run {
            dateLabel.text = DateFormatter.localizedString(from: newRun.date, dateStyle: .medium, timeStyle: .short) // also .none style if only want to display date or time
            mileageLabel.text = String(format: "%.2f", newRun.mileage) + " mi"
            durationLabel.text = String(newRun.duration) // needs formatting!!
            paceLabel.text = Run.paceToString(pace: newRun.pace())
            
            let stopwatch = Stopwatch(time: newRun.duration)
            durationLabel.text = stopwatch.convertTimeToString()
            
        }
    }
    
       }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func addLineToMap() {
//        var mapCoordinates: [CLLocationCoordinate2D] = []
//        
//        for mapCoordinate in coordinates {
//            mapCoordinates.append(CLLocationCoordinate2DMake(mapCoordinate.coordinate.latitude, mapCoordinate.coordinate.longitude))
//        }
//        
//        // create polyLine
//        let polyLine = MKPolyline(coordinates: &mapCoordinates, count: mapCoordinates.count)
//        
//        // add polyLine to map
//        self.map.add(polyLine, level: MKOverlayLevel.aboveRoads)
//        
//        func map(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
//            
//            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
//            polyLineRenderer.strokeColor = UIColor.blue
//            //            UIColor(rgba: overlay.color);
//            polyLineRenderer.lineWidth = 2.0
//            return polyLineRenderer
//            
//        }
//        
//    }
    
    //    func map(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
    //        if overlay.isKindOfClass(MKPolyline) {
    //            // draw the track
    //            let polyLine = overlay
    //            let polyLineRenderer = MKPolylineRenderer(overlay: polyLine)
    //            polyLineRenderer.strokeColor = UIColor.blueColor()
    //            polyLineRenderer.lineWidth = 2.0
    //
    //            return polyLineRenderer
    //        }
    //        
    //        return nil
    //    }


//}
