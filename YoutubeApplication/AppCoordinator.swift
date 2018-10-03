//
//  AppCoordinator.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 09.02.2018.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import UIKit

protocol RootCoordinator: class {
    var childCoordinators: [Coordinator] {get set}
    func removeCoordinator(coordinator:Coordinator)
}
extension RootCoordinator {
    
    func removeCoordinator(coordinator: Coordinator) {
        
        var idx:Int?
        for (index,value) in childCoordinators.enumerated() {
            if value === coordinator {
                idx = index
                break
            }
        }
        
        if let index = idx {
            childCoordinators.remove(at: index)
        }
    }
}
protocol Coordinator: class {
    func start()
}

final class AppCoordinator: NSObject, RootCoordinator, Coordinator {
    
    fileprivate let navigationController: UINavigationController
    fileprivate let navigationDelegate: ListToDetailAnimator?
    
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationDelegate = ListToDetailAnimator()
        super.init()
        self.navigationController.delegate = self
        self.configureNavigationBar()
    }
    
    func start() {
        showTimelineViewController()
    }
    
    func showTimelineViewController() {
        let timelineCoordinator = TimelineCoordinator(navigationController: navigationController)
        timelineCoordinator.rootCoordinator = self
        timelineCoordinator.start()
        childCoordinators.append(timelineCoordinator)
    }
    
    private func configureNavigationBar() {
        navigationController.navigationBar.barTintColor = UIColor(r: 230, g: 32, b: 31, alpha: 1)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
extension AppCoordinator: TimelineCoordinatorDelegate {
    
}
extension AppCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return navigationDelegate
    }
}
