//
//  DroppyMenuView.swift
//  DroppyMenuController
//
//  Created by Cem Olcay on 23/02/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

extension UIView {
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        } set (value) {
            self.frame = CGRect (x: value, y: self.y, width: self.w, height: self.h)
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        } set (value) {
            self.frame = CGRect (x: self.x, y: value, width: self.w, height: self.h)
        }
    }
    
    var w: CGFloat {
        get {
            return self.frame.size.width
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: value, height: self.h)
        }
    }
    
    var h: CGFloat {
        get {
            return self.frame.size.height
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: self.w, height: value)
        }
    }
    
    
    var left: CGFloat {
        get {
            return self.x
        } set (value) {
            self.x = value
        }
    }
    
    var right: CGFloat {
        get {
            return self.x + self.w
        } set (value) {
            self.x = value - self.w
        }
    }
    
    var top: CGFloat {
        get {
            return self.y
        } set (value) {
            self.y = value
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.y + self.h
        } set (value) {
            self.y = value - self.h
        }
    }
    
    
    var position: CGPoint {
        get {
            return self.frame.origin
        } set (value) {
            self.frame = CGRect (origin: value, size: self.frame.size)
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        } set (value) {
            self.frame = CGRect (origin: self.frame.origin, size: value)
        }
    }
    
    
    func leftWithOffset (offset: CGFloat) -> CGFloat {
        return self.left - offset
    }
    
    func rightWithOffset (offset: CGFloat) -> CGFloat {
        return self.right + offset
    }
    
    func topWithOffset (offset: CGFloat) -> CGFloat {
        return self.top - offset
    }
    
    func bottomWithOffset (offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }
    
}

struct DroppyMenuViewAppeareance {
    
    var tintColor: UIColor
    var font: UIFont
    var backgroundColor: UIColor
    
    var gravityMagnitude: CGFloat
    var springVelocity: CGFloat
    var springDamping: CGFloat
}

extension DroppyMenuViewAppeareance {
    
    init () {
        self.tintColor = UIColor.whiteColor()
        self.font = UIFont.systemFontOfSize(15)
        self.backgroundColor = UIColor (white: 0, alpha: 0.2)
        self.gravityMagnitude = 10
        self.springDamping = 0.9
        self.springVelocity = 0.9
    }
}

protocol DroppyMenuViewDelegate {
    func droppyMenu (droppyMenu: DroppyMenuView, didItemPressedAtIndex index: Int)
    func droppyMenuDidClosePressed (droppyMenu: DroppyMenuView)
}

class DroppyMenuView: UIView {

    
    // MARK: Properties
    
    var delegate: DroppyMenuViewDelegate?
    var appeareance: DroppyMenuViewAppeareance!
    
    var isAnimating: Bool = false
    
    
    
    // MARK: Lifecycle
    
    convenience init (items: [String]) {
        self.init (items: items, appeareance: DroppyMenuViewAppeareance())
    }

    init (items: [String], appeareance: DroppyMenuViewAppeareance) {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        self.appeareance = appeareance
        
        let itemHeight = frame.size.height / CGFloat(items.count + 1)
        var currentY: CGFloat = 0
        var tag: Int = 0
        
        for title in items {
            
            let item = createItem(title, currentY: currentY, itemHeight: itemHeight)
            item.tag = tag++
            currentY += item.h
            addSubview(item)
        }
        
        let close = closeButton(itemHeight)
        close.y = currentY
        addSubview(close)
        
        backgroundColor = UIColor (white: 0, alpha: 0.3)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
 
    
    // MARK: Create
    
    func createItem (title: String, currentY: CGFloat, itemHeight: CGFloat) -> UIView {
        let button = UIButton (frame: CGRect (x: 0, y: currentY, width: frame.size.width, height: itemHeight))
        button.setTitle(title, forState: .Normal)
        button.addTarget(self, action: "itemPressed:", forControlEvents: .TouchUpInside)
        
        let sep = CALayer ()
        sep.frame = CGRect (x: 0, y: button.h, width: button.w, height: 1)
        sep.backgroundColor = UIColor.whiteColor().CGColor
        button.layer.addSublayer(sep)
        
        return button
    }
    
    func closeButton (itemHeight: CGFloat) -> UIView {
        let button = UIButton (frame: CGRect (x: 0, y: 0, width: frame.size.width, height: itemHeight))
        button.addTarget(self, action: "closePressed:", forControlEvents: .TouchUpInside)
        
        let close = CAShapeLayer ()
        close.frame = CGRect (x: 0, y: 0, width: 20, height: 20)
        close.position = button.layer.position
        
        let path = UIBezierPath ()
        let a: CGFloat = 20
        path.moveToPoint(CGPoint (x: 0, y: 0))
        path.addLineToPoint(CGPoint (x: a, y: a))
        path.moveToPoint(CGPoint (x: 0, y: a))
        path.addLineToPoint(CGPoint (x: a, y: 0))
        
        close.path = path.CGPath
        close.lineWidth = 3
        close.strokeColor = UIColor.whiteColor().CGColor
        button.layer.addSublayer (close)
        
        let sep = CALayer ()
        sep.frame = CGRect (x: 0, y: button.h, width: button.w, height: 1)
        sep.backgroundColor = UIColor.whiteColor().CGColor
        button.layer.addSublayer(sep)
        
        return button
    }
    
    
    
    // MARK: Action
    
    func itemPressed (sender: UIButton) {
        
        if isAnimating {
            return
        }
        
        delegate?.droppyMenu(self, didItemPressedAtIndex: sender.tag)
    }
    
    func closePressed (sender: UIButton) {
        
        if isAnimating {
            return
        }
        
        delegate?.droppyMenuDidClosePressed(self)
    }

}
