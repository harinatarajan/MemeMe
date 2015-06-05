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
        //Get the send memes list
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        //if nothing in history, go to send new Meme view
        if memes.count == 0 { goToMemeEditor() }
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
    
    func goToMemeEditor() {
        self.tabBarController?.removeFromParentViewController()
        self.performSegueWithIdentifier("MemeEditor", sender: self)
    }
    
    @IBAction func startMemeEditor(sender: UIBarButtonItem) { goToMemeEditor() }
}
