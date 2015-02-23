//
//  EnteringViewController.swift
//  DroppyMenuController
//
//  Created by Cem Olcay on 23/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class BlockButton: UIButton {
    
    init (x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        super.init (frame: CGRect (x: x, y: y, width: w, height: h))
    }
    
    override init (frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var actionBlock: ((sender: BlockButton) -> ())? {
        didSet {
            self.addTarget(self, action: "action:", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func action (sender: BlockButton) {
        actionBlock! (sender: sender)
    }
}


class EnteringViewController: UIViewController {

    var menuController: DroppyMenuViewController!
    
    override func viewDidLoad() {
    
        let first = getViewController(UIColor.blueColor(), title: "First")
        let second = getViewController(UIColor.redColor(), title: "Second")
        let third = getViewController(UIColor.yellowColor(), title: "Third")
        
        menuController = DroppyMenuViewController (viewControllers: [first, second, third])

        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.window?.rootViewController = menuController
    }
    
    func getViewController (color: UIColor, title: String) -> UIViewController {
        let vc = UIViewController ()
        vc.view.backgroundColor = color
        vc.title = title
        
        let button = BlockButton (frame: CGRect (x: 10, y: 30, width: 150, height: 60))
        button.setTitle("menu", forState: .Normal)
        button.actionBlock = { sender in
            self.menuController.openMenu()
        }
        vc.view.addSubview(button)
        
        return vc
    }
    
}