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
    func resolve() -> TimelineHomeVideoServicesInput
    func resolve() -> TimelineTrendingVideoServicesInput
    func resolve() -> TimelineAccountVideoServicesInput
    func resolve() -> TimelineSubscriptionVideoServicesInput
}
extension TimelineVideosAssembler {
    func resolve(with coordinator: YoutubeMainTimelineViewModelCoordinatorDelegate?) -> YoutubeTimelineViewController {
        return YoutubeTimelineViewController(viewModel: resolve(with: coordinator), collectionViewLayout: YoutubeCollectionViewFlowLayout())
    }
    
    func resolve(with coordinator: YoutubeMainTimelineViewModelCoordinatorDelegate?) -> YoutubeMainTimelineViewModelInput {
        return YoutubeMainTimelineViewModel(resolve(), resolve(), resolve(), resolve(), coordinator)
    }
    
    func resolve() -> TimelineHomeVideoServicesInput {
        return TimelineHomeVideoServices()
    }
    
    func resolve() -> TimelineTrendingVideoServicesInput {
        return TimelineTrendingVideoServices()
    }
    
    func resolve() -> TimelineAccountVideoServicesInput {
        return TimelineAccountVideoServices()
    }
    
    func resolve() -> TimelineSubscriptionVideoServicesInput {
        return TimelineSubscriptionVideoServices()
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
