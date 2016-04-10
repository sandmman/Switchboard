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

protocol UserUpdateDelegate{
    func userUpdated()
}

class User: NSObject, NSCoding {
    var firstName: String
    var lastName: String
    var email: String
    var handle: String
    var profilePicture:UIImage?

    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("user")
    
    struct PropertyKey {
        static let firstNameKey = "firstName"
        static let lastNameKey  = "lastName"
        static let emailKey     = "email"
        static let handleKey    = "handle"
        static let photoKey     = "photo"
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(firstName, forKey: PropertyKey.firstNameKey)
        aCoder.encodeObject(lastName, forKey: PropertyKey.lastNameKey)
        aCoder.encodeObject(email, forKey: PropertyKey.emailKey)
        aCoder.encodeObject(handle, forKey: PropertyKey.handleKey)
        aCoder.encodeObject(profilePicture, forKey: PropertyKey.photoKey)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let firstName = aDecoder.decodeObjectForKey(PropertyKey.firstNameKey) as! String
        let lastName = aDecoder.decodeObjectForKey(PropertyKey.lastNameKey) as! String
        let email = aDecoder.decodeObjectForKey(PropertyKey.emailKey) as! String
        let handle = aDecoder.decodeObjectForKey(PropertyKey.handleKey) as! String
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        
        self.init(firstName: firstName, lastName: lastName, email: email, handle: handle, profilePicture: photo)
    }
    
    init(firstName: String, lastName: String, email: String, handle: String, profilePicture: UIImage?) {
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
