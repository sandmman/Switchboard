import UIKit
import MapKit
import CoreLocation
import CoreData
import Photos

class DetailViewController: UIViewController, MKMapViewDelegate, ExcursionFeedDelegate, TripTableViewCellDelegate {
    @IBOutlet weak var location : UILabel!
    @IBOutlet weak var author   : UILabel!
    @IBOutlet weak var date     : UILabel!
    @IBOutlet weak var notes    : UILabel!
    @IBOutlet weak var distance : UILabel!
    @IBOutlet weak var mapView  : MKMapView!
    
    var images:NSMutableArray!
    var totalImageCountNeeded:Int!
    var color: UIColor?
    var trip: Trip?
    
    var local            : CLLocationCoordinate2D?
    var dist             : Double = 0.0
    var averageLatititude: Double = 0.0
    var averageLongitutde: Double = 0.0
    var numOfLocations   : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TripCenter.sharedInstance.excursionFeedDelegate = self
        TripCenter.sharedInstance.subscribeToExcursionsForTrip(trip!)
        
        //mapview setup to show user location
        mapView.delegate = self
        mapView.showsUserLocation = false
        mapView.mapType = MKMapType(rawValue: 0)!
        //mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        fetchPhotos ()
    }
    
    func showTripInfo() {
        
        author.text     = trip?.name
        location.text   = trip?.title
        notes.text      = trip?.descrip
        distance.text   = String(dist)
        
        let region = MKCoordinateRegionMakeWithDistance(//local!,
            CLLocationCoordinate2D(latitude: averageLatititude / numOfLocations,
                                   longitude: averageLongitutde / numOfLocations),
                                   4000, 4000)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func excursionAddedToFeed() {
        //the TripCenter told us that there are new excursions
        self.drawExcursions()
        self.showTripInfo()
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = color
            pr.lineWidth   = 3
            return pr
        }
        
        return nil
    }
    
    func setRandomColor(){
        let randomRed   :CGFloat = CGFloat(drand48())
        let randomGreen :CGFloat = CGFloat(drand48())
        let randomBlue  :CGFloat = CGFloat(drand48())
        color = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    func setDates() {
        if trip != nil && trip?.excursions.count > 0{
            
            let startDate = (trip?.excursions)!.first
            let endDate   = (trip?.excursions)!.last
            date.text     = startDate!.timestampToReadable() + " - " + endDate!.timestampToReadable()
        }
    }
    
    func drawExcursions(){
        //drawing path or route covered
        
        setDates()
        
        for excur in (trip?.excursions)! {
            if let _ = excur.distance { dist += round(100*excur.distance!/1609.32)/100 }
            setRandomColor()
            let locs = excur.locations
            
            if let _ = locs {
                
                local = locs![0].coordinate
                
                for i in 0...locs!.count-2 {
                    
                    let oldLocation = locs![i]
                    let newLocation = locs![i+1]
                    
                    averageLatititude += oldLocation.coordinate.latitude
                    averageLongitutde += oldLocation.coordinate.longitude
                    numOfLocations    += 1.0
                    
                    if let oldLocationNew = oldLocation as CLLocation?{
                        let oldCoordinates = oldLocationNew.coordinate
                        let newCoordinates = newLocation.coordinate
                        var area = [oldCoordinates, newCoordinates]
                        let polyline = MKPolyline(coordinates: &area, count: area.count)
                        mapView.addOverlay(polyline)
                    }

                    /*//calculation for location selection for pointing annotation
                    if let _ = oldLocation as CLLocation?{
                        //case if previous location exists
                        if oldLocation.distanceFromLocation(newLocation) > 200 {
                            addAnnotationsOnMap(newLocation)
                        }
                    }else{
                        //case if previous location doesn't exists
                        addAnnotationsOnMap(newLocation)
                    }*/
                }
            }
        }
    }
    
    func photoInRange(photo: PHAsset) -> Bool {
        if photo.location != nil {
            //print(20)
        }
        return false
    }
    
    func fetchPhotos () {
        images = NSMutableArray()
        totalImageCountNeeded = 10
        self.fetchImages()
    }
    
    func fetchImages() {
        
        let imgManager = PHImageManager.defaultManager()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        
        // Sort the images by creation date
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions) {
            //print((fetchResult[0] as! PHAsset))
            // Fetch a specicific number of photos
            for i in 0...fetchResult.count-1 {
                
                photoInRange((fetchResult[i] as! PHAsset))
                
                // Perform the image request
                imgManager.requestImageForAsset(
                    fetchResult.objectAtIndex(fetchResult.count - 1 - i) as! PHAsset,
                    targetSize   : view.frame.size,
                    contentMode  : PHImageContentMode.AspectFill,
                    options      : requestOptions,
                    resultHandler: { (image, _) in
                        
                    self.images.addObject(image!)
                })
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MapViewSegue" {
            if let detailVC = segue.destinationViewController as? MapViewController{
                detailVC.trip = trip
            }
        }
    }
    
}
