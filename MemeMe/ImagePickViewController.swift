//
//  ImagePickViewController.swift
//  MemeMe
//
//  Created by Sudha Subramanian on 5/28/15.
//  Copyright (c) 2015 Sudha Subramanian. All rights reserved.
//

import UIKit

class ImagePickViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    UITextFieldDelegate {

    //Image to share
    @IBOutlet weak var imageView: UIImageView!
    
    //Meme comment at the top of the image
    @IBOutlet weak var topTextField: UITextField!
    
    //Meme comment at the bottom of the image
    @IBOutlet weak var bottomTextField: UITextField!
    
    //If you wish to capture a new image from a camera instead of the album
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    //When you are ready to share
    @IBOutlet weak var shareMeme: UIBarButtonItem!

    //Variable to latch the state after an image is ready
    var enableShareMeme = false
    
    //Convenience dictionary for preferred text attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.redColor(),
        NSForegroundColorAttributeName : UIColor.redColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 16)!,
        NSStrokeWidthAttributeName : 5.0
    ]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Disable the camera button if the camera is not available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //Assign the preferred text attributes
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        //Let us remove the borders of the meme comments
        topTextField.borderStyle = UITextBorderStyle.None
        bottomTextField.borderStyle = UITextBorderStyle.None

        //Get notifications when keyboard shows
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        //Get notifications when keyboard hides
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        //We don’t want the user to accidentally share an unfinished meme, 
        //so disable the share button until an image has been chosen
        shareMeme.enabled = enableShareMeme
        
        //Disable the latch again until another image is ready
        enableShareMeme = false
        
        //Show toolbar and navbar
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //Best practice: Remove observers as they are no longer needed
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func keyboardWillShow(notification: NSNotification) {
        //When bottom comment is being written, shift the view UP in the Y direction
        //equal to the height of the keyboard
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        //When bottom comment is done, shift the view DOWN in the Y direction
        //equal to the height of the keyboard; that is, restore the view.
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //Get the keyboard height during keyboard activities
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //Remove the keyboard when return key is pressed; this is a UITextFieldDelegate
    //In the storyboard, set this controller as the two textfields' delegate OR
    //set the two textfield.delegate = self
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (topTextField.isFirstResponder()) {
            topTextField.resignFirstResponder()
        }
        if (bottomTextField.isFirstResponder()) {
            bottomTextField.resignFirstResponder()
        }
        return true
    }
    
    //Open the PhotoLibrary view controller modally
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Open the Camera view controller modally
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //UIImagePickerControllerDelegate function that tells this controller that the 
    //user has picked an image
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
    
    //Create a UIImage combining the selected image and the meme comments
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
    
    //When the user presses the sendMeme button
    @IBAction func sendMeme(sender: UIBarButtonItem) {
        //Create the meme item to share
        let activityItem = Meme(top: topTextField.text!, image:
            imageView.image!, bottom: bottomTextField.text!, memedImage: generateMemedImage())
        
        //Start the share activity view controller modally
        let shareViewController = UIActivityViewController(activityItems: [activityItem.memedImage], applicationActivities: nil)
        self.presentViewController(shareViewController, animated: true, completion: nil)
        
        //On sending the meme, this completion handler is executed
        shareViewController.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            println("completed \(s) \(ok) \(items) \(err)")
            
            //if completed successfully ....
            if ok {
                // Add this meme item to the memes array saved in the Application Delegate
                (UIApplication.sharedApplication().delegate as!
                    AppDelegate).memes.append(activityItem)
                // and show the 'sent memes'
                self.goToSentView()
            }
        }
    }
    
    func goToSentView() {
        // Prepare to go to the tab bar view. Clear the bottom bars, they were piling up
        self.navigationController?.removeFromParentViewController()
        self.removeFromParentViewController()
        self.performSegueWithIdentifier("SentTabBar", sender: self)
    }

    //When the user presses the cancel button ...
    @IBAction func ClearAll(sender: UIBarButtonItem) {
        goToSentView()
    }
}

