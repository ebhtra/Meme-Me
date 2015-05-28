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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // grab and store the meme list from the AppDelegate
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.memes = applicationDelegate.memes
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as! UITableViewCell
        return cell
        
    }


}

