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

    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        //if nothing in history, go to send new Meme view
        if memes.count == 0 { goToMemeEditor() }
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        let c = self.memes[indexPath.row]
        cell.imageView.image = c.image
        cell.setText(c.top, bottom: c.bottom)
        cell.backgroundView = UIImageView(image: c.image)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetail") as! DetailViewController
        selectedItem.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(selectedItem, animated: true)
    }
    
    func goToMemeEditor() {
        self.tabBarController?.removeFromParentViewController()
        self.performSegueWithIdentifier("MemeEditor", sender: self)
    }
    
    @IBAction func goToSendMemeView(sender: UIBarButtonItem) {
        goToMemeEditor()
    }
}
