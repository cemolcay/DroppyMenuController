//
//  ViewController.swift
//  DroppyMenuController
//
//  Created by Cem Olcay on 23/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func openMenuPressed (sender: UIButton) {
        let parent = parentViewController as! MenuViewController
        parent.openMenu()
    }
    
}
