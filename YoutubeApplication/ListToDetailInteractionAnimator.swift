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
    private weak var navigationController: UINavigationController!
    
    init(viewController: UIViewController) {
        super.init()
        guard let navigationController = viewController.navigationController else { return }
        self.navigationController = navigationController
        prepareGestureRecognizer(in: viewController.view!)
        wantsInteractiveStart = false
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(handleGesture(_ :)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func handleGesture(_ sender: UIPanGestureRecognizer) {
        
        guard let navigationController = self.navigationController else { return }
        
        let translation = sender.translation(in: sender.view!.superview!)
        let velocity = sender.velocity(in: sender.view)
        
        var progress = (translation.y / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))

        if progress == 0.0 {
            isInteractionInProgress = false
            cancel()
            return
        }
        
        switch sender.state {
        case .began:
            if velocity.y > 700 {
                cancel()
                return
            }
            isInteractionInProgress = true
            navigationController.popViewController(animated: true)
        case .changed:
            shouldCompleteTransition = progress > 0.5 || velocity.y > 300
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
