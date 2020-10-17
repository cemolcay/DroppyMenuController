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
    
    var lineWidth: CGFloat
    
    var gravityMagnitude: CGFloat
    var springVelocity: CGFloat
    var springDamping: CGFloat
}

extension DroppyMenuViewAppeareance {
    
    init () {
        self.tintColor = .white
        self.font = UIFont (name: "HelveticaNeue-Light", size: 20)!
        self.backgroundColor = UIColor (white: 0, alpha: 0.5)
        self.gravityMagnitude = 10
        self.springDamping = 0.9
        self.springVelocity = 0.9
        self.lineWidth = 1
    }
}

protocol DroppyMenuViewDelegate {
    func droppyMenu (droppyMenu: DroppyMenuView, didItemPressedAtIndex index: Int)
    func droppyMenuDidClosePressed (droppyMenu: DroppyMenuView)
}

class DroppyMenuView: UIView {

    
    // MARK: Properties
    
    var delegate: DroppyMenuViewDelegate?
    var appeareance: DroppyMenuViewAppeareance! {
        didSet {
            backgroundColor = appeareance.backgroundColor
            for view in subviews {
                if let view = view as? UIButton {
                    view.setTitleColor(appeareance.tintColor, for: .normal)
                    view.titleLabel?.font = appeareance.font
                    if let layer = view.layer.sublayers?[0] as? CAShapeLayer {
                        layer.strokeColor = appeareance.tintColor.cgColor
                        layer.lineWidth = appeareance.lineWidth
                    } else if let layer = view.layer.sublayers?[1] {
                        layer.backgroundColor = appeareance.tintColor.cgColor
                        
                        var f = layer.frame
                        f.size.height = appeareance.lineWidth
                        layer.frame = f
                    }
                }
            }
        }
    }
    
    var isAnimating: Bool = false
    
    
    
    // MARK: Lifecycle
    
    convenience init (items: [String]) {
        self.init (items: items, appeareance: DroppyMenuViewAppeareance())
    }

    init (items: [String], appeareance: DroppyMenuViewAppeareance) {
        super.init(frame: UIScreen.main.bounds)
        
        self.appeareance = appeareance
        
        let itemHeight = frame.size.height / CGFloat(items.count + 1)
        var currentY: CGFloat = 0
        let tag: Int = 0
        
        for title in items {
            
            let item = createItem(title: title, currentY: currentY, itemHeight: itemHeight)
            item.tag += tag + 1
            currentY += item.h
            addSubview(item)
        }
        
        let close = closeButton(itemHeight: itemHeight)
        close.y = currentY
        addSubview(close)
        
        backgroundColor = appeareance.backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
 
    
    // MARK: Create
    
    func createItem (title: String, currentY: CGFloat, itemHeight: CGFloat) -> UIView {
        let button = UIButton (frame: CGRect (x: 0, y: currentY, width: frame.size.width, height: itemHeight))
        button.setTitle(title, for: .normal)
        button.setTitleColor(appeareance.tintColor, for: .normal)
        button.titleLabel?.font = appeareance.font
        button.addTarget(self, action: #selector(itemPressed(sender:)), for: .touchUpInside)
        
        let sep = CALayer ()
        sep.frame = CGRect (x: 0, y: button.h, width: button.w, height: appeareance.lineWidth)
        sep.backgroundColor = appeareance.tintColor.cgColor
        button.layer.addSublayer(sep)
        
        return button
    }
    
    func closeButton (itemHeight: CGFloat) -> UIView {
        let button = UIButton (frame: CGRect (x: 0, y: 0, width: frame.size.width, height: itemHeight))
        button.addTarget(self, action: #selector(closePressed(sender:)), for: .touchUpInside)
        
        let close = CAShapeLayer ()
        close.frame = CGRect (x: 0, y: 0, width: 20, height: 20)
        close.position = button.layer.position
        
        let path = UIBezierPath ()
        let a: CGFloat = 20
        path.move(to: CGPoint (x: 0, y: 0))
        path.addLine(to: CGPoint (x: a, y: a))
        path.move(to: CGPoint (x: 0, y: a))
        path.addLine(to: CGPoint (x: a, y: 0))
        
        close.path = path.cgPath
        close.lineWidth = appeareance.lineWidth
        close.strokeColor = appeareance.tintColor.cgColor
        button.layer.addSublayer (close)
        
        return button
    }
    
    
    
    // MARK: Action
    
    @objc func itemPressed (sender: UIButton) {
        
        if isAnimating {
            return
        }
        
        delegate?.droppyMenu(droppyMenu: self, didItemPressedAtIndex: sender.tag)
    }
    
    @objc func closePressed (sender: UIButton) {
        
        if isAnimating {
            return
        }
        
        delegate?.droppyMenuDidClosePressed(droppyMenu: self)
    }

}
