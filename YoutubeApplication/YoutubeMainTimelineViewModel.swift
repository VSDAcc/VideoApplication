//
//  YoutubeMainTimelineViewModel.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 09.02.2018.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import Foundation
import UIKit

protocol YoutubeMainTimelineViewModelCoordinatorDelegate: class {
    func showYoutubeDetailViewController(_ viewModel: YoutubeDetailVideoViewModelInput)
}
protocol YoutubeMainTimelineViewModelInput {
    var coordinator: YoutubeMainTimelineViewModelCoordinatorDelegate? {get set}
    func loadHomeVideoData()
    func updateHomeVideoData()
}
class YoutubeMainTimelineViewModel: YoutubeMainTimelineViewModelInput {
    
    weak var coordinator: YoutubeMainTimelineViewModelCoordinatorDelegate?
    
    fileprivate var timelineHomeVideoServices: TimelineHomeVideoServicesInput
    
    //MARK:-Loading
    init(_ timelineHomeVideoServices :TimelineHomeVideoServicesInput = TimelineHomeVideoServices()) {
        self.timelineHomeVideoServices = timelineHomeVideoServices
    }
    
    func loadHomeVideoData() {

    }
    
    func updateHomeVideoData() {

    }
}
