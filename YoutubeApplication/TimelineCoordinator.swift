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
    var timelineViewController: YoutubeTimelineViewController
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    fileprivate let navigationDelegate: ListToDetialTransitioningDelegate?
    fileprivate var viewModel: YoutubeMainTimelineViewModelInput
    
    init(navigationController: UINavigationController) {
        rootNavigationController = navigationController
        viewModel = YoutubeMainTimelineViewModel()
        navigationDelegate = ListToDetialTransitioningDelegate()
        timelineViewController = YoutubeTimelineViewController(viewModel: viewModel, collectionViewLayout: YoutubeCollectionViewFlowLayout())
    }
    
    func start() {
        rootNavigationController.setViewControllers([timelineViewController], animated: false)
        viewModel.coordinator = self
    }
    
    func showYoutubeDetailVC(_ viewModel: YoutubeDetailVideoViewModelInput) {
        let youtubeDetailVC = YoutubeDetailVideoViewController(viewModel: viewModel)
        viewModel.coordinator = self
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
    
    func showYoutubeDetailViewController(_ viewModel: YoutubeDetailVideoViewModelInput) {
        showYoutubeDetailVC(viewModel)
    }
}
extension TimelineCoordinator: YoutubeDetailVideoViewModelCoordinatorDelegate {
    
    func backToYoutubeTimelineViewController(animated: Bool) {
        popNavigationController(animated: animated)
    }
}
