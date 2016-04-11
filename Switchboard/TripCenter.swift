//
//  EntryCenter.swift
//  Switchboard
//
//  Created by Aaron Liberatore on 4/7/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

import UIKit
import Firebase

protocol TripFeedDelegate{
    func tripAddedToFeed()
}

protocol ExcursionFeedDelegate{
    func excursionAddedToFeed()
}

class TripCenter: NSObject {
    static let sharedInstance = TripCenter()
    
    var tripFeedDelegate: TripFeedDelegate?
    var excursionFeedDelegate: ExcursionFeedDelegate?
    
    //this is our base reference to our firebase database
    static let baseURL = "https://switchboardd.firebaseio.com/"
    let baseRef = Firebase(url: "\(baseURL)")
    let tripRef = Firebase(url: "\(baseURL)/trips")
    let excuRef = Firebase(url: "\(baseURL)/excursions")
    
    var allTrips = [Trip]()
    
    var subscribedExcursionHandle: UInt?
    
    var voteDictionary: Dictionary<String, Bool>
    
    override init() {
        let voteRecord = NSUserDefaults.standardUserDefaults().objectForKey("voteRecord")
        if(voteRecord == nil){
            self.voteDictionary = Dictionary()
        } else{
            self.voteDictionary = voteRecord as! Dictionary<String, Bool>
        }
        super.init()
        //we setup listeners for when remote data changes, this is the primary way of reading data via firebase
        tripRef.queryOrderedByChild("timestamp").observeEventType(.Value, withBlock: { snapshot in
            self.allTrips.removeAll()
            //here we get all of the yaks (children), and make sure there is at least 1
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for tripSnapshot in snapshots{
                    self.allTrips.append(Trip(dictionary: tripSnapshot.value as! Dictionary<String, AnyObject>, snapshot: tripSnapshot))
                }
            }
            self.tripFeedDelegate?.tripAddedToFeed()
        })
    }
    
    func subscribeToExcursionsForTrip(trip: Trip){
        //cancel existing subscription if there is one
        if (subscribedExcursionHandle != nil){
            excuRef.removeObserverWithHandle(subscribedExcursionHandle!)
        }
        
        subscribedExcursionHandle = excuRef.childByAppendingPath(trip.snapshot!.key).observeEventType(.Value, withBlock: { snapshot in
            trip.excursions.removeAll()
            //here we get all of the replies (children), convert them to snapshots, and make sure there is at least 1
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for tripSnapshot in snapshots{
                    trip.excursions.append(Excursion(dictionary: tripSnapshot.value as! Dictionary<String, AnyObject>, snapshot: tripSnapshot))
                }
            }
            self.excursionFeedDelegate?.excursionAddedToFeed()
        })
    }
    
    

    func postTrip(trip: Trip){
        let newTripRef = tripRef.childByAutoId()
        newTripRef.setValue(trip.toDictionary())
    }
    
    func postExcursion(excur: Excursion, trip: Trip){
        //we store replies under the id of the yak, then under a unique id for the reply
        let newExcurRef = excuRef.childByAppendingPath(trip.snapshot!.key).childByAutoId()
        newExcurRef.setValue(excur.toDictionary())
    }
    
}


