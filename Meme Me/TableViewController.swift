//
//  TableViewController.swift
//  Meme Me
//
//  Created by Ethan Haley on 5/19/15.
//  Copyright (c) 2015 Ethan Haley. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var memes: [MemeStruct]! // shared data stored in AppDelegate
    
    @IBOutlet weak var table: UITableView!  // need this to force data reload
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        // grab and store the meme list from the AppDelegate
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.memes = applicationDelegate.memes
        
        // update the data appearing in the TableView
        table.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // how many memes in the table?
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // take a cell off the queue and set its elements
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as! UITableViewCell
        let memeStruct = self.memes[indexPath.row]
        cell.imageView?.image = memeStruct.memed
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = memeStruct.topText + " 😂 " + memeStruct.bottomText
        }
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // create a DetailVC by storyboard ID
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        // set the detail image for the View
        detailController.detailImage = self.memes[indexPath.row].memed
        // pass the index of the meme
        detailController.index = indexPath.row
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }


}

