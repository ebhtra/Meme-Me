//
//  CollectionViewController.swift
//  Meme Me
//
//  Created by Ethan Haley on 5/19/15.
//  Copyright (c) 2015 Ethan Haley. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource {
    
    var memes: [MemeStruct]! // shared data stored in AppDelegate and copied here in viewDidLoad()

    override func viewDidLoad() {
        super.viewDidLoad()
        // grab and store the meme list from the AppDelegate
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.memes = applicationDelegate.memes
        
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! MemeCellCollectionViewCell
        return cell
    
    }


}

