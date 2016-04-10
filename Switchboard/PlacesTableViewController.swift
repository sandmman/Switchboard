//
//  PlacesTableViewController.swift
//  Switchboard
//
//  Created by Aaron Liberatore on 4/7/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

import UIKit
import CoreLocation

class PlacesTableViewController: UITableViewController, CLLocationManagerDelegate, PlacesTableViewCellDelegate, TripFeedDelegate {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        TripCenter.sharedInstance.tripFeedDelegate = self
        
        //tableView.estimatedRowHeight = 100
        //tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return trips().count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PlacesTableViewCell
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        let trip = trips()[indexPath.row]
        cell.postImageView.image = UIImage(named: "japanvillage")
        cell.postTitleLabel.text = trip.title
        cell.timestamp.text = trip.timestampToReadable()
        
        if let savedUser = loadUser() {
            cell.authorLabel.text = savedUser.firstName + " " + savedUser.lastName
            cell.authorImageView.image = savedUser.profilePicture
            
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("TripDetailSegue", sender: indexPath)
    }
    
    func tripAddedToFeed() {
        self.tableView.reloadData()
    }
    
    func trips() -> [Trip]{
        return TripCenter.sharedInstance.allTrips
    }
    
    func loadUser() -> User? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(User.ArchiveURL.path!) as? User
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TripDetailSegue" {
            if let detailVC = segue.destinationViewController as? DetailViewController,
                indexPath = sender as? NSIndexPath {
                    //here is how we let the Detail scene know what Trip it needs to display
                    detailVC.trip = trips()[indexPath.row]
            }
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
