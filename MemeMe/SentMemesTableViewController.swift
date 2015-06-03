//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Sudha Subramanian on 5/31/15.
//  Copyright (c) 2015 Sudha Subramanian. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    var memes: [Meme]!

    override func viewWillAppear(animated: Bool) {
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        self.tabBarController?.selectedIndex = 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return memes.count
    }

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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRow = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetail") as! DetailViewController
        selectedRow.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(selectedRow, animated: true)
    }
    
    @IBAction func goToSendMemeView(sender: UIBarButtonItem) {
        var nextController = ImagePickViewController()
        nextController = self.storyboard?.instantiateViewControllerWithIdentifier("ImagePicker") as! ImagePickViewController
        self.presentViewController(nextController, animated: true, completion: nil)
    }
}
