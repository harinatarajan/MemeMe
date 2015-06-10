//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Sudha Subramanian on 6/2/15.
//  Copyright (c) 2015 Sudha Subramanian. All rights reserved.
//

import UIKit
//This class encapsulates the meme comments and image as a single object;
//Used by the collection view controller
class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    
    func setText(top: String!, bottom: String!) {
        topLabel.text = top
        bottomLabel.text = bottom
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
}
