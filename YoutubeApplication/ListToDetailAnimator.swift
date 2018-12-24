//
//  ListToDetailAnimator.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 24.01.2018.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import UIKit

protocol ListToDetailAnimatable {
    var morphViews: [UIView] { get }
    var animatableCells: [UICollectionViewCell] { get }
}
class ListToDetailAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        let toView = transitionContext.view(forKey: .to)!
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        toView.frame = transitionContext.finalFrame(for: toViewController)
        toView.layoutIfNeeded()
        
        let canvas = UIView(frame: containerView.bounds)
        canvas.backgroundColor = toView.backgroundColor
        containerView.addSubview(canvas)
        
        let fromAnimatable = fromViewController as! ListToDetailAnimatable
        let toAnimatable = toViewController as! ListToDetailAnimatable
        
        let outgoingSnapshots = canvas.snapshotViews(views: fromAnimatable.animatableCells, afterUpdates: true)
        let incomingSnapshots = canvas.snapshotViews(views: toAnimatable.morphViews, afterUpdates: true)
        //let scaleTransform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        for view in incomingSnapshots {
            //view.transform  = scaleTransform
            view.alpha = 0
            view.layer.cornerRadius = 12.0
            view.layer.masksToBounds = true
        }
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                for view in outgoingSnapshots {
                   // view.transform = scaleTransform
                    view.alpha = 0
                    view.layer.cornerRadius = 0.0
                    view.layer.masksToBounds = true
                }
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                for view in incomingSnapshots {
                    view.transform = CGAffineTransform.identity
                    view.layer.cornerRadius = 12.0
                    view.layer.masksToBounds = true
                    view.alpha = 1
                }
            })
        }, completion: { (finished) in
            canvas.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        animateMorphViews(views: Array(zip(fromAnimatable.morphViews, toAnimatable.morphViews)), canvas: canvas)
    }
    
    private func animateMorphViews(views: [(fromView: UIView, toView: UIView)], canvas: UIView) {
        views.forEach({animateMorhpFromView(view: $0.fromView, toView: $0.toView, canvas: canvas)})
    }
    
    private func animateMorhpFromView(view: UIView, toView: UIView, canvas: UIView) {
        let fromView = canvas.snapshotView(view: view, afterUpdates: false)
        let toView = canvas.snapshotView(view: toView, afterUpdates: true)
        
        let targetCenter = toView.center
        toView.alpha = 0
        toView.transform = fromView.scaleSnapshotToView(toView: toView)
        toView.center = fromView.center
        toView.layer.cornerRadius = 12.0
        toView.layer.masksToBounds = true
        
        UIView.animate(withDuration: duration) {
            fromView.alpha = 0
            fromView.transform = toView.transform.inverted()
            fromView.center = targetCenter
            fromView.layer.cornerRadius = 0.0
            fromView.layer.masksToBounds = true
            
            toView.layer.cornerRadius = 12.0
            toView.layer.masksToBounds = true
            toView.alpha = 1
            toView.transform = CGAffineTransform.identity
            toView.center = targetCenter
        }
    }
}
