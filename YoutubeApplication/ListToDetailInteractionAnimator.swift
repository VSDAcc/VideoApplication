//
//  ListToDetailInteractionAnimator.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 12/26/18.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import UIKit

class ListToDetailInteractionAnimator: UIPercentDrivenInteractiveTransition {
    
    var isInteractionInProgress: Bool = false
    private var shouldCompleteTransition: Bool = false
    private weak var viewController: UINavigationController!
    
    init(viewController: UINavigationController) {
        super.init()
        self.viewController = viewController
        prepareGestureRecognizer(in: viewController.topViewController!.view)
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_ :)))
        gesture.edges = .top
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func handleGesture(_ sender: UIPanGestureRecognizer) {
        
        wantsInteractiveStart = false
        
        let translation = sender.translation(in: sender.view!.superview!)
        var progress = (translation.x / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch sender.state {
        case .began:
            isInteractionInProgress = true
            viewController.popViewController(animated: true)
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
        case .cancelled:
            isInteractionInProgress = false
            cancel()
        case .ended:
            isInteractionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default: break
        }
    }
}
