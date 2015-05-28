//
//  MemeEditorViewController.swift
//  Meme Me
//
//  Created by Ethan Haley on 5/20/15.
//  Copyright (c) 2015 Ethan Haley. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!  // the action button in top left
    @IBOutlet weak var pickedImage: UIImageView!  // the photo used for the meme
    @IBOutlet weak var bottomText: UITextField!  // the meme text boxes
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var camPickerButton: UIBarButtonItem!  // toolbar button for using camera to meme
    
    let topMemeDelegate = MemeTextDelegate()
    let bottomMemeDelegate = MemeTextDelegate()
    
    // the following font attributes were suggested by Udacity to approximate the Impact font
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(float: -3.0)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // declare the delegates for the editor's text fields
        bottomText.delegate = bottomMemeDelegate
        topText.delegate = topMemeDelegate
        // use the NS text properties laid out above
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = NSTextAlignment.Center
        
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.Center
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // hide the tab bar for this view
        self.tabBarController?.tabBar.hidden = true
        // determine whether the camera button will show
        camPickerButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        // enable the share button only if user has selected an image
        shareButton.enabled = false
        if let dummyVar = pickedImage.image {
            shareButton.enabled = true
        }
        // connect the keyboard Notification listener
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // bring the tab bar back upon exit from this view
        self.tabBarController?.tabBar.hidden = false
        // disconnect the keyboard Notification listener
        unsubscribeFromKeyboardNotifications()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        // look up user-selected photo in the info dictionary and set the editor's imageView to it
        let chosen = info[UIImagePickerControllerOriginalImage as NSObject] as! UIImage
        self.pickedImage.image = chosen
        // place the default text in textFields
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        // dismiss the picker
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickFromAlbum(sender: UIBarButtonItem) {
        // if user chooses "Album" on the toolbar
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imageController, animated: true, completion: nil)
        
    }
    
    @IBAction func pickFromCamera(sender: UIBarButtonItem) {
        // if user chooses camera on the toolbar
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imageController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // if user presses cancel on the navigation bar
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        // if user presses the action button on the navigation bar
        // create a UIImage snapshot of the imageView with its two textFields
        let meme = generateMemedImage()
        // create a MemeStruct with the snapshot and its 3 components
        let memeStruct = MemeStruct(top: self.topText.text, bottom: self.bottomText.text, orig: self.pickedImage.image!, memed: meme)
        // pass the UIImage snapshot to the activity VC to be able to do something with it
        let nextController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        // disable any share features that don't apply
        nextController.excludedActivityTypes = [UIActivityTypeAssignToContact]
        // use the handler to save the meme in the AppDelegate and dismiss the editor, after the share action completes
        nextController.completionWithItemsHandler = { (activityType: String!, completed: Bool, [AnyObject]!, NSError) in
            // if VC dismisses due to user hitting cancel button, return to editor without further action
            if !completed {
                return
            }
            self.saveMeme(memeStruct)
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        self.presentViewController(nextController, animated: true, completion: nil)
       
    }
    
    func subscribeToKeyboardNotifications() {
        // register the VC to respond to keyboard visibility change notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        // de-register the VC to respond to keyboard visibility change notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.editing {  // only shift the view up if it's the bottom field being edited
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.editing {  // only shift the view down if it's the bottom field being edited
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        // get the userInfo dictionary from the notification
        let userInfo = notification.userInfo
        // get the keyboard CGRect from the userInfo dictionary
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    func generateMemedImage() -> UIImage {
        // clear the navigation bars to render the screen image
        self.navigationController?.toolbarHidden = true
        self.navigationController?.navigationBarHidden = true
        // change the context to bitmap-based
        UIGraphicsBeginImageContext(self.view.frame.size)
        // take a snapshot of the view
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        // convert that snapshot into a UIImage
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        // remove the bitmap context
        UIGraphicsEndImageContext()
        // return the nav bars to the view
        self.navigationController?.toolbarHidden = false
        self.navigationController?.navigationBarHidden = false
        
        return memedImage
    }
    func saveMeme(meme: MemeStruct) {
        // add a meme to the shared data model
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }


}
