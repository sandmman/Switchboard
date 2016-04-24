//
//  ComposeViewController.swift
//  Switchboard
//
//  Created by Aaron Liberatore on 4/7/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

import UIKit
import CoreLocation
//import KMPlaceholderTextView

class ComposeViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var location: UITextField!
    @IBOutlet var username: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var textView: UITextView!
        
    //var loc: CLLocationCoordinate2D
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let savedUser = loadUser() {
            username.text = savedUser.firstName + " " + savedUser.lastName
            profilePic!.image = savedUser.profilePicture
            
        } else{
            username.text = "Username"
            profilePic!.image = UIImage(named: "social")
        }
        
        let borderColor : UIColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = borderColor.CGColor
        textView.layer.cornerRadius = 8.0
        
        profilePic.layer.cornerRadius = 10.0
        profilePic.clipsToBounds = true
        profilePic.layer.borderColor = UIColor.blackColor().CGColor
        profilePic.layer.borderWidth = 2.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendButtonPressed(sender: AnyObject) {
        createNewTrip()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextView delegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        //check if the 'Done' button was pressed on the keyboard
        if text.containsString("\n") {
            //createNewYak(textView.text)
            return false
        }
        
        //limit length of Yak
        let textLength = textView.text.characters.count + text.characters.count - range.length

        if textLength >= 200 {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Actions
    
    func createNewTrip() {
        var name = "Unidentified"
        var photo = UIImage()
        if let savedUser = loadUser() {
            name = savedUser.firstName + " " + savedUser.lastName
            photo = savedUser.profilePicture!
        }
        let newTrip = Trip(name: name, title: location.text!, descrip: textView.text!, userPhoto: photo, timestamp: NSDate())
        
        TripCenter.sharedInstance.postTrip(newTrip)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func loadUser() -> User? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(User.ArchiveURL.path!) as? User
    }
    private func alert(message : String) {
        let alert = UIAlertController(title: "Oops, something went wrong.", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        let settings = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alert.addAction(settings)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}