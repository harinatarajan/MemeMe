//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Sudha Subramanian on 5/29/15.
//  Copyright (c) 2015 Sudha Subramanian. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class SentMemesCollectionViewController: UICollectionViewController {

    //cache of sent memes
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        //Get the shared memes from the AppDelegate (which is our data storage :-))
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        
        //if nothing in shared history, go to the MemeEditor- that is, ImagePickViewController
        if memes.count == 0 { goToMemeEditor() }
    }

    //UICollectionView function to return the number of items in the memes array
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    //UICollectionView function to return the meme at the selected index
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        let c = memes[indexPath.row]
        cell.imageView.image = c.image
        cell.setText(c.top, bottom: c.bottom)
        cell.backgroundView = UIImageView(image: c.image)
        return cell
    }
    
    //Open the detail view for the selected meme
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetail") as! DetailViewController
        selectedItem.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(selectedItem, animated: true)
    }
    
    //Prepare to go to ImagePickViewController
    func goToMemeEditor() {
        self.tabBarController?.removeFromParentViewController()
        self.performSegueWithIdentifier("MemeEditor", sender: self)
    }
    
    //when the user presses the "+" in the navigation bar ...
    @IBAction func goToSendMemeView(sender: UIBarButtonItem) {
        goToMemeEditor()
    }
}
