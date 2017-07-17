//
//  RunSummaryVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/16/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit
import MapKit

class RunSummaryVC: UIViewController {
    var run: Run!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

        // Do any additional setup after loading the view.
    }
    
    private func configureView() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


}
