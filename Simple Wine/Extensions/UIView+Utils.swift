//
//  UIView+Utils.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 02/10/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import UIKit

extension UIView {
    
    //MARK: - Constraints
    struct OrientationType: OptionSet {
        let rawValue: Int
        
        static let fill             = OrientationType(rawValue: 1 << 0)
        static let vertical         = OrientationType(rawValue: 1 << 1)
        static let horizontal       = OrientationType(rawValue: 1 << 2)
        static let verticalFill:    OrientationType = [.fill, .vertical]
        static let horizontalFill:  OrientationType = [.fill, .horizontal]
    }
    
    func addToSuper(view: UIView){
        if self.superview != view{
            view.addSubview(self)
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view" : self]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view" : self]))
    }
    
    func addDownToSuper(view: UIView){
        if self.superview != view{
            view.addSubview(self)
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(h)-[view(h)]|", options: [], metrics: ["h" : view.frame.height], views: ["view" : self]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view" : self]))
    }
    
    func addVertical(views: [UIView], fill: Bool = false){
        add(views: views, orientation: fill ? .verticalFill : .vertical)
    }
    
    
    func addHorizontal(views: [UIView], fill: Bool = false){
        add(views: views, orientation: fill ? .horizontalFill : .horizontal)
    }
    
    func add(views: [UIView], orientation: OrientationType){
        var ms = String()
        var mdi = [String : UIView]()
        ms.append( orientation.contains(.vertical) ? "V:|" : "H:|")
        for (idx, view) in views.enumerated() {
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            let s = "view\(idx)"
            let v = (orientation.contains(.vertical)) ? "\(view.frame.width)" : "\(view.frame.height)"
            let f = (orientation.contains(.vertical)) ? "H:|[\(s)(\(v))]|" : "V:|[\(s)(\(v))]|"
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: f, options: [], metrics: nil, views: [s : view]))
            if (orientation.contains(OrientationType.fill)){
                ms.append("[\(s)(\(idx==0 ? ">=40" : "==view0"))]")
            }else{
                ms.append("[\(s)(\( orientation.contains(.vertical) ? view.frame.size.height : view.frame.size.width))]")
            }
            mdi[s] = view
        }
        ms.append("|")
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: ms, options: [], metrics: nil, views: mdi))
        
    }
    
    func insert(views: [UIView], after view: UIView){
        var constraint: NSLayoutConstraint? = nil
        var bottomView: UIView? = nil;
        for con in constraints{
            if let firstItem = con.firstItem as? UIView, firstItem == view && con.firstAttribute == NSLayoutConstraint.Attribute.bottom, let secondItem = con.secondItem as? UIView {
                bottomView = secondItem
                constraint = con
            }
            if let secondItem = con.secondItem as? UIView, secondItem == view && con.secondAttribute == NSLayoutConstraint.Attribute.bottom, let firstItem = con.firstItem as? UIView {
                bottomView = firstItem
                constraint = con
            }
            
        }
        
        if bottomView == self {
            bottomView = nil
        }
        
        var mdi = ["topView": view]
        if let _ = bottomView {
            mdi["bottomView"] = bottomView
        }
        var ms: String = "V:[topView]"
        
        for (index, v) in views.enumerated() {
            self.addSubview(v)
            v.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view" : v]))
            ms.append("[view\(index)(\(v.frame.size.height))]")
            mdi["view\(index)"] = v
        }
        if let con = constraint {
            self.removeConstraint(con)
        }
        
        if let _ = bottomView {
            ms.append("[bottomView]")
        } else {
            ms.append("|")
        }
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: ms, options: [], metrics: nil, views: mdi))
    }
    
    func insert(views: [UIView], from start: UIView, to end: UIView){
        var mdi = ["topView" : start, "bottomView" : end]
        var ms = "V:[topView]-"
        
        for (index, v) in views.enumerated() {
            self.addSubview(v)
            v.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view" : v]))
            ms.append("[view\(index)]-")
            mdi["view\(index)"] = v
        }
        ms.append("[bottomView]")
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: ms, options: [], metrics: nil, views: mdi))
    }
    
    func setConstraint(top : CGFloat){
        guard let superview = self.superview else { return }
        for constraint in superview.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .top {
                constraint.constant = top
            }
            if let secondItem = constraint.secondItem as? UIView, secondItem == self, constraint.secondAttribute == .top {
                constraint.constant = top
            }
            
        }
    }
    
    func setConstraint(left : CGFloat){
        guard let superview = self.superview else { return }
        for constraint in superview.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .leading {
                constraint.constant = left
            }
            if let secondItem = constraint.secondItem as? UIView, secondItem == self, constraint.secondAttribute == .leading {
                constraint.constant = left
            }
        }
    }
    
    func setConstraint(bottom : CGFloat){
        guard let superview = self.superview else { return }
        for constraint in superview.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .bottom {
                constraint.constant = bottom
            }
            if let secondItem = constraint.secondItem as? UIView, secondItem == self, constraint.secondAttribute == .bottom {
                constraint.constant = bottom
            }
            
        }
    }
    
    func setConstraint(right : CGFloat){
        guard let superview = self.superview else { return }
        for constraint in superview.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .trailing {
                constraint.constant = right
            }
            if let secondItem = constraint.secondItem as? UIView, secondItem == self, constraint.secondAttribute == .trailing {
                constraint.constant = right
            }
        }
    }
    
    func setConstraint(height : CGFloat){
        for constraint in self.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .height {
                constraint.constant = height
                return
            }
        }
        guard let superview = self.superview else { return }
        for constraint in superview.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .height {
                constraint.constant = height
            }
        }
    }
    
    func setConstraint(width : CGFloat){
        for constraint in self.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .width {
                constraint.constant = width
            }
        }
    }
    
    func setConstraint(centerY : CGFloat){
        guard let superview = self.superview else { return }
        for constraint in superview.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .centerY {
                constraint.constant = centerY
            }
            if let secondItem = constraint.secondItem as? UIView, secondItem == self, constraint.secondAttribute == .centerY {
                constraint.constant = centerY
            }
        }
    }
    
    func constraintTop() ->  CGFloat{
        guard let superview = self.superview else { return 0 }
        for constraint in superview.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .top {
                return constraint.constant
            }
            if let secondItem = constraint.secondItem as? UIView, secondItem == self, constraint.secondAttribute == .top {
                return constraint.constant
            }
        }
        return 0
    }
    
    func constraintBottom() -> CGFloat{
        guard let superview = self.superview else { return 0 }
        for constraint in superview.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .bottom {
                return constraint.constant
            }
            if let secondItem = constraint.secondItem as? UIView, secondItem == self, constraint.secondAttribute == .bottom {
                return constraint.constant
            }
        }
        return 0
    }
    
    func constraint(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint?{
        guard let superview = self.superview else { return nil }
        
        var check = attribute
        if check == .left { check = .leading }
        if check == .right { check = .trailing }
        for constraint in superview.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == check {
                return constraint
            }
            if let secondItem = constraint.secondItem as? UIView, secondItem == self, constraint.secondAttribute == check {
                return constraint
            }
        }
        return nil
    }
    
    func constraintLeft() -> CGFloat{
        guard let superview = self.superview else { return 0 }
        for constraint in superview.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .leading {
                return constraint.constant
            }
            if let secondItem = constraint.secondItem as? UIView, secondItem == self, constraint.secondAttribute == .leading {
                return constraint.constant
            }
        }
        return 0
    }
    
    func constraintRight() -> CGFloat{
        guard let superview = self.superview else { return 0 }
        for constraint in superview.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .trailing {
                return constraint.constant
            }
            if let secondItem = constraint.secondItem as? UIView, secondItem == self, constraint.secondAttribute == .trailing {
                return constraint.constant
            }
        }
        return 0
    }
    
    func constraintCenterY() -> CGFloat {
        guard let superview = self.superview else { return 0 }
        for constraint in superview.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .centerY {
                return constraint.constant
            }
            if let secondItem = constraint.secondItem as? UIView, secondItem == self, constraint.secondAttribute == .centerY {
                return constraint.constant
            }
        }
        return 0
    }
    
    func constraintHeight() -> CGFloat{
        for constraint in self.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .height {
                return constraint.constant
            }
        }
        return 0
    }
    
    func constraintWidth() -> CGFloat{
        for constraint in self.constraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == self, constraint.firstAttribute == .width {
                return constraint.constant
            }
        }
        return 0
    }
    
    func setConstraint(frame: CGRect){
        setConstraint(left: frame.origin.x)
        setConstraint(top: frame.origin.y)
        setConstraint(width: frame.width)
        setConstraint(height: frame.height)
    }
    
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: convertFromCATransitionType(CATransitionType.fade))
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionType(_ input: CATransitionType) -> String {
    return input.rawValue
}

