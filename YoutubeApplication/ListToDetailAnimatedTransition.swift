//
//  ListToDetailAnimatedTransition.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 12/24/18.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import UIKit

protocol AnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    var duration : TimeInterval { get }
}

protocol ListToDetailAnimatable {
    var morphViews: [UIView] { get }
    var animatableCells: [UICollectionViewCell] { get }
}
