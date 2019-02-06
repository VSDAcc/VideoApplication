//
//  TimelineCoordinator.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 09.02.2018.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import UIKit

protocol TimelineCoordinatorDelegate: class {
}
final class TimelineCoordinator: Coordinator, RootCoordinator {
    
    weak var rootCoordinator: TimelineCoordinatorDelegate?
    
    let rootNavigationController: UINavigationController
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    fileprivate let navigationDelegate: ListToDetialTransitioningDelegate?
    fileprivate var timelineAssembler: TimelineAssemblerDelegate
    fileprivate var timelineViewController: YoutubeTimelineViewController!
    
    init(navigationController: UINavigationController) {
        rootNavigationController = navigationController
        navigationDelegate = ListToDetialTransitioningDelegate()
        timelineAssembler = TimelineAssembler()
    }
    
    func start() {
        timelineViewController = timelineAssembler.resolve(with: self)
        rootNavigationController.setViewControllers([timelineViewController], animated: false)
    }
    
    func showYoutubeDetailVC(_ video: YoutubeVideo) {
        let youtubeDetailVC: YoutubeDetailVideoViewController = timelineAssembler.resolve(with: self, video: video)
        rootNavigationController.delegate = navigationDelegate
        youtubeDetailVC.animatableYoutubeCells = timelineViewController.animatableCells
        rootNavigationController.show(youtubeDetailVC, sender: self)
    }
    
    func popNavigationController(animated: Bool) {
        rootNavigationController.popViewController(animated: animated)
        rootNavigationController.delegate = nil
    }
}
extension TimelineCoordinator: TimelineCoordinatorDelegate {
    
}
extension TimelineCoordinator: YoutubeMainTimelineViewModelCoordinatorDelegate {
    
    func showYoutubeDetailViewController(_ video: YoutubeVideo) {
        showYoutubeDetailVC(video)
    }
}
extension TimelineCoordinator: YoutubeDetailVideoViewModelCoordinatorDelegate {
    
    func backToYoutubeTimelineViewController(animated: Bool) {
        popNavigationController(animated: animated)
    }
}
