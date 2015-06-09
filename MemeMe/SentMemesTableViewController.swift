//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Sudha Subramanian on 5/31/15.
//  Copyright (c) 2015 Sudha Subramanian. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    //cache of sent memes
    var memes: [Meme]!

    override func viewWillAppear(animated: Bool) {
        //Get the shared memes from the AppDelegate (which is our data storage :-))
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes

        //if nothing in shared history, go to the MemeEditor- that is, ImagePickViewController
        if memes.count == 0 { goToMemeEditor() }
    }

    //function to return the number of items in the memes array
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    //function to return the meme at the selected index
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let c = memes[indexPath.row]
        cell.imageView?.image = c.memedImage
        cell.textLabel?.text = c.top + c.bottom
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = c.top + c.bottom
        }
        return cell
    }

    //Open the detail view for the selected meme
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRow = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetail") as! DetailViewController
        selectedRow.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(selectedRow, animated: true)
    }
    
    //Prepare to go to ImagePickViewController
    func goToMemeEditor() {
        self.tabBarController?.removeFromParentViewController()
        self.performSegueWithIdentifier("MemeEditor", sender: self)
    }
    
    //when the user presses the "+" in the navigation bar ...
    @IBAction func startMemeEditor(sender: UIBarButtonItem) { goToMemeEditor() }
}
