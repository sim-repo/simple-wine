//
//  UIViewController+Keyboard.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 03/10/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import UIKit
import ObjectiveC

extension UIViewController {
    
    @IBOutlet weak var main: UIScrollView? {
        get { return objc_getAssociatedObject(self, &kMainScroll) as? UIScrollView }
        set {
            objc_setAssociatedObject(self, &kMainScroll, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            let nc = NotificationCenter.default
            nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            nc.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
            nc.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
            
            nc.addObserver(self, selector: #selector(UIViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            nc.addObserver(self, selector: #selector(UIViewController.keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
            nc.addObserver(self, selector: #selector(UIViewController.keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
            nc.addObserver(self, selector: #selector(UIViewController.keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
            
            if tap == nil {
                let _tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.tapMain(_:)))
                _tap.delegate = self
                tap = _tap
            }
        }
    }
    
    var tap: UITapGestureRecognizer? {
        get { return objc_getAssociatedObject(self, &kTap) as? UITapGestureRecognizer }
        set {
            objc_setAssociatedObject(self, &kTap, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    @objc func tapMain(_ recognizer: UITapGestureRecognizer){
        hideKeyboard()
    }
    
}

// mark - KeyboardEvent
extension UIViewController{
    
    @objc func keyboardWillShow(_ notification: Notification ){
        guard let main = main else { return }
        guard let userInfo = notification.userInfo as? [String : Any] else { return }
        
        if let beginRect = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect, let endRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, beginRect.equalTo(endRect) {
            return
        }
        
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardSize = keyboardFrame.size
        
        let dec = bottomSpace(main)
        UIView.animate(withDuration: duration, animations: {
            main.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardSize.height - dec, right: 0)
        }) { (finished) in
            if let tap = self.tap {
                main.addGestureRecognizer(tap)
            }
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification ){
        guard let main = main else { return }
        guard let userInfo = notification.userInfo as? [String : Any] else { return }
        
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: duration, animations: {
            main.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        }) { (finished) in
            if let tap = self.tap {
                main.removeGestureRecognizer(tap)
            }
        }
    }
    
    @objc func keyboardWasShown(_ notification: Notification ){
        
    }
    
    @objc func keyboardDidHide(_ notification: Notification ){
        
    }
    
    func bottomSpace(_ main: UIScrollView) -> CGFloat {
        var bottom: CGFloat = 0
        var v: UIView = main
        while v.superview != nil && !v.isEqual(view) {
            bottom = bottom + (v.superview!.frame.height - v.frame.maxY)
            v = v.superview!
        }
        return bottom
    }
}

extension UIViewController: UIGestureRecognizerDelegate{
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return String(describing: touch.view) != "UITableViewCellContentView" && String(describing: touch.view) != "UIButton"
    }
    
}

private var kMainScroll: UInt8 = 0
private var kTap: UInt8 = 1

extension UIViewController {
    
    @objc func extension_viewWillAppear(_ animated: Bool) {
        self.extension_viewWillAppear(animated)
    }
    
    @objc func extension_viewWillDisappear(_ animated: Bool) {
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        
        self.extension_viewWillDisappear(animated)
    }
    
    
    static func doInitialize(){
        
        if self !== UIViewController.self {
            return
        }
        
        let _: () = {
            UIViewController.swizz(original: #selector(UIViewController.viewWillAppear(_:)), swizzled: #selector(UIViewController.extension_viewWillAppear(_:)))
            UIViewController.swizz(original: #selector(UIViewController.viewWillDisappear(_:)), swizzled: #selector(UIViewController.extension_viewWillDisappear(_:)))
        }()
    }
    
    static func swizz(original: Selector, swizzled: Selector){
        let originalMethod = class_getInstanceMethod(self, original)
        let swizzledMethod = class_getInstanceMethod(self, swizzled)
        
        let didAddMethod = class_addMethod(self, original, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(self, swizzled, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
    
}
