//
//  AccountTableViewController.swift
//  Switchboard
//
//  Created by Aaron Liberatore on 4/8/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

import UIKit

protocol AccountUpdateDelegate {
    func didUpdateAccount(user: User)
}
class AccountTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var firstName:UITextField!
    @IBOutlet weak var lastName:UITextField!
    @IBOutlet weak var email:UITextField!
    @IBOutlet weak var handle:UITextField!
    @IBOutlet weak var picture:UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var delegate: AccountUpdateDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        if let savedUser = loadUser() {
            firstName.text = savedUser.firstName
            lastName.text  = savedUser.lastName
            email.text = savedUser.email
            handle.text = savedUser.handle
            picture.image = savedUser.profilePicture
        } else {
            picture!.image = UIImage(named: "social")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func sendButtonPressed(sender: AnyObject) {
        saveUser(firstName.text!, lastName: lastName.text!, email: email.text!, handle: handle.text!, picture: picture)
    }
    
    func saveUser(firstName: String, lastName: String, email: String, handle: String, picture: UIImageView) {
        let newUser = User(firstName: firstName, lastName: lastName, email: email, handle: handle, profilePicture: picture.image)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newUser, toFile: User.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save User...")
        }
        print(delegate)
        self.delegate?.didUpdateAccount(newUser)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadUser() -> User? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(User.ArchiveURL.path!) as? User
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picture.contentMode = .ScaleAspectFit
            picture.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
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
