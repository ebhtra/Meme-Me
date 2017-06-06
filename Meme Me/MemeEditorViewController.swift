//
//  MemeEditorViewController.swift
//  Meme Me
//
//  Created by Ethan Haley on 5/20/15.
//  Copyright (c) 2015 Ethan Haley. All rights reserved.
//
import CoreData
import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var sentMeme: MemeStruct? // used when editing a previously sent meme
    
    @IBOutlet weak var shareButton: UIBarButtonItem!  // the action button in top left
    @IBOutlet weak var pickedImage: UIImageView!  // the photo used for the meme
    
    @IBOutlet weak var bottomText: UITextField!  // the meme text boxes
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var camPickerButton: UIBarButtonItem!  // toolbar button for using camera to meme
    @IBOutlet weak var albumPickerButton: UIBarButtonItem!  // toolbar button for meming a photo from the album
    
    
    let topMemeDelegate = MemeTextDelegate()
    let bottomMemeDelegate = MemeTextDelegate()
    
    // the following font attributes were suggested by Udacity to approximate the Impact font
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(value: -3.0 as Float)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // declare the delegates for the editor's text fields
        bottomText.delegate = bottomMemeDelegate
        topText.delegate = topMemeDelegate
        
        // use the NS text properties laid out above
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = NSTextAlignment.center
        
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.center
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // hide the tab bar for this view
        self.tabBarController?.tabBar.isHidden = true
        
        // determine whether the camera button will show
        camPickerButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        // set meme up if user is editing previously sent one
        if let sentMeme = self.sentMeme {
            pickedImage.image = sentMeme.original
            topText.text = sentMeme.topText
            bottomText.text = sentMeme.bottomText
            self.navigationController!.isToolbarHidden = true
        }
        
        // enable the share button only if user has selected an image
        shareButton.isEnabled = false
        if pickedImage.image != nil {
            shareButton.isEnabled = true
        }
        // connect the keyboard Notification listener
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // bring the tab bar back upon exit from this view
        self.tabBarController?.tabBar.isHidden = false
        
        // disconnect the keyboard Notification listener
        unsubscribeFromKeyboardNotifications()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // look up user-selected photo in the info dictionary and set the editor's imageView to it
        let chosen = info[UIImagePickerControllerOriginalImage as NSObject as! String] as! UIImage
        self.pickedImage.image = chosen
        
        // place the default text in textFields
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        // dismiss the picker
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickFromAlbum(_ sender: UIBarButtonItem) {
        // if user chooses "Album" on the toolbar
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imageController, animated: true, completion: nil)
        
    }
    
    @IBAction func pickFromCamera(_ sender: UIBarButtonItem) {
        // if user chooses camera on the toolbar
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = UIImagePickerControllerSourceType.camera
        self.present(imageController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // if user presses cancel on the navigation bar
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        // if user presses the action button on the navigation bar
        
        // create a UIImage snapshot of the imageView with its two textFields
        let meme = generateMemedImage()
        
        // create a MemeStruct with the snapshot and its 3 components
        let memeStruct = MemeStruct(top: self.topText.text!, bottom: self.bottomText.text!, orig: self.pickedImage.image!, memed: meme)
        
        // pass the UIImage snapshot to the activity VC to be able to do something with it
        let nextController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        
        // disable any share features that don't apply
        nextController.excludedActivityTypes = [UIActivityType.assignToContact]
        
        // use the handler to save the meme in the AppDelegate and dismiss the editor, after the share action completes
        
        nextController.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, _: [Any]?, error: Error?) in
            // if VC dismisses due to user hitting cancel button, return to editor without further action
            if !completed {
                return
            }
            self.saveMeme(memeStruct)
            self.persistMeme(memeStruct)
            self.dismiss(animated: false, completion: nil)
        }
        self.present(nextController, animated: true, completion: nil)
       
    }
    
    func subscribeToKeyboardNotifications() {
        // register the VC to respond to keyboard visibility change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        // de-register the VC to respond to keyboard visibility change notifications
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func keyboardWillShow(_ notification: Notification) {
        if bottomText.isEditing {  // only shift the view up if it's the bottom field being edited
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    func keyboardWillHide(_ notification: Notification) {
        if bottomText.isEditing {  // only shift the view down if it's the bottom field being edited
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        // get the userInfo dictionary from the notification
        let userInfo = notification.userInfo
        
        // get the keyboard CGRect from the userInfo dictionary
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    func generateMemedImage() -> UIImage {
        // clear the navigation bars to render the screen image
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        // change the context to bitmap-based
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        // take a snapshot of the view
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        // convert that snapshot into a UIImage
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // remove the bitmap context
        UIGraphicsEndImageContext()
        
        // return the nav bars to the view
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
        return memedImage
    }
    func saveMeme(_ meme: MemeStruct) {
        // add a meme to the shared data model
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    func persistMeme(_ meme: MemeStruct) {
        // add the managed object meme to the array just to be able to delete it
        let newMeme = MemeClass(memeToStore: meme, context: CoreDataStackManager.sharedInstance().managedObjectContext)
        (UIApplication.shared.delegate as! AppDelegate).storedMemes.append(newMeme)
        
        CoreDataStackManager.sharedInstance().saveContext()
    }


}
