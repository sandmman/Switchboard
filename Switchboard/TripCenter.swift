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

protocol ReplyFeedDelegate{
    func replyAddedToFeed()
}

class TripCenter: NSObject {
    static let sharedInstance = TripCenter()
    var tripFeedDelegate: TripFeedDelegate?
    
    //this is our base reference to our firebase database
    static let baseURL = "https://switchboardd.firebaseio.com/"
    let baseRef = Firebase(url: "\(baseURL)")
    let tripRef = Firebase(url: "\(baseURL)/trips")
    
    var allTrips = [Trip]()
    
    var subscribedReplyHandle: UInt?
    
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
    

    func postTrip(trip: Trip){
        let newTripRef = tripRef.childByAutoId()
        newTripRef.setValue(trip.toDictionary())
    }
    
    /*func postReply(reply: Reply, yak: Yak){
        //we store replies under the id of the yak, then under a unique id for the reply
        let newReplyRef = replyRef.childByAppendingPath(yak.snapshot!.key).childByAutoId()
        newReplyRef.setValue(reply.toDictionary())
    }*/
    
}


