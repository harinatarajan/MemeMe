//
//  Meme.swift
//  MemeMe
//
//  Created by Sudha Subramanian on 5/28/15.
//  Copyright (c) 2015 Sudha Subramanian. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    //Selected Image
    var image: UIImage!
    
    //Comment at the top of the selected image
    var top: String!
    
    //Comment at the bottom of the selected image
    var bottom: String!
    
    //Shared image
    var memedImage: UIImage!
    
    init(top: String, image: UIImage, bottom: String, memedImage: UIImage) {
        self.top = top
        self.image = image
        self.bottom = bottom
        self.memedImage = memedImage
    }
}
extension Meme {
    //Array of shared images
    static var allMemes: [UIImage]!
    
    //Put and get helper functions
    static func getMemes() -> [UIImage] {
        return allMemes
    }
    
    static func addMemes(image: UIImage) {
        if allMemes == nil { allMemes = [image] }
        else { allMemes.append(image) }
    }
    
    //Array of shared memes
    static var memeArray: [Meme] {
        var mArray = [Meme]()
        return mArray
    }
}
