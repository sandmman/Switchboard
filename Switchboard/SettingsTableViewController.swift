//
//  SettingscontrollerTableViewController.swift
//  Switchboard
//
//  Created by Aaron Liberatore on 4/7/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

import UIKit

protocol AccountViewDelegate {
    func didUpdateAccount(user: User)
}

class SettingsTableViewController: UITableViewController, AccountViewDelegate {

    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet var name:UILabel!
    @IBOutlet var profilePic:UIImageView?
    
    weak var colors = AccountTableViewController()
    
    var delegate: User?
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("menuToSettings", sender: self)
    }
    
    @IBAction func unwindFromSecondVC(segue: UIStoryboardSegue) {
        // Here you can receive the parameter(s) from secondVC
        let _ : AccountTableViewController = segue.sourceViewController as! AccountTableViewController
        viewDidLoad()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //colors!.delegate = self
        if let savedUser = loadUser() {
            name.text = savedUser.firstName + " " + savedUser.lastName
            profilePic!.image = savedUser.profilePicture
            profilePic!.layer.cornerRadius = 20.0
            profilePic!.clipsToBounds = true
            profilePic!.layer.borderColor = UIColor.purpleColor().CGColor
            profilePic!.layer.borderWidth = 2.0

        } else {
            profilePic!.image = UIImage(named: "social")
        }
        //var secondViewController = (userSegue.destinationViewController.visibleViewController as  AccountTableViewController)
        //secondViewController.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUser() -> User? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(User.ArchiveURL.path!) as? User
    }
    
    func didUpdateAccount(user: User) {
        print("delegate!")
        self.name.text = user.firstName
        //viewDidLoad()
    }

    /*override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
