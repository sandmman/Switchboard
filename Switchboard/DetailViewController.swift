//
//  DetailViewController.swift
//  Switchboard
//
//  Created by Aaron Liberatore on 4/7/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var notes: UILabel!
    
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTripInfo()
        
    }
    
    func showTripInfo() {

        author.text = trip?.name
        location.text = trip?.title
        date.text = trip?.timestampToReadable()
        notes.text = trip?.descrip

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
