//
//  ViewController.swift
//  DroppyMenuController
//
//  Created by Cem Olcay on 23/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        println(self.parentViewController)
    }
    
    @IBAction func openMenuPressed () {
        let droppy = self.parentViewController as! DroppyMenuViewController
        droppy.openMenu()
    }
}

