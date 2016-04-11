//
//  Excursion.swift
//  Switchboard
//
//  Created by Aaron Liberatore on 4/10/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import MapKit

class Excursion: NSObject {
    var notes: String
    var timestamp: NSDate?
    var locations: [CLLocation]?
    var snapshot: FDataSnapshot?
    
    init(notes: String, timestamp: NSDate?, locations: [CLLocation]?) {
        self.notes = notes
        self.timestamp = timestamp
        self.locations = locations
    }
    
    //we need an initializer for turning a dictionary from firebase into an object
    init(dictionary: Dictionary<String, AnyObject>, snapshot: FDataSnapshot){
        self.notes = dictionary["notes"] as! String
        let timeInterval = dictionary["timestamp"] as? Double
        let locations = dictionary["locations"] as? [AnyObject]
        
        if (timeInterval != nil){
            self.timestamp = NSDate(timeIntervalSince1970:-1 * timeInterval!)
        }
        if (locations != nil){
            var locTmp: [CLLocation] = []
            for coor in locations!{
                let lat = (coor[0]).doubleValue
                let long = (coor[1]).doubleValue
                let loc = CLLocation(latitude: lat as CLLocationDegrees, longitude: long as CLLocationDegrees)
                locTmp.append(loc)
                
            }
            self.locations = locTmp
        }
        self.snapshot = snapshot
    }
    
    func toDictionary() -> Dictionary<String, AnyObject> {
        var locs: [AnyObject] = []
        for loc in locations!{
            let coor  = loc.coordinate
            let coors = [NSNumber(double: coor.latitude), NSNumber(double: coor.longitude)]
            locs.append(coors)
        }
        return [
            "notes":notes,
            "timestamp": -1 * timestamp!.timeIntervalSince1970,
            "locations": locs,
        ]
    }
    
    //MARK: NSDate to month-day-year representation
    func timestampToReadable() -> String{
        
        if let date = self.timestamp {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([NSCalendarUnit.Month , NSCalendarUnit.Day , NSCalendarUnit.Year], fromDate: date)
            let year = String(components.year)
            let index1 = year.endIndex.advancedBy(-2)
            let year1 = year.substringFromIndex(index1)
            return "\(components.month)-\(components.day)-\(year1)"
        }
        return ""
    }
    }


