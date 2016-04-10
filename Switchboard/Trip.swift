//
//  Place.swift
//  Switchboard
//
//  Created by Aaron Liberatore on 4/7/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import MapKit

class Trip: NSObject {
    var name: String?
    var title: String
    var descrip: String
    var timestamp: NSDate?
    //var photos: [Reply]
    var locations: [CLLocation]?
    var snapshot: FDataSnapshot?

    init(name: String, title: String, descrip: String, timestamp: NSDate?, locations: [CLLocation]?) {
        self.name = name
        self.title = title
        self.descrip = descrip
        self.timestamp = timestamp
        self.locations = locations
    }
    
    //we need an initializer for turning a dictionary from firebase into an object
    init(dictionary: Dictionary<String, AnyObject>, snapshot: FDataSnapshot){
        self.name = dictionary["name"] as? String
        self.title = dictionary["title"] as! String
        self.descrip = dictionary["descrip"] as! String
        let timeInterval = dictionary["timestamp"] as? Double
        let locations = dictionary["timestamp"] as? [AnyObject]
        if (timeInterval != nil){
            self.timestamp = NSDate(timeIntervalSince1970:-1 * timeInterval!)
        }
        if (locations != nil){
            var locTmp: [CLLocation] = []
            for coor in locations!{
                let lat = (coor[0] as! NSString).doubleValue
                let long = (coor[1] as! NSString).doubleValue
                let loc = CLLocation(latitude: lat as CLLocationDegrees, longitude: long as CLLocationDegrees)
                locTmp.append(loc)
                
            }
            
            self.locations = locTmp
        }
        //self.locations = dictionary["locations"] as? String
    }
    
    func toDictionary() -> Dictionary<String, AnyObject> {
        var locs: [AnyObject] = []
        for loc in locations!{
            let coor  = loc.coordinate
            let coors = [NSNumber(double: coor.latitude), NSNumber(double: coor.longitude)]
            locs.append(coors)
        }
        
        return [
            "name": name!,
            "title": title,
            "descrip":descrip,
            "timestamp": -1 * timestamp!.timeIntervalSince1970,
            "locations": locs
        ]
    }
    
    //MARK: helper
    func timestampToReadable() -> String{
        if let date = self.timestamp {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Year, .WeekOfYear, .Day, .Hour, .Minute, .Second], fromDate: date, toDate: NSDate(), options: [])
            if components.year > 0 {
                return "\(components.year)y"
            } else if components.weekOfYear > 0 {
                return "\(components.weekOfYear)w"
            } else if components.day > 0 {
                return "\(components.day)d"
            } else if components.hour > 0 {
                return "\(components.hour)h"
            } else if components.minute > 0 {
                return "\(components.minute)m"
            } else if components.second > 0 {
                return "\(components.second)s"
            } else {
                return "Just now"
            }
        } else {
            return ""
        }
    }
}
