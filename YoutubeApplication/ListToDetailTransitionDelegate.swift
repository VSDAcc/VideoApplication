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
        switch operation {
        case .push:
            return animator
        case .pop:
            return animator
        case .none: return nil
        }
    }
}
