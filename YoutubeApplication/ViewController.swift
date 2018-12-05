//
//  ViewController.swift
//  UranC.TestApp
//
//  Created by Vladymyr on 11/26/18.
//  Copyright © 2018 VSDAcc. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentWithDarken(_ viewController: UIViewController, completion: (() -> Void)?) {
        
        guard self.presentedViewController == nil && self.view.window != nil else {
            return
        }
        
        let screenBounds = UIScreen.main.bounds
        let darkenView = UIView(frame: screenBounds)
        darkenView.isUserInteractionEnabled = false
        darkenView.backgroundColor = UIColor.black
        darkenView.alpha = 0.0
        darkenView.tag = 9991
        
        UIApplication.shared.keyWindow?.addSubview(darkenView)
        
        UIView.animate(withDuration: 0.25) {
            darkenView.alpha = 0.5
        }
        
        viewController.modalPresentationStyle = .overFullScreen
        
        self.present(viewController, animated: true, completion: completion)
    }
    
    func dismissWithDarken(_ viewController: UIViewController, completion: (() -> Void)?) {
        
        if let darkenView = UIApplication.shared.keyWindow?.subviews.filter({ $0.tag == 9991 }).last {
            UIView.animate(withDuration: 0.25, animations: {
                darkenView.alpha = 0.0
            }, completion: { (finished) in
                darkenView.removeFromSuperview()
            })
        }
        
        viewController.dismiss(animated: true, completion: completion)
    }
}
extension UITabBarController {
    open override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
}

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
}
