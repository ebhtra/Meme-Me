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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // grab and store the meme list from the AppDelegate
        let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = applicationDelegate.memes
        
        // update the data appearing in the TableView
        table.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // if there are no sent memes, go directly to the editor
        if memes.count == 0 {
            self.performSegue(withIdentifier: "tableToEditor", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // how many memes in the table?
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // take a custom cell off the queue and set its elements
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! MemeTableCell
        let memeStruct = self.memes[indexPath.row]
        cell.tablePic.image = memeStruct.memed
        cell.topLabel.text = memeStruct.topText
        cell.bottomLabel.text = memeStruct.bottomText
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // create a DetailVC by storyboard ID
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        // set the detail image for the View
        detailController.detailImage = self.memes[indexPath.row].memed
        
        // pass the index of the meme
        detailController.index = indexPath.row
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        switch (editingStyle) {
        case .delete:
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let storedMeme = appDel.storedMemes[indexPath.row]
            
            // Remove the actor from the array
            memes.remove(at: indexPath.row)
            
            // Remove the row from the table
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
            // Remove the actor from the context
            CoreDataStackManager.sharedInstance().managedObjectContext.delete(storedMeme)
            CoreDataStackManager.sharedInstance().saveContext()
        default:
            break
        }
    }

}

