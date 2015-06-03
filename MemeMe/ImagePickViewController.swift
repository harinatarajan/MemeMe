//
//  ImagePickViewController.swift
//  MemeMe
//
//  Created by Sudha Subramanian on 5/28/15.
//  Copyright (c) 2015 Sudha Subramanian. All rights reserved.
//

import UIKit

class ImagePickViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var shareMeme: UIBarButtonItem!

    var enableShareMeme = false
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 16)!,
        NSStrokeWidthAttributeName : 5.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.borderStyle = UITextBorderStyle.None
        bottomTextField.borderStyle = UITextBorderStyle.None

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
         //We don’t want the user to accidentally share an unfinished meme, so we want to disable the share button until an image has been chosen
        shareMeme.enabled = enableShareMeme
        enableShareMeme = false
        //Show toolbar and navbar
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        enableShareMeme = true
    }
    
    func save() {
        //Create the meme
        var meme = Meme( top: topTextField.text!, image:
            imageView.image!, bottom: bottomTextField.text!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.sharedApplication().delegate as!
            AppDelegate).memes.append(meme)
    }
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        //Hide toolbar and navbar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        return memedImage
    }
    
    @IBAction func sendMeme(sender: UIBarButtonItem) {
        //Create the meme
        let firstActivityItem = Meme(top: topTextField.text!, image:
            imageView.image!, bottom: bottomTextField.text!, memedImage: generateMemedImage())
        let secondActivityItem: NSURL = NSURL(fileURLWithPath: "http://www.google.com")!
        let shareViewController = UIActivityViewController(activityItems: [firstActivityItem.memedImage, secondActivityItem], applicationActivities: nil)
        self.presentViewController(shareViewController, animated: true, completion: nil)
        
        shareViewController.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            println("completed \(s) \(ok) \(items) \(err)")
            if ok {
                // Add it to the memes array in the Application Delegate
                (UIApplication.sharedApplication().delegate as!
                    AppDelegate).memes.append(firstActivityItem)
                var nextController = SentMemesTableViewController()
                nextController = self.storyboard?.instantiateViewControllerWithIdentifier("SentMemesTable") as! SentMemesTableViewController
                self.presentViewController(nextController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func ClearAll(sender: UIBarButtonItem) {
        self.topTextField.text.removeAll(keepCapacity: true)
        self.bottomTextField.text.removeAll(keepCapacity: true)
        self.imageView.image = nil
        shareMeme.enabled = false
    }
}

