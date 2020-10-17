//
//  DroppyMenuViewController.swift
//  DroppyMenuController
//
//  Created by Cem Olcay on 23/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class DroppyMenuViewController: UIViewController, DroppyMenuViewDelegate, UICollisionBehaviorDelegate {
    
    
    // MARK: Properties
    
    var viewControllers: [UIViewController]! {
        didSet {
            defaultInit()
        }
    }
    
    var currentViewController: UIViewController!
    var containerView: UIView!
    
    var menuView: DroppyMenuView!
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var collision: UICollisionBehavior!

    
    
    // MARK: Lifecycle
    
    init (viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        assert(viewControllers.count > 0, "view controllers must be not empty")
        
        self.viewControllers = viewControllers
        defaultInit()
    }
    
    func defaultInit () {
        containerView = UIView (frame: view.frame)
        view.addSubview(containerView)

        moveFirstViewController()
        
        menuView = DroppyMenuView (items: viewControllers.map( { return $0.title! } ))
        menuView.delegate = self
        
        menuView.bottom = view.top
        view.addSubview(menuView)
        
        view.bringSubviewToFront(menuView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init (coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    
    // MARK: View Controller Management
    
    func moveFirstViewController () {
        currentViewController = viewControllers[0]
        
        currentViewController.willMove(toParent: self)
        addChild(currentViewController)
        currentViewController.view.frame = containerView.frame
        containerView.addSubview(currentViewController.view)
        currentViewController.didMove(toParent: self)
    }
    
    func moveViewController (to: UIViewController) {
        
        if to == currentViewController {
            return
        }
        
        addChild(to)
        currentViewController!.willMove(toParent: nil)
        
        to.view.frame = currentViewController.view.frame
        
        transition (from: currentViewController,
                    to: to,
            duration: 0.7,
            options: .transitionCrossDissolve,
            animations: { [unowned self] () -> Void in
                
            },
            completion: { [unowned self] finished -> Void in
                self.currentViewController.removeFromParent()
                self.currentViewController = to
                to.didMove(toParent: self)
        })
    }
    
    
    
    // MARK: Menu
    
    func openMenu () {
        
        if menuView.isAnimating {
            return
        }
        
        menuView.isAnimating = true
        
        animator = UIDynamicAnimator(referenceView: view)

        gravity = UIGravityBehavior(items: [menuView])
        gravity.magnitude = menuView.appeareance.gravityMagnitude
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior(items: [menuView])
        
        collision.addBoundary(withIdentifier: "bottom" as NSCopying,
                              from: CGPoint (x: 0, y: view.h),
                              to: CGPoint (x: view.w, y: view.h))
        collision.collisionDelegate = self
        animator.addBehavior(collision)
    }
    
    func closeMenu () {
        animator.removeAllBehaviors()
        UIView.animate(withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: menuView.appeareance.springDamping,
            initialSpringVelocity: menuView.appeareance.springVelocity,
            options: .allowAnimatedContent,
            animations: { [unowned self] () -> Void in
                self.menuView.bottom = self.view.top
            },
            completion: { [unowned self] finished in
                self.menuView.isAnimating = false
            })
    }

    
    
    // MARK: DroppyMenuViewDelegate
    
    func droppyMenuDidClosePressed(droppyMenu: DroppyMenuView) {
        closeMenu()
    }
    
    func droppyMenu(droppyMenu: DroppyMenuView, didItemPressedAtIndex index: Int) {
        closeMenu()
        moveViewController(to: viewControllers[index])
    }


    
    // MARK: UICollisionBehaviourDelegate
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        if identifier as? String == "bottom" {
            menuView.isAnimating = false
            print("bottom")
        }
    }

}
