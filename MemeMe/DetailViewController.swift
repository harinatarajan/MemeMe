//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Sudha Subramanian on 6/2/15.
//  Copyright (c) 2015 Sudha Subramanian. All rights reserved.
//

import UIKit
//Called from the table or collection view controllers, when the 
//user selects a shared meme
class DetailViewController: UIViewController {

    @IBOutlet weak var imageV: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        self.imageV.image = meme.memedImage
    }
}
