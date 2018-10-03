//
//  TimelineCoordinator.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 09.02.2018.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import UIKit

final class TimelineCoordinator: Coordinator {
    
    func start() {
        let timelineVC = YoutubeTimelineViewController(viewModel: YoutubeMainTimelineViewModel(), collectionViewLayout: YoutubeCollectionViewFlowLayout())
        navigationController?.pushViewController(timelineVC, animated: true)
    }
    
    func openDetail(for youtubeDetailModel: YoutubeVideoModel, animatableYoutubeCells: [UICollectionViewCell]) {
    }
}
