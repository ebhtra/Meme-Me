//
//  MemeTextDelegate.swift
//  Meme Me
//
//  Created by Ethan Haley on 5/20/15.
//  Copyright (c) 2015 Ethan Haley. All rights reserved.
//

import UIKit

class MemeTextDelegate: NSObject, UITextFieldDelegate {
    // protocol methods for editing meme text
    func textFieldDidBeginEditing(textField: UITextField) {
        // clear any default text
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    // dismiss keyboard when user hits RETURN
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
