//
//  RunSummaryVC.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/16/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit
import MapKit

// TODO: Remove extra line at bottom 

class RunSummaryVC: UIViewController, MKMapViewDelegate { 
    var run = Run(date: Date(), mileage: 0.0, duration: 0, locations: [], splitTimes: [])
//    var run = Run?()
    
    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var summaryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        summaryTableView.delegate = self
//        summaryTableView.dataSource = self
//        summaryTableView.register(UINib(nibName: "WorkoutInfoCell", bundle: nil), forCellReuseIdentifier: "WorkoutInfoCell")
//        configureTableView()
        
        mapView.delegate = self
        loadMapData()
//        addPins()
        
//        let imageView = UIImageView(frame: self.view.frame)
//        let image = UIImage(named: "run1")!
//        imageView.image = image
//        imageView.contentMode = .scaleAspectFill
//        
//        self.view.addSubview(imageView)
//        self.view.sendSubview(toBack: imageView)
//
//        let backgroundImage = UIImage(named: "run6.jpg")
//        let imageView = UIImageView(image: backgroundImage)
//        imageView.contentMode = .scaleAspectFill
//        summaryTableView.backgroundView = imageView
//        summaryTableView.tableFooterView = UIView()
        

    }
    
    
//    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
//        cell.backgroundColor = .clear
//    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
//    }
//
//    override func viewWillDisappear(_ animated: true) {
//        run = Run(date: Date(), mileage: 0.0, duration: 0, locations: [], splitTimes: [])
//    }
    
    
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
    
//    func determineCellValues() -> [String] {
//        if let newRun = run {
//            let date = DateFormatter.localizedString(from: newRun.date, dateStyle: .medium, timeStyle: .short)
//            let mileage = String(format: "%.2f", newRun.mileage) + " mi"
//            let pace = Run.paceToString(pace: newRun.avgPace())
//            let duration = Stopwatch(time: newRun.duration).convertTimeToString()
//            return [date, mileage, duration, pace]
//        } else {
//            return ["","","",""]
//        }
//    }

//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutInfoCell", for: indexPath) as! WorkoutInfoCell
//        let descriptionLabels = ["Date", "Mileage", "Duration", "Pace"]
//        let valueLabels = determineCellValues()
//        
//        cell.descriptionLabel.text = descriptionLabels[indexPath.row]
//        cell.valueLabel.text = valueLabels[indexPath.row]
////        cell.backgroundColor = .clear
//        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
//        
//        return cell
//
//    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
    
//    func configureTableView() {
//        summaryTableView.rowHeight = 70
//        summaryTableView.tableFooterView = UIView()
////        UITableViewAutomaticDimension
////        summaryTableView.estimatedRowHeight = 70 // pixels
//    }
}

//func updateDisplay() {
//    if let newRun = run {
//        dateLabel.text = DateFormatter.localizedString(from: newRun.date, dateStyle: .medium, timeStyle: .short) // also .none style if only want to display date or time
//        mileageLabel.text = String(format: "%.2f", newRun.mileage) + " mi"
//        paceLabel.text = Run.paceToString(pace: newRun.avgPace())
//        
//        let stopwatch = Stopwatch(time: newRun.duration)
//        durationLabel.text = stopwatch.convertTimeToString()
//        
//        let splits = newRun.splitsToString()
//        splitsLabel.text = "\(splits)"
//        
//    }
//}



