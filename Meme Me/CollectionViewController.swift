//
//  CollectionViewController.swift
//  Meme Me
//
//  Created by Ethan Haley on 5/19/15.
//  Copyright (c) 2015 Ethan Haley. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource {
    
    var memes: [MemeStruct]! // shared data stored in AppDelegate and copied here in viewWillAppear()
    
    @IBOutlet weak var gridView: UICollectionView! // need this outlet to force reload of data
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // grab and store the meme list from the AppDelegate
        let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = applicationDelegate.memes
        
        // force reload of data in case a meme was added to or deleted from the model
        gridView.reloadData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // if there are no sent memes, go directly to the editor
        if memes.count == 0 {
            self.performSegue(withIdentifier: "collectionToEditor", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // how many memes are there to display?
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // take a cell off the queue and set its image
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeCellCollectionViewCell
        let memeStruct = self.memes[indexPath.row]
        cell.gridPic.image = memeStruct.memed
       
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        // create a DetailVC by storyboard ID
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        // set the detail image for the View
        detailController.detailImage = self.memes[indexPath.row].memed
        
        // pass the index of the meme
        detailController.index = indexPath.row
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    


}

