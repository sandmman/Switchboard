//
//  ComposeViewController.swift
//  Switchboard
//
//  Created by Aaron Liberatore on 4/7/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

import UIKit
import CoreLocation

class ComposeViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var characterCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        print("FUCK")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendButtonPressed(sender: AnyObject) {
        //createNewYak(textView.text)
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
        // range.length is 1 when deleting a character
        characterCountLabel.text = String(200 - textLength)
        if textLength >= 200 {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Actions
    
    func createNewYak(text: String) {

    }
    
    // MARK: - Private functions
    
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