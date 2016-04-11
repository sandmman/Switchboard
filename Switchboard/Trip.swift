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
    var excursions: [Excursion]
    var userPhoto: UIImage?
    var snapshot: FDataSnapshot?
    var timestamp: NSDate?

    init(name: String, title: String, descrip: String, userPhoto: UIImage?, timestamp: NSDate?) {
        self.name = name
        self.title = title
        self.excursions = [Excursion]()
        self.descrip = descrip
        self.userPhoto = userPhoto
        self.timestamp = timestamp
    }
    
    //we need an initializer for turning a dictionary from firebase into an object
    init(dictionary: Dictionary<String, AnyObject>, snapshot: FDataSnapshot){
        self.name = dictionary["name"] as? String
        self.title = dictionary["title"] as! String
        self.descrip = dictionary["descrip"] as! String
        let photo = dictionary["photo"] as? String
        self.excursions = [Excursion]()
        let timeInterval = dictionary["timestamp"] as? Double
        if (timeInterval != nil){
            self.timestamp = NSDate(timeIntervalSince1970:-1 * timeInterval!)
        }
        if (photo != nil){
            let decodedData = NSData(base64EncodedString: photo!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)

            self.userPhoto = UIImage(data: decodedData!)
        }
        self.snapshot = snapshot
    }
    
    func toDictionary() -> Dictionary<String, AnyObject> {

        let imageData: NSData = UIImageJPEGRepresentation(userPhoto!, 1.0)!
        let base64String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)

        return [
            "name": name!,
            "title": title,
            "descrip":descrip,
            "userPhoto": base64String,
            "timestamp": -1 * timestamp!.timeIntervalSince1970,
        ]
    }
    func timestampToReadableShortened() -> String{
        if let date = self.timestamp {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([NSCalendarUnit.Month , NSCalendarUnit.Year], fromDate: date)
            let year = String(components.year)
            let index1 = year.endIndex.advancedBy(-2)
            let year1 = year.substringFromIndex(index1)
            return "\(components.month)-\(year1)"
        }
        return ""
    }

}
