//
//  MemeClass.swift
//  Meme Me
//
//  Created by Ethan Haley on 11/14/15.
//  Copyright © 2015 Ethan Haley. All rights reserved.
//
//  This class is added to be able to persist memes using CoreData

import Foundation
import UIKit
import CoreData

class MemeClass: NSManagedObject {
    
    @NSManaged var topText: String
    @NSManaged var bottomText: String
    @NSManaged var original: UIImage
    @NSManaged var memed: UIImage
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(memeToStore: MemeStruct, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("MemeClass", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        topText = memeToStore.topText
        bottomText = memeToStore.bottomText
        original = memeToStore.original
        memed = memeToStore.memed
    }
}