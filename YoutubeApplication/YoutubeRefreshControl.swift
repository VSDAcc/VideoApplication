//
//  YoutubeRefreshControl.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 23.01.2018.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import UIKit

class YoutubeRefreshControl: UIControl {
    
    weak var containingScrollView: UIScrollView!
    fileprivate var hasReachedThreshold = false
    private var refreshing = false
    private let heartImageView = UIImageView(image: UIImage(named:"icons8-heart-outline-50"))
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let scrollView = superview as? UIScrollView else {
            assertionFailure("Can only add to a scrollView")
            return
        }
        heartImageView.isHidden = true
        containingScrollView = scrollView
        bounds.size = heartImageView.bounds.size
        center = CGPoint(x: scrollView.bounds.midX, y: -bounds.height / 2)
        addSubview(heartImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        center = CGPoint(x: containingScrollView.bounds.midX, y: -bounds.height / 2)
    }
    
    func containingScrollViewDidScroll(scrollView: UIScrollView) {
        if refreshing { return }
        let offset = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        let maxOffset: CGFloat = 100.0
        let scale = min(offset / maxOffset, 1.0)
        heartImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        heartImageView.isHidden = false
        hasReachedThreshold = offset > maxOffset
    }
    
    func containingScrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate: Bool) {
        if hasReachedThreshold {
            sendActions(for: .valueChanged)
            beginRefreshing()
        }
    }
    
    func beginRefreshing() {
        if refreshing { return }
        refreshing = true
        let offset = containingScrollView.contentOffset
        UIView.animate(withDuration: 0) {
            self.containingScrollView.contentInset.top += self.heartImageView.bounds.height
            self.containingScrollView.contentOffset = offset
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.heartImageView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }, completion: nil)
    }
    
    func endRefreshing() {
        if !refreshing { return }
        UIView.animate(withDuration: 0.25, animations: {
            self.containingScrollView.contentInset.top -= self.heartImageView.bounds.height
        }) { (finished) in
            self.refreshing = false
            self.heartImageView.layer.removeAllAnimations()
            self.heartImageView.isHidden = true
        }
    }
}
