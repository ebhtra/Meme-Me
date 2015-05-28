//
//  MemeStruct.swift
//  Meme Me
//
//  Created by Ethan Haley on 5/20/15.
//  Copyright (c) 2015 Ethan Haley. All rights reserved.
//

import Foundation
import UIKit

// encapsulate a completed meme with its 3 components
struct MemeStruct {
    let topText: String!
    let bottomText: String!
    let original: UIImage!
    let memed: UIImage!
    // initialize with all 4 parameters
    init(top: String, bottom: String, orig: UIImage, memed: UIImage) {
        topText = top
        bottomText = bottom
        original = orig
        self.memed = memed
    }
}
