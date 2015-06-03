//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Sudha Subramanian on 6/2/15.
//  Copyright (c) 2015 Sudha Subramanian. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    
    func setText(top: String!, bottom: String!) {
        self.topLabel.text = top
        self.bottomLabel.text = bottom
    }
    
}
