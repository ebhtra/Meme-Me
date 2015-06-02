//
//  MemeDetailViewController.swift
//  Meme Me
//
//  Created by Ethan Haley on 5/28/15.
//  Copyright (c) 2015 Ethan Haley. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    
    @IBOutlet weak var memeDetailImage: UIImageView!
    
    // store the meme Image sent by user selection
    var detailImage : UIImage!
    
    // store the index of the meme for possible deletion or editing
    var index: Int!


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // set the detail image
        memeDetailImage.image = detailImage
        
        // no tab bar for this screen
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // bring back tab bar on exit
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    @IBAction func deleteFromModel(sender: UIButton) {
        // remove the meme from the AppDelegate and dismiss the VC
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        applicationDelegate.memes.removeAtIndex(index)
        self.navigationController!.popViewControllerAnimated(true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editSent" { // if user hits "edit meme" button
            let navController = segue.destinationViewController as! UINavigationController
            
            // this is a bit of a hack due to my embedding the MemeEditorVC in a navigationController
            let editController = navController.viewControllers[0] as! MemeEditorViewController
            
            // use the self.index property to pass the sent meme to the editor
            let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[index]
            editController.sentMeme = meme
        }
    }
}
