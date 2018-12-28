//
//  ListToDetailTransitionDelegate.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 12/24/18.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import Foundation

import UIKit

final class ListToDetialTransitioningDelegate: NSObject {
    
    fileprivate var animator: AnimatedTransitioning!
    fileprivate var interactionController: UIPercentDrivenInteractiveTransition?
    
    init(animator: AnimatedTransitioning = ListToDetailAnimator()) {
        self.animator = animator
    }
}
extension ListToDetialTransitioningDelegate: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let _ = fromVC as? ListToDetailAnimatable, let _ = toVC as? ListToDetailAnimatable else {
                return nil
        }
        animator.operation = operation
        
        switch operation {
        case .push:
            interactionController = ListToDetailInteractionAnimator(viewController: toVC)
            return animator
        case .pop:
            return animator
        case .none: return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == navigationController.viewControllers.first {
            interactionController = nil
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        switch animator.operation {
        case .push:
            return nil
        case .pop:
            return interactionController
        default:
            return nil
        }
    }
}
