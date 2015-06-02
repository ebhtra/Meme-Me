//
//  MemeTableCell.swift
//  Meme Me
//
//  Created by Ethan Haley on 6/2/15.
//  Copyright (c) 2015 Ethan Haley. All rights reserved.
//

import UIKit

class MemeTableCell: UITableViewCell {

    // the 3 custom fields, set by the dataSource delegate
    @IBOutlet weak var tablePic: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
}
