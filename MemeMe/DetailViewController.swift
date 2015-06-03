//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Sudha Subramanian on 6/2/15.
//  Copyright (c) 2015 Sudha Subramanian. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        self.topLabel.text = meme.top
        self.bottomLabel.text = meme.bottom
        self.imageV.image = meme.image
    }
}
