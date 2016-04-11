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
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var start:UIButton!
    @IBOutlet weak var stop:UIButton!
    @IBOutlet weak var loc:UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    lazy var locations = [CLLocation]()
    var locationManager: CLLocationManager!
    var previousLocation : CLLocation!
   
    var trip: Trip?
    
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
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
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
    
    func startLocationUpdates() {
        // Here, the location manager will be lazily instantiated
        locationManager.startUpdatingLocation()
    }
    @IBAction func startPressed(sender: AnyObject) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        previousLocation = nil
        
        locations.removeAll(keepCapacity: false)
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        //mapview setup to show user location
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        createNewExcursion()
    }
    
    func formatAddressFromPlacemark(placemark: CLPlacemark) -> String? {
        return (placemark.addressDictionary!["City"]!) as? String
    }
    // MARK :- CLLocationManager delegate
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        
        if newLocation.horizontalAccuracy < 20 {
            self.locations.append(newLocation)
        }
        
        CLGeocoder().reverseGeocodeLocation(newLocation,
            completionHandler: {(placemarks:[CLPlacemark]?, error:NSError?) -> Void in
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                    if let text = self.formatAddressFromPlacemark(placemark) {
                        self.loc.text = text
                    } else{
                        self.loc.text = "Location"
                    }
                }
        })
        
        //drawing path or route covered
        if let oldLocationNew = oldLocation as CLLocation?{
            let oldCoordinates = oldLocationNew.coordinate
            let newCoordinates = newLocation.coordinate
            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            mapView.addOverlay(polyline)
        }
        
        
        //calculation for location selection for pointing annotation
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
    func createNewExcursion() {
        
        if locations.count >= 2 {
            
            let newExcursion = Excursion(notes: "", timestamp: NSDate(), locations: locations)
        
            TripCenter.sharedInstance.postExcursion(newExcursion, trip: trip!)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 
    // MARK :- MKMapView delegate
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor(red: 0.2039, green: 0.5961, blue: 0.8588, alpha: 1.0)
            pr.lineWidth = 3
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
    
    func loadUser() -> User? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(User.ArchiveURL.path!) as? User
    }
}
