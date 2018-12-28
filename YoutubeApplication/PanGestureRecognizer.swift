//
//  PanGestureRecognizer.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 12/28/18.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

enum PanDirection {
    case vertical
    case horizontal
}

class PanDirectionGestureRecognizer: UIPanGestureRecognizer {
    
    let direction: PanDirection
    
    init(direction: PanDirection, target: AnyObject, action: Selector) {
        self.direction = direction
        super.init(target: target, action: action)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if state == .began {
            let vel = velocity(in: view)
            switch direction {
            case .horizontal where abs(vel.y) > abs(vel.x) || abs(vel.x) == 0.0:
                state = .cancelled
            case .vertical where abs(vel.x) > abs(vel.y) || abs(vel.y) == 0.0:
                state = .cancelled
            default:
                break
            }
        }
    }
}
