//
//  MapViewController.swift
//  Switchboard
//
//  Created by Aaron Liberatore on 4/7/16.
//  Copyright © 2016 Aaron. All rights reserved.
//
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var start:UIButton!
    @IBOutlet weak var loc:UILabel!
    @IBOutlet weak var mapView: MKMapView!
    

    var locationManager: CLLocationManager!
    var previousLocation : CLLocation!
    var mapUIView: MapView!
   
    @IBAction func toggle(sender: AnyObject) {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
        //print("Trying")
    }

    func toggle1() {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        
        // user activated automatic authorization info mode
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        
        //mapview setup to show user location
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        mapView.mapType = MKMapType(rawValue: 0)!
    }
    
    
    override func viewWillAppear(animated: Bool) {
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }
    
    // MARK :- CLLocationManager delegate
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        //println("present location : \(newLocation.coordinate.latitude),\(newLocation.coordinate.longitude)")
        
        //drawing path or route covered
        if let oldLocationNew = oldLocation as CLLocation?{
            let oldCoordinates = oldLocationNew.coordinate
            let newCoordinates = newLocation.coordinate
            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            mapView.addOverlay(polyline)
        }
        
        
        //calculation for location selection for pointing annoation
        if let _ = previousLocation as CLLocation?{
            //case if previous location exists
            if previousLocation.distanceFromLocation(newLocation) > 200 {
                addAnnotationsOnMap(newLocation)
                previousLocation = newLocation
            }
        }else{
            //case if previous location doesn't exists
            addAnnotationsOnMap(newLocation)
            previousLocation = newLocation
        }
    }
    
    // MARK :- MKMapView delegate
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.redColor()
            pr.lineWidth = 5
            return pr
        }
        
        return nil
    }
    
    //function to add annotation to map view
    func addAnnotationsOnMap(locationToPoint : CLLocation){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationToPoint.coordinate
        let geoCoder = CLGeocoder ()
        geoCoder.reverseGeocodeLocation(locationToPoint, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks! as? [CLPlacemark] where placemarks.count > 0 {
                let placemark = placemarks[0]
                var addressDictionary = placemark.addressDictionary;
                annotation.title = addressDictionary!["Name"] as? String
                self.mapView.addAnnotation(annotation)
            }
        })
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = touches.first {
            toggle1()
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = touches.first{
             toggle1()
        }
        super.touchesEnded(touches, withEvent: event)
    }
    
}
