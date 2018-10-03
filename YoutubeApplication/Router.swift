//
//  Router.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 03.02.2018.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import UIKit

protocol Animator: UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool {get set}
}
protocol Transition: class {
    var viewController: UIViewController? {get set}
    
    func open(_ viewController: UIViewController)
    func close(_ viewController: UIViewController)
}
class ModalTransition: NSObject {
    var animator: Animator?
    var isAnimated: Bool = true
    
    var modalTransitionStyle: UIModalTransitionStyle
    var modalPresentationStyle: UIModalPresentationStyle
    
    var completionHandler: (() -> Void)?
    
    weak var viewController: UIViewController?
    
    init(animator: Animator? = nil,
         isAnimated: Bool = true,
         modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
         modalPresentationStyle: UIModalPresentationStyle = .fullScreen) {
        self.animator = animator
        self.isAnimated = isAnimated
        self.modalTransitionStyle = modalTransitionStyle
        self.modalPresentationStyle = modalPresentationStyle
    }
}
extension ModalTransition: Transition {
    
    func open(_ viewController: UIViewController) {
        viewController.transitioningDelegate = self
        viewController.modalTransitionStyle = modalTransitionStyle
        viewController.modalPresentationStyle = modalPresentationStyle
        
        self.viewController?.present(viewController, animated: isAnimated, completion: completionHandler)
    }
    
    func close(_ viewController: UIViewController) {
        viewController.dismiss(animated: isAnimated, completion: completionHandler)
    }
}
extension ModalTransition: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = animator else {
            return nil
        }
        animator.isPresenting = true
        return animator
        
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = animator else {
            return nil
        }
        animator.isPresenting = false
        return animator
    }
}
class PushTransition: NSObject {
    var animator: Animator?
    var isAnimated: Bool = true
    var completionHandler: (() -> Void)?
    
    weak var viewController: UIViewController?
    
    init(animator: Animator? = nil, isAnimated: Bool = true) {
        self.animator = animator
        self.isAnimated = isAnimated
    }
}
extension PushTransition: Transition {
    
    func open(_ viewController: UIViewController) {
        self.viewController?.navigationController?.delegate = self
        self.viewController?.navigationController?.pushViewController(viewController, animated: isAnimated)
    }
    
    func close(_ viewController: UIViewController) {
        self.viewController?.navigationController?.popViewController(animated: isAnimated)
    }
}
extension PushTransition: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        completionHandler?()
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = animator else {
            return nil
        }
        if operation == .push {
            animator.isPresenting = true
            return animator
        }
        else {
            animator.isPresenting = false
            return animator
        }
    }
}
protocol Closable: class {
    func close()
}
protocol RouterProtocol: class {
    associatedtype V: UIViewController
    var viewController: V? {get}
    func open(_ viewController: UIViewController, transition: Transition)
}
class Router<U>: RouterProtocol, Closable where U: UIViewController {
    
    typealias V = U
    weak var viewController: V?
    var openTransition: Transition?
    
    func open(_ viewController: UIViewController, transition: Transition) {
        transition.viewController = self.viewController
        transition.open(viewController)
    }
    
    func close() {
        guard let openTransition = openTransition else {
            assertionFailure("You should soecify an open transition in order to close a module")
            return
        }
        guard let viewController = viewController else {
            assertionFailure("Nothing to close")
            return
        }
        openTransition.close(viewController)
    }
}

