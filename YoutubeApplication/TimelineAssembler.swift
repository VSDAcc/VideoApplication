//
//  TimelineAssembler.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 2/6/19.
//  Copyright © 2019 VladymyrShorokhov. All rights reserved.
//

import Foundation

protocol TimelineAssemblerDelegate: TimelineVideosAssembler & TimelineVideoDetailAssembler { }
class TimelineAssembler: TimelineAssemblerDelegate { }

protocol TimelineVideosAssembler {
    func resolve(with coordinator: YoutubeMainTimelineViewModelCoordinatorDelegate?) -> YoutubeTimelineViewController
    func resolve(with coordinator: YoutubeMainTimelineViewModelCoordinatorDelegate?) -> YoutubeMainTimelineViewModelInput
    func resolve() -> TimelineVideoServicesStrategy
}
extension TimelineVideosAssembler {
    func resolve(with coordinator: YoutubeMainTimelineViewModelCoordinatorDelegate?) -> YoutubeTimelineViewController {
        return YoutubeTimelineViewController(viewModel: resolve(with: coordinator), collectionViewLayout: YoutubeCollectionViewFlowLayout())
    }
    
    func resolve(with coordinator: YoutubeMainTimelineViewModelCoordinatorDelegate?) -> YoutubeMainTimelineViewModelInput {
        return YoutubeMainTimelineViewModel(resolve(), coordinator)
    }
    
    func resolve() -> TimelineVideoServicesStrategy {
        return TimelineVideoService(service: TimelineVideoProvider())
    }
}

protocol TimelineVideoDetailAssembler {
    func resolve(with coordinator: YoutubeDetailVideoViewModelCoordinatorDelegate?, video: YoutubeVideo) -> YoutubeDetailVideoViewController
    func resolve(with coordinator: YoutubeDetailVideoViewModelCoordinatorDelegate?, video: YoutubeVideo) -> YoutubeDetailVideoViewModelInput
}
extension TimelineVideoDetailAssembler {
    func resolve(with coordinator: YoutubeDetailVideoViewModelCoordinatorDelegate?, video: YoutubeVideo) -> YoutubeDetailVideoViewController {
        return YoutubeDetailVideoViewController(viewModel: resolve(with: coordinator, video: video))
    }
    
    func resolve(with coordinator: YoutubeDetailVideoViewModelCoordinatorDelegate?, video: YoutubeVideo) -> YoutubeDetailVideoViewModelInput {
        return YoutubeDetailVideoViewModel(video: video, coordinator)
    }
}
