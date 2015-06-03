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
    var top: String!
    var image: UIImage!
    var bottom: String!
    var memedImage: UIImage!
    
    init(top: String, image: UIImage, bottom: String, memedImage: UIImage) {
        self.top = top
        self.image = image
        self.bottom = bottom
        self.memedImage = memedImage
    }
}
extension Meme {
    static var allMemes: [UIImage]!
    
    static func getMemes() -> [UIImage] {
        return allMemes
    }
    
    static func addMemes(image: UIImage) {
        if allMemes == nil { allMemes = [image] }
        else { allMemes.append(image) }
    }
    
    static var memeArray: [Meme] {
        var mArray = [Meme]()
        return mArray
    }
}
