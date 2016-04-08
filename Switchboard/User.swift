//
//  User.swift
//  Switchboard
//
//  Created by Aaron Liberatore on 4/7/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import MapKit

class User: NSObject {
    var firstName: String
    var lastName: String
    var email: String
    var handle: String
    var profilePicture:UIImageView?
    
    init(firstName: String, lastName: String, email: String, handle: String, profilePicture: UIImageView?) {
        self.firstName  = firstName
        self.lastName   = lastName
        self.email      = email
        self.handle     = handle
        self.profilePicture = profilePicture
    }

    init(dictionary: Dictionary<String, AnyObject>, snapshot: FDataSnapshot){
        self.firstName  = dictionary["firstName"] as! String
        self.lastName   = dictionary["lastName"] as! String
        self.email      = dictionary["email"] as! String
        self.handle     = dictionary["handle"] as! String
        //let value = dictionary["location"] as! NSValue
        //self.location = value.MKCoordinateValue
    }

    func toDictionary() -> Dictionary<String, AnyObject> {
        return [
            "firstName" :firstName,
            "lastName"  :lastName,
            "email"     :email,
            "handle"    :handle
        ]
    }
    
}
