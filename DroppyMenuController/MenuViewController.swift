//
//  MenuViewController.swift
//  DroppyMenuController
//
//  Created by Cem Olcay on 23/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class MenuViewController: DroppyMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let first = getViewController("First")
        let second = getViewController("Second")
        let third = getViewController("Third")
        
        viewControllers = [first, second, third]
        
        var appear = DroppyMenuViewAppeareance ()
        appear.font = UIFont (name: "HelveticaNeue-Light", size: 20)!
        appear.tintColor = UIColor.whiteColor()
        appear.backgroundColor = UIColor (white: 0, alpha: 0.5)
        appear.lineWidth = 1
        menuView.appeareance = appear
    }
    
    func getViewController (storyboardIdentifier: String) -> UIViewController {
        return UIStoryboard (name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier) as! UIViewController
    }
}
