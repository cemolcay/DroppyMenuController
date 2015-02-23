//
//  DroppyMenuSegue.swift
//  DroppyMenuController
//
//  Created by Cem Olcay on 23/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class DroppyMenuSegue: UIStoryboardSegue {

    override func perform() {
        
        let controller = sourceViewController as! DroppyMenuViewController
        let next = self.destinationViewController as! UIViewController
        let current = controller.currentViewController
        
        if next == current {
            return
        }
        
        controller.addChildViewController(next)
        current.willMoveToParentViewController(nil)
        
        next.view.frame = current.view.frame

        controller.transitionFromViewController (current,
            toViewController: next,
            duration: 1,
            options: .TransitionCrossDissolve,
            animations: { () -> Void in
                
            },
            completion: { finished -> Void in
                controller.currentViewController = next
                current.removeFromParentViewController()
                next.didMoveToParentViewController(controller)
            })
    }
    
}
