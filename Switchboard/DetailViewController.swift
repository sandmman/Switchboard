//
//  DetailViewController.swift
//  Switchboard
//
//  Created by Aaron Liberatore on 4/7/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
import Photos

class DetailViewController: UIViewController, MKMapViewDelegate, ExcursionFeedDelegate, PlacesTableViewCellDelegate {
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var images:NSMutableArray!
    var totalImageCountNeeded:Int!
    var color: UIColor?
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TripCenter.sharedInstance.excursionFeedDelegate = self
        TripCenter.sharedInstance.subscribeToExcursionsForTrip(trip!)
        
        //mapview setup to show user location
        mapView.delegate = self
        mapView.showsUserLocation = false
        mapView.mapType = MKMapType(rawValue: 0)!
        //mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        showTripInfo()
        fetchPhotos ()
        showMap()
    }
    
    func showTripInfo() {

        author.text = trip?.name
        location.text = trip?.title
        notes.text = trip?.descrip

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func excursionAddedToFeed() {
        //the TripCenter told us that there are new excursions
        self.showMap()
        self.showTripInfo()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MapViewSegue" {
            if let detailVC = segue.destinationViewController as? MapViewController{
                    detailVC.trip = trip
            }
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = color
            pr.lineWidth = 3
            return pr
        }
        
        return nil
    }
    
    func setRandomColor(){
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        color = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    func setDates() {
        if trip != nil && trip?.excursions.count > 0{
            
            let startDate = (trip?.excursions)!.first
            let endDate = (trip?.excursions)!.last
            date.text = startDate!.timestampToReadable() + " - " + endDate!.timestampToReadable()
        }
    }
    func showMap(){
    //drawing path or route covered
        
        setDates()
        
        for excur in (trip?.excursions)! {
            
            setRandomColor()
            
            let locs = excur.locations
            if let _ = locs {
                for i in 0...locs!.count-2 {
                    let oldLocation = locs![i]
                    let newLocation = locs![i+1]
                    if let oldLocationNew = oldLocation as CLLocation?{
                        let oldCoordinates = oldLocationNew.coordinate
                        let newCoordinates = newLocation.coordinate
                        var area = [oldCoordinates, newCoordinates]
                        let polyline = MKPolyline(coordinates: &area, count: area.count)
                        mapView.addOverlay(polyline)
                    }
                    
                    
                   /* //calculation for location selection for pointing annotation
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
                    }*/
                }
                let region = MKCoordinateRegionMakeWithDistance(
                    locs![0].coordinate, 2000, 2000)
                
                mapView.setRegion(region, animated: true)
            }
        }
        
    }
    func fetchPhotos () {
        images = NSMutableArray()
        totalImageCountNeeded = 10
        self.fetchPhotoAtIndexFromEnd(0)
    }
    
    // Repeatedly call the following method while incrementing
    // the index until all the photos are fetched
    func fetchPhotoAtIndexFromEnd(index:Int) {
        
        let imgManager = PHImageManager.defaultManager()
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        
        // Sort the images by creation date
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions) {
            
            // If the fetch result isn't empty,
            // proceed with the image request
            if fetchResult.count > 0 {
                // Perform the image request
                //print("start")
                //print(fetchResult)
                imgManager.requestImageForAsset(fetchResult.objectAtIndex(fetchResult.count - 1 - index) as! PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: { (image, _) in
                    
                    // Add the returned image to your array
                    self.images.addObject(image!)
                    
                    // If you haven't already reached the first
                    // index of the fetch result and if you haven't
                    // already stored all of the images you need,
                    // perform the fetch request again with an
                    // incremented index
                    if index + 1 < fetchResult.count && self.images.count < self.totalImageCountNeeded {
                        self.fetchPhotoAtIndexFromEnd(index + 1)
                    }
                })
            }
        }
    }
   
}
