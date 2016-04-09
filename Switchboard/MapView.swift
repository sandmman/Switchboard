//
//  MapView.swift
//  Switchboard
//
//  Created by Aaron Liberatore on 4/8/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

import UIKit

class MapView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.customInit();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.customInit();
    }
    
    func customInit() {
        self.layer.cornerRadius = 10;
        self.layer.shadowColor = UIColor(white: 0, alpha: 1).CGColor;
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 3;
    }
    
}

