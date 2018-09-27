//
//  AppCoordinator.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 09.02.2018.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import UIKit
final class AppCoordinator: Coordinator {
    func start() {
        let coordinator = TimelineCoordinator(navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    func openDetail(for youtubeDetailModel: YoutubeVideoModel, animatableYoutubeCells: [UICollectionViewCell]) {
        let coordinator = TimelineCoordinator(navigationController: navigationController)
        coordinator.openDetail(for: youtubeDetailModel, animatableYoutubeCells: animatableYoutubeCells)
        childCoordinators.append(coordinator)
    }
}
